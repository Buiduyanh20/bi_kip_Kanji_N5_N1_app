import 'dart:math';

import 'package:bikip_kanji_app/core/logic/mastery.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/models/quiz_question.dart';

/// Fisher–Yates, giống web.
List<T> shuffled<T>(Iterable<T> items, Random rng) {
  final result = [...items];
  for (var i = result.length - 1; i > 0; i--) {
    final target = rng.nextInt(i + 1);
    final tmp = result[i];
    result[i] = result[target];
    result[target] = tmp;
  }
  return result;
}

/// Thứ tự: learning → new → mastered, mỗi nhóm xáo ngẫu nhiên, rồi cắt theo [count].
/// [items] là toàn bộ mục của level đã chọn (lấy từ ContentRepository).
List<QuizQuestion> buildLearnQuiz({
  required ContentType contentType,
  required List<ContentItem> items,
  required LearnMethod method,
  required int count,
  required Map<String, ItemProgress> progress,
  Random? rng,
}) {
  final random = rng ?? Random();
  final groups = <MasteryStatus, List<String>>{
    MasteryStatus.learning: [],
    MasteryStatus.newItem: [],
    MasteryStatus.mastered: [],
  };
  for (final item in items) {
    final status =
        progress[item.id]?.methods[method]?.status ?? MasteryStatus.newItem;
    groups[status]!.add(item.id);
  }
  final ordered = [
    ...shuffled(groups[MasteryStatus.learning]!, random),
    ...shuffled(groups[MasteryStatus.newItem]!, random),
    ...shuffled(groups[MasteryStatus.mastered]!, random),
  ];
  return ordered
      .take(count)
      .map(
        (id) =>
            QuizQuestion(itemId: id, contentType: contentType, method: method),
      )
      .toList();
}

/// Ôn tập: lấy các lỗi sai (sai nhiều nhất trước), cắt theo [count], rồi xáo.
List<QuizQuestion> buildReviewQuiz({
  required Map<String, ItemProgress> progress,
  ContentType? contentType,
  int? count,
  Random? rng,
}) {
  final random = rng ?? Random();
  final mistakes = getMistakes(
    progress,
  ).where((m) => contentType == null || m.type == contentType).toList();
  final selected = count != null ? mistakes.take(count) : mistakes;
  return shuffled(
    selected.map(
      (m) =>
          QuizQuestion(itemId: m.itemId, contentType: m.type, method: m.method),
    ),
    random,
  );
}
