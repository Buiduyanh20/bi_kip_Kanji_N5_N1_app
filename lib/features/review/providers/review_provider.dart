import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/core/logic/mastery.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/content_repository.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

/// Một lỗi sai kèm nội dung (web: kết quả của `useMistakes`).
class ReviewEntry {
  const ReviewEntry({required this.mistake, required this.item});

  final Mistake mistake;
  final ContentItem item;

  String get key => '${mistake.itemId}:${mistake.method.name}';
}

/// Port của `useMistakes`: bỏ mục không còn trong nội dung.
List<ReviewEntry> computeReviewEntries({
  required ContentRepository content,
  required Map<String, ItemProgress> progress,
}) {
  final result = <ReviewEntry>[];
  for (final m in getMistakes(progress)) {
    final item = content.itemById(m.type, m.itemId);
    if (item != null) result.add(ReviewEntry(mistake: m, item: item));
  }
  return result;
}

final reviewEntriesProvider = Provider<List<ReviewEntry>>((ref) {
  return computeReviewEntries(
    content: ref.watch(contentRepositoryProvider),
    progress: ref.watch(progressProvider),
  );
});
