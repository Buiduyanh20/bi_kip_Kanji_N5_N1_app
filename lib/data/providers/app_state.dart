import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/data/models/app_settings.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/favorite.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/repositories/backup_repository.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

// ───────── Giá trị khởi tạo, nạp sẵn trong main() ─────────
// Nhờ vậy màn hình đọc state đồng bộ, không phải xử lý AsyncValue.

final initialProgressProvider = Provider<Map<String, ItemProgress>>(
      (ref) => throw UnimplementedError('initialProgressProvider'),
);

final initialSettingsProvider = Provider<AppSettings>(
      (ref) => throw UnimplementedError('initialSettingsProvider'),
);

// ───────── Progress ─────────
// Không dùng ref.invalidate(progressProvider): build() trả về giá trị khởi tạo cũ.
// Muốn nạp lại thì gọi reloadFromDb().

class ProgressNotifier extends Notifier<Map<String, ItemProgress>> {
  @override
  Map<String, ItemProgress> build() => ref.read(initialProgressProvider);

  /// Port của `recordAnswer` + `updateAnswerResult` bên web.
  Future<void> recordAnswer({
    required ContentItem item,
    required LearnMethod method,
    required bool isCorrect,
  }) async {
    var current = state[item.id] ??
        ItemProgress(itemId: item.id, type: item.type, level: item.level);
    if (current.level == null) {
      current = ItemProgress(
        itemId: current.itemId,
        type: current.type,
        level: item.level,
        methods: current.methods,
      );
    }
    final updated = current.recordAnswer(method, isCorrect: isCorrect);
    state = {...state, item.id: updated};
    try {
      await ref.read(progressRepositoryProvider).upsert(updated, method);
    } catch (e, st) {
      // Tiến độ vẫn nằm trong bộ nhớ, không làm hỏng phiên quiz.
      debugPrint('Không ghi được tiến độ: $e\n$st');
    }
  }

  Future<void> reloadFromDb() async {
    state = await ref.read(progressRepositoryProvider).loadAll();
  }
}

final progressProvider =
NotifierProvider<ProgressNotifier, Map<String, ItemProgress>>(
  ProgressNotifier.new,
);

// ───────── Settings ─────────

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.read(initialSettingsProvider);

  Future<void> setUserName(String name) async {
    final clean = AppSettings.sanitizeUserName(name);
    state = state.copyWith(userName: clean);
    await ref.read(settingsRepositoryProvider).setUserName(clean);
  }

  Future<void> setLastLearningOptions(
      LearnMethod method,
      CountChoice count,
      ) async {
    state = state.copyWith(lastMethod: method, lastCount: count);
    await ref
        .read(settingsRepositoryProvider)
        .setLastLearningOptions(method, count);
  }

  Future<void> reloadFromDb() async {
    state = await ref.read(settingsRepositoryProvider).load();
  }
}

final settingsProvider =
NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

// ───────── Favorites ─────────

final favoritesProvider = StreamProvider<List<Favorite>>(
      (ref) => ref.watch(favoriteRepositoryProvider).watchAll(),
);

/// Để mọi nút tim tự cập nhật: `ref.watch(favoriteIdsProvider).contains(id)`.
final favoriteIdsProvider = Provider<Set<String>>((ref) {
  final list = ref.watch(favoritesProvider).valueOrNull ?? const <Favorite>[];
  return {for (final f in list) f.kanjiId};
});

// ───────── Backup / Reset ─────────

class BackupActions {
  BackupActions(this._ref);
  final Ref _ref;

  BackupRepository get _repo => _ref.read(backupRepositoryProvider);

  /// Trả về file để đưa vào share_plus.
  Future<File> exportToFile() => _repo.exportToTempFile();

  /// Ném BackupFormatException nếu file sai định dạng.
  Future<ImportSummary> importFromText(String text) async {
    final summary = await _repo.importFromString(text);
    await _reloadState();
    return summary;
  }

  Future<void> resetAll() async {
    await _repo.resetAll();
    await _reloadState();
  }

  Future<void> _reloadState() async {
    await _ref.read(progressProvider.notifier).reloadFromDb();
    await _ref.read(settingsProvider.notifier).reloadFromDb();
    // favoritesProvider là Stream nên tự cập nhật.
  }
}

final backupActionsProvider = Provider<BackupActions>(BackupActions.new);