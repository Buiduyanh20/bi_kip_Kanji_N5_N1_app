import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:bikip_kanji_app/core/database/app_database.dart';
import 'package:bikip_kanji_app/core/logic/backup_codec.dart';
import 'package:bikip_kanji_app/data/repositories/content_repository.dart';
import 'package:bikip_kanji_app/data/repositories/favorite_repository.dart';
import 'package:bikip_kanji_app/data/repositories/progress_repository.dart';
import 'package:bikip_kanji_app/data/repositories/settings_repository.dart';

class ImportSummary {
  const ImportSummary({
    required this.progressItems,
    required this.favorites,
    required this.settingsApplied,
    required this.skipped,
  });

  final int progressItems;

  /// null = file không chứa favorites (vd file từ web), dữ liệu cũ được giữ.
  final int? favorites;
  final bool settingsApplied;
  final int skipped;
}

class BackupRepository {
  BackupRepository({
    required AppDatabase db,
    required ProgressRepository progress,
    required FavoriteRepository favorites,
    required SettingsRepository settings,
    required ContentRepository content,
  }) : _db = db,
       _progress = progress,
       _favorites = favorites,
       _settings = settings,
       _content = content;

  /// Trùng tên file xuất của web.
  static const fileName = 'bikip-kanji-progress.json';

  final AppDatabase _db;
  final ProgressRepository _progress;
  final FavoriteRepository _favorites;
  final SettingsRepository _settings;
  final ContentRepository _content;

  Future<String> exportToString() async {
    final data = BackupData(
      items: await _progress.loadAll(),
      favorites: await _favorites.getAll(),
      settings: await _settings.load(),
      exportedAt: DateTime.now(),
    );
    return encodeBackup(data);
  }

  /// Ghi ra thư mục tạm để đưa cho share_plus.
  Future<File> exportToTempFile() async {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, fileName));
    return file.writeAsString(await exportToString());
  }

  /// Ném [BackupFormatException] nếu file sai định dạng (chưa ghi gì vào DB).
  Future<ImportSummary> importFromString(String text) async {
    final result = decodeBackup(
      text,
      isKnown: (type, id) => _content.itemById(type, id) != null,
    );
    final data = result.data;

    await _db.transaction(() async {
      await _progress.replaceAll(data.items);
      if (data.favorites != null) await _favorites.replaceAll(data.favorites!);
      if (data.settings != null) await _settings.applyImported(data.settings!);
    });

    return ImportSummary(
      progressItems: data.items.length,
      favorites: data.favorites?.length,
      settingsApplied: data.settings != null,
      skipped: result.skipped,
    );
  }

  /// Xóa toàn bộ dữ liệu người dùng.
  Future<void> resetAll() => _db.transaction(() async {
    await _progress.clear();
    await _favorites.clear();
    await _settings.clear();
  });
}
