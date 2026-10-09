import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/core/logic/mastery.dart';
import 'package:bikip_kanji_app/core/constants/labels.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

/// Web (ProgressClient.tsx) cố định: Kanji N5 và Từ vựng N4.
const JlptLevel kProgressKanjiLevel = JlptLevel.n5;
const JlptLevel kProgressVocabLevel = JlptLevel.n4;

class LevelProgressData {
  const LevelProgressData({
    required this.title,
    required this.total,
    required this.mastered,
    required this.learning,
    required this.fresh,
  });

  final String title;
  final int total;

  /// Đã nhớ: mọi phương pháp đều mastered.
  final List<ContentItem> mastered;

  /// "Cần cải thiện": chưa mastered nhưng đã có bản ghi tiến độ.
  final List<ContentItem> learning;

  /// Chưa học: chưa mastered và chưa có bản ghi.
  final List<ContentItem> fresh;
}

/// Port của `ProgressSummary.tsx`.
List<LevelProgressData> computeProgressSections({
  required List<ContentItem> content,
  required ContentType type,
  required List<LearnMethod> methods,
  required Map<String, ItemProgress> progress,
}) {
  final levels = content.map((i) => i.level).toSet();
  return [
    for (final level in levels)
      () {
        final entries = content.where((i) => i.level == level).toList();
        final mastered = <ContentItem>[];
        final learning = <ContentItem>[];
        final fresh = <ContentItem>[];
        for (final item in entries) {
          if (isItemMastered(item, methods, progress)) {
            mastered.add(item);
          } else if (progress.containsKey(item.id)) {
            learning.add(item);
          } else {
            fresh.add(item);
          }
        }
        return LevelProgressData(
          title: '${level.code} ${contentTypeLabel(type)}',
          total: entries.length,
          mastered: mastered,
          learning: learning,
          fresh: fresh,
        );
      }(),
  ];
}

final progressSectionsProvider = Provider<List<LevelProgressData>>((ref) {
  final content = ref.watch(contentRepositoryProvider);
  final progress = ref.watch(progressProvider);
  return [
    ...computeProgressSections(
      content: content.itemsByLevel(ContentType.kanji, kProgressKanjiLevel),
      type: ContentType.kanji,
      methods: content.availableMethods(ContentType.kanji, kProgressKanjiLevel),
      progress: progress,
    ),
    ...computeProgressSections(
      content: content.itemsByLevel(
        ContentType.vocabulary,
        kProgressVocabLevel,
      ),
      type: ContentType.vocabulary,
      methods: content.availableMethods(
        ContentType.vocabulary,
        kProgressVocabLevel,
      ),
      progress: progress,
    ),
  ];
});
