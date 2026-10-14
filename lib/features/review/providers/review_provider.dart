import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/core/logic/mastery.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/models/quiz_question.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/content_repository.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

enum ReviewSort { mostWrong, recent }

/// Một lỗi sai kèm nội dung (web: kết quả của `useMistakes`).
class ReviewEntry {
  const ReviewEntry({
    required this.mistake,
    required this.item,
    this.lastAnsweredAt = 0,
  });

  final Mistake mistake;
  final ContentItem item;

  /// Epoch ms của lần trả lời gần nhất (0 = không rõ).
  final int lastAnsweredAt;

  String get key => '${mistake.itemId}:${mistake.method.name}';

  QuizQuestion get question => QuizQuestion(
    itemId: mistake.itemId,
    contentType: mistake.type,
    method: mistake.method,
  );
}

/// Port của `useMistakes`: bỏ mục không còn trong nội dung.
/// Thứ tự giữ nguyên của `getMistakes` (sai nhiều nhất trước).
List<ReviewEntry> computeReviewEntries({
  required ContentRepository content,
  required Map<String, ItemProgress> progress,
}) {
  final result = <ReviewEntry>[];
  for (final m in getMistakes(progress)) {
    final item = content.itemById(m.type, m.itemId);
    if (item == null) continue;
    result.add(ReviewEntry(
      mistake: m,
      item: item,
      lastAnsweredAt: progress[m.itemId]?.methods[m.method]?.lastAnsweredAt ?? 0,
    ));
  }
  return result;
}

// ───────── Bộ lọc ─────────

class ReviewFilter {
  const ReviewFilter({
    this.type,
    this.method,
    this.sort = ReviewSort.mostWrong,
  });

  final ContentType? type; // null = Tất cả
  final LearnMethod? method; // null = Tất cả
  final ReviewSort sort;

  bool get isDefault => type == null && method == null;

  /// Từ vựng không có phương pháp Hán Việt nên phải bỏ chọn nếu đang chọn.
  ReviewFilter withType(ContentType? t) {
    final dropMethod =
        t == ContentType.vocabulary && method == LearnMethod.hanviet;
    return ReviewFilter(
      type: t,
      method: dropMethod ? null : method,
      sort: sort,
    );
  }

  ReviewFilter withMethod(LearnMethod? m) =>
      ReviewFilter(type: type, method: m, sort: sort);

  ReviewFilter withSort(ReviewSort s) =>
      ReviewFilter(type: type, method: method, sort: s);
}

List<ReviewEntry> applyReviewFilter(
    List<ReviewEntry> entries,
    ReviewFilter filter,
    ) {
  final result = entries.where((e) {
    if (filter.type != null && e.mistake.type != filter.type) return false;
    if (filter.method != null && e.mistake.method != filter.method) {
      return false;
    }
    return true;
  }).toList();

  // mostWrong: giữ nguyên thứ tự từ getMistakes.
  if (filter.sort == ReviewSort.recent) {
    result.sort((a, b) => b.lastAnsweredAt.compareTo(a.lastAnsweredAt));
  }
  return result;
}

// ───────── Thống kê ─────────

class ReviewStats {
  const ReviewStats({
    required this.total,
    required this.kanji,
    required this.vocab,
    required this.totalWrong,
    required this.hardest,
  });

  final int total;
  final int kanji;
  final int vocab;
  final int totalWrong;
  final ReviewEntry? hardest;
}

ReviewStats computeReviewStats(List<ReviewEntry> entries) {
  var kanji = 0, vocab = 0, wrong = 0;
  ReviewEntry? hardest;
  for (final e in entries) {
    if (e.mistake.type == ContentType.kanji) {
      kanji++;
    } else {
      vocab++;
    }
    wrong += e.mistake.wrong;
    if (hardest == null || e.mistake.wrong > hardest.mistake.wrong) {
      hardest = e;
    }
  }
  return ReviewStats(
    total: entries.length,
    kanji: kanji,
    vocab: vocab,
    totalWrong: wrong,
    hardest: hardest,
  );
}

// ───────── Providers ─────────

final reviewEntriesProvider = Provider<List<ReviewEntry>>((ref) {
  return computeReviewEntries(
    content: ref.watch(contentRepositoryProvider),
    progress: ref.watch(progressProvider),
  );
});

class ReviewFilterNotifier extends Notifier<ReviewFilter> {
  @override
  ReviewFilter build() => const ReviewFilter();

  void setType(ContentType? t) => state = state.withType(t);
  void setMethod(LearnMethod? m) => state = state.withMethod(m);
  void setSort(ReviewSort s) => state = state.withSort(s);
  void reset() => state = ReviewFilter(sort: state.sort);
}

final reviewFilterProvider =
NotifierProvider<ReviewFilterNotifier, ReviewFilter>(
  ReviewFilterNotifier.new,
);

final filteredReviewEntriesProvider = Provider<List<ReviewEntry>>((ref) {
  return applyReviewFilter(
    ref.watch(reviewEntriesProvider),
    ref.watch(reviewFilterProvider),
  );
});

final reviewStatsProvider = Provider<ReviewStats>(
      (ref) => computeReviewStats(ref.watch(reviewEntriesProvider)),
);