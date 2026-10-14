import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/core/constants/labels.dart';
import 'package:bikip_kanji_app/core/logic/mastery.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

/// Nhãn tiếng Việt (có dấu) cho từng phương pháp học.
const _methodLabels = <LearnMethod, String>{
  LearnMethod.hanviet: 'Hán Việt',
  LearnMethod.meaning: 'Nghĩa',
  LearnMethod.reading: 'Cách đọc',
};

String methodLabel(LearnMethod m) => _methodLabels[m] ?? m.name;

class LevelProgressData {
  const LevelProgressData({
    required this.title,
    required this.type,
    required this.level,
    required this.total,
    required this.mastered,
    required this.learning,
    required this.fresh,
    required this.methodMastered,
  });

  final String title;
  final ContentType type;
  final JlptLevel level;
  final int total;

  /// Mọi phương pháp đều mastered.
  final List<ContentItem> mastered;

  /// Đang học: chưa mastered nhưng đã có bản ghi tiến độ (chữ yếu, ưu tiên ôn).
  final List<ContentItem> learning;

  /// Chưa học: chưa có bản ghi tiến độ.
  final List<ContentItem> fresh;

  /// Số mục đã nhớ theo từng phương pháp (Hán Việt / Nghĩa / Cách đọc...).
  final Map<LearnMethod, int> methodMastered;

  double ratioOf(int n) => total == 0 ? 0 : n / total;
  bool get hasStarted => mastered.isNotEmpty || learning.isNotEmpty;
}

/// Hàm thuần, dễ viết unit test.
LevelProgressData computeLevelProgress({
  required ContentType type,
  required JlptLevel level,
  required List<ContentItem> items,
  required List<LearnMethod> methods,
  required Map<String, ItemProgress> progress,
}) {
  final mastered = <ContentItem>[];
  final learning = <ContentItem>[];
  final fresh = <ContentItem>[];
  final perMethod = {for (final m in methods) m: 0};

  for (final item in items) {
    if (isItemMastered(item, methods, progress)) {
      mastered.add(item);
    } else if (progress.containsKey(item.id)) {
      learning.add(item);
    } else {
      fresh.add(item);
    }
    for (final m in methods) {
      if (isItemMastered(item, [m], progress)) {
        perMethod[m] = perMethod[m]! + 1;
      }
    }
  }

  return LevelProgressData(
    title: '${level.code} ${contentTypeLabel(type)}',
    type: type,
    level: level,
    total: items.length,
    mastered: mastered,
    learning: learning,
    fresh: fresh,
    methodMastered: perMethod,
  );
}

/// Các level thực sự có dữ liệu cho loại nội dung này (N5 -> N1).
final availableLevelsProvider =
Provider.family<List<JlptLevel>, ContentType>((ref, type) {
  final content = ref.watch(contentRepositoryProvider);
  return [
    for (final l in JlptLevel.values)
      if (content.itemsByLevel(type, l).isNotEmpty) l,
  ];
});

/// Tiến độ của một (loại nội dung, level).
final levelProgressProvider =
Provider.family<LevelProgressData, (ContentType, JlptLevel)>((ref, key) {
  final (type, level) = key;
  final content = ref.watch(contentRepositoryProvider);
  final progress = ref.watch(progressProvider);
  return computeLevelProgress(
    type: type,
    level: level,
    items: content.itemsByLevel(type, level),
    methods: content.availableMethods(type, level),
    progress: progress,
  );
});