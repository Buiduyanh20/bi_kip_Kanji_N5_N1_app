import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/features/learn/providers/quiz_controller.dart';
import 'package:bikip_kanji_app/features/review/providers/review_provider.dart';
import 'package:bikip_kanji_app/features/review/providers/review_empty_state.dart';
import 'package:bikip_kanji_app/features/review/widgets/review_item_card.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key});

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  static const double _maxWidth = 672;

  ContentType? _filter; // null = Tất cả

  void _startReview() {
    // Web: dựng quiz từ TOÀN BỘ lỗi sai, bỏ qua bộ lọc.
    final started = ref.read(quizControllerProvider.notifier).startReview();
    if (!started) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có câu nào cần ôn.')),
      );
      return;
    }
    // Ôn tập là tab: dùng push để quay về đúng tab khi đóng quiz.
    context.push(AppRoutes.quizPlayOf(QuizType.review));
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(reviewEntriesProvider);

    if (entries.isEmpty) {
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

    final filtered = _filter == null
        ? entries
        : entries.where((e) => e.mistake.type == _filter).toList();

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
                      // Web: subtitle dùng tổng số, không đổi theo bộ lọc.
                      Text(
                        '${entries.length} mục cần cải thiện',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chip('Tất cả', null),
                          _chip('Kanji', ContentType.kanji),
                          _chip('Từ vựng', ContentType.vocabulary),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text('Không có mục nào trong nhóm này.'),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _startReview,
                      child: Text('Ôn tập (${entries.length} mục)'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, ContentType? value) => ChoiceChip(
    label: Text(label),
    selected: _filter == value,
    showCheckmark: false,
    onSelected: (_) => setState(() => _filter = value),
  );
}
