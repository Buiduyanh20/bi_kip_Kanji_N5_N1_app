import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/core/logic/mastery.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/content_repository.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

class SettingsStats {
  const SettingsStats({
    required this.kanjiMastered,
    required this.kanjiTotal,
    required this.vocabMastered,
    required this.vocabTotal,
    required this.reviewItems,
    required this.favorites,
    required this.answered,
    required this.correct,
  });

  final int kanjiMastered;
  final int kanjiTotal;
  final int vocabMastered;
  final int vocabTotal;

  /// Số chữ (không phải số câu) đang cần ôn.
  final int reviewItems;
  final int favorites;

  /// Tổng số câu đã trả lời và số câu đúng, cộng dồn mọi phương pháp.
  final int answered;
  final int correct;

  int get accuracyPercent =>
      answered == 0 ? 0 : (correct * 100 / answered).round();
}

SettingsStats computeSettingsStats({
  required ContentRepository content,
  required Map<String, ItemProgress> progress,
  required int favoriteCount,
}) {
  var kanjiMastered = 0, kanjiTotal = 0, vocabMastered = 0, vocabTotal = 0;

  for (final type in ContentType.values) {
    for (final level in JlptLevel.values) {
      final items = content.itemsByLevel(type, level);
      if (items.isEmpty) continue;
      final summaries = summarizeByLevel(
        content: items,
        contentType: type,
        methods: content.availableMethods(type, level),
        items: progress,
      );
      for (final s in summaries) {
        if (type == ContentType.kanji) {
          kanjiMastered += s.mastered;
          kanjiTotal += s.total;
        } else {
          vocabMastered += s.mastered;
          vocabTotal += s.total;
        }
      }
    }
  }

  var answered = 0, correct = 0;
  for (final item in progress.values) {
    for (final mp in item.methods.values) {
      answered += mp.correct + mp.wrong;
      correct += mp.correct;
    }
  }

  return SettingsStats(
    kanjiMastered: kanjiMastered,
    kanjiTotal: kanjiTotal,
    vocabMastered: vocabMastered,
    vocabTotal: vocabTotal,
    reviewItems: getMistakes(progress).map((m) => m.itemId).toSet().length,
    favorites: favoriteCount,
    answered: answered,
    correct: correct,
  );
}

final settingsStatsProvider = Provider<SettingsStats>((ref) {
  return computeSettingsStats(
    content: ref.watch(contentRepositoryProvider),
    progress: ref.watch(progressProvider),
    favoriteCount: ref.watch(favoriteIdsProvider).length,
  );
});
