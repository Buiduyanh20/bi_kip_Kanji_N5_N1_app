import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';

class Mistake {
  const Mistake({
    required this.itemId,
    required this.type,
    required this.method,
    required this.wrong,
  });

  final String itemId;
  final ContentType type;
  final LearnMethod method;
  final int wrong;
}

MethodProgress? getMethodProgress(
    Map<String, ItemProgress> items,
    String itemId,
    LearnMethod method,
    ) =>
    items[itemId]?.methods[method];

/// Cần ôn: từng sai và chưa mastered.
bool isNeedsReview(MethodProgress? p) =>
    p != null && p.wrong > 0 && p.status != MasteryStatus.mastered;

/// Danh sách lỗi sai, nhiều lần sai nhất xếp trước.
List<Mistake> getMistakes(Map<String, ItemProgress> items) {
  final result = <Mistake>[];
  for (final item in items.values) {
    for (final entry in item.methods.entries) {
      if (isNeedsReview(entry.value)) {
        result.add(Mistake(
          itemId: item.itemId,
          type: item.type,
          method: entry.key,
          wrong: entry.value.wrong,
        ));
      }
    }
  }
  result.sort((a, b) => b.wrong.compareTo(a.wrong));
  return result;
}

/// "Đã nhớ" = MỌI phương pháp đều mastered.
bool isItemMastered(
    ContentItem item,
    List<LearnMethod> methods,
    Map<String, ItemProgress> items,
    ) {
  final progress = items[item.id];
  return methods.isNotEmpty &&
      methods.every(
            (m) => progress?.methods[m]?.status == MasteryStatus.mastered,
      );
}

class LevelSummary {
  const LevelSummary({
    required this.level,
    required this.contentType,
    required this.total,
    required this.mastered,
    required this.learning,
    required this.newItems,
  });

  final JlptLevel level;
  final ContentType contentType;
  final int total;
  final int mastered;
  final int learning;
  final int newItems;
}

List<LevelSummary> summarizeByLevel({
  required List<ContentItem> content,
  required ContentType contentType,
  required List<LearnMethod> methods,
  required Map<String, ItemProgress> items,
}) {
  final levels = content.map((i) => i.level).toSet();
  return [
    for (final level in levels)
          () {
        final levelItems = content.where((i) => i.level == level).toList();
        final mastered =
            levelItems.where((i) => isItemMastered(i, methods, items)).length;
        final learning = levelItems
            .where((i) =>
        !isItemMastered(i, methods, items) &&
            methods.any((m) =>
            items[i.id]?.methods[m]?.status ==
                MasteryStatus.learning))
            .length;
        return LevelSummary(
          level: level,
          contentType: contentType,
          total: levelItems.length,
          mastered: mastered,
          learning: learning,
          newItems: levelItems.length - mastered - learning,
        );
      }(),
  ];
}