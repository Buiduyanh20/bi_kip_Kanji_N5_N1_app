import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/features/review/providers/review_provider.dart';

class ReviewFilterBar extends ConsumerWidget {
  const ReviewFilterBar({super.key});

  static const _methodNames = {
    LearnMethod.hanviet: 'Hán Việt',
    LearnMethod.meaning: 'Nghĩa',
    LearnMethod.reading: 'Cách đọc',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(reviewFilterProvider);
    final notifier = ref.read(reviewFilterProvider.notifier);

    final methods = filter.type == ContentType.vocabulary
        ? const [LearnMethod.reading, LearnMethod.meaning]
        : LearnMethod.values;

    Widget typeChip(String label, ContentType? v) => ChoiceChip(
      label: Text(label),
      selected: filter.type == v,
      showCheckmark: false,
      onSelected: (_) => notifier.setType(v),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            typeChip('Tất cả', null),
            typeChip('Kanji', ContentType.kanji),
            typeChip('Từ vựng', ContentType.vocabulary),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Mọi phương pháp'),
              selected: filter.method == null,
              showCheckmark: false,
              onSelected: (_) => notifier.setMethod(null),
            ),
            for (final m in methods)
              ChoiceChip(
                label: Text(_methodNames[m]!),
                selected: filter.method == m,
                showCheckmark: false,
                onSelected: (_) => notifier.setMethod(m),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SegmentedButton<ReviewSort>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: ReviewSort.mostWrong,
              label: Text('Sai nhiều nhất'),
            ),
            ButtonSegment(
              value: ReviewSort.recent,
              label: Text('Gần đây'),
            ),
          ],
          selected: {filter.sort},
          onSelectionChanged: (s) => notifier.setSort(s.first),
        ),
      ],
    );
  }
}