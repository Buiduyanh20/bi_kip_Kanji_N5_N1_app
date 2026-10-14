import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/features/learn/providers/quiz_controller.dart';
import 'package:bikip_kanji_app/features/review/providers/review_provider.dart';
import 'package:bikip_kanji_app/features/review/widgets/review_empty_state.dart';
import 'package:bikip_kanji_app/features/review/widgets/review_filter_bar.dart';
import 'package:bikip_kanji_app/features/review/widgets/review_item_card.dart';
import 'package:bikip_kanji_app/features/review/widgets/review_start_bar.dart';
import 'package:bikip_kanji_app/features/review/widgets/review_summary_card.dart';

class ReviewScreen extends ConsumerWidget {
  const ReviewScreen({super.key});

  static const double _maxWidth = 672;
  static const int _quickCount = 10;

  void _start(
      BuildContext context,
      WidgetRef ref,
      List<ReviewEntry> entries,
      ) {
    final started = ref
        .read(quizControllerProvider.notifier)
        .startReviewFromQuestions([for (final e in entries) e.question]);
    if (!started) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có câu nào cần ôn.')),
      );
      return;
    }
    // Ôn tập là tab: dùng push để đóng quiz thì quay về đúng tab.
    context.push(AppRoutes.quizPlayOf(QuizType.review));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(reviewEntriesProvider);

    if (all.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ôn tập')),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: ReviewEmptyState(),
            ),
          ),
        ),
      );
    }

    final filtered = ref.watch(filteredReviewEntriesProvider);
    final stats = ref.watch(reviewStatsProvider);
    final filter = ref.watch(reviewFilterProvider);

    // "Khó nhất": luôn sắp theo số lần sai, bất kể kiểu sắp xếp đang chọn.
    List<ReviewEntry> hardest() {
      final byWrong = [...filtered]
        ..sort((a, b) => b.mistake.wrong.compareTo(a.mistake.wrong));
      return byWrong.take(_quickCount).toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ôn tập')),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ReviewSummaryCard(stats: stats),
                      const SizedBox(height: 16),
                      const ReviewFilterBar(),
                      const SizedBox(height: 16),
                      if (filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            children: [
                              const Text('Không có mục nào trong nhóm này.'),
                              if (!filter.isDefault)
                                TextButton(
                                  onPressed: () => ref
                                      .read(reviewFilterProvider.notifier)
                                      .reset(),
                                  child: const Text('Bỏ bộ lọc'),
                                ),
                            ],
                          ),
                        ),
                      for (final entry in filtered)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ReviewItemCard(
                            key: ValueKey(entry.key),
                            entry: entry,
                            onTap: entry.mistake.type == ContentType.kanji
                                ? () => context.push(
                              AppRoutes.kanjiDetailOf(entry.item.id),
                            )
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
                ReviewStartBar(
                  count: filtered.length,
                  quickCount: _quickCount,
                  onStart: () => _start(context, ref, filtered),
                  onQuick: filtered.length > _quickCount
                      ? () => _start(context, ref, hardest())
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}