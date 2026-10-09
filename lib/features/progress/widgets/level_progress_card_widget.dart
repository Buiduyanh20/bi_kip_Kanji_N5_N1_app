import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/data/models/content_item_ext.dart';
import 'package:bikip_kanji_app/features/progress/providers/progress_summary_provider.dart';
import 'package:bikip_kanji_app/features/progress/widgets/item_chip_widget.dart';

/// Port của `LevelProgressCard.tsx`.
class LevelProgressCardWidget extends StatelessWidget {
  const LevelProgressCardWidget({super.key, required this.data});

  final LevelProgressData data;

  @override
  Widget build(BuildContext context) {
    final ratio = data.total == 0 ? 0.0 : data.mastered.length / data.total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${data.mastered.length}/${data.total}',
                style: const TextStyle(fontSize: 14, color: AppColors.textHint),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 20),
          _ChipGroup(
            label: 'Đã nhớ',
            color: AppColors.success,
            labels: [for (final i in data.mastered) i.displayText],
          ),
          const SizedBox(height: 16),
          _ChipGroup(
            label: 'Cần cải thiện',
            color: AppColors.error,
            labels: [for (final i in data.learning) i.displayText],
          ),
          if (data.fresh.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Còn ${data.fresh.length} mục chưa học.',
              style: const TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.label,
    required this.color,
    required this.labels,
  });

  final String label;
  final Color color;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        if (labels.isEmpty)
          const Text(
            'Chưa có',
            style: TextStyle(fontSize: 14, color: AppColors.textHint),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final l in labels) ItemChipWidget(label: l)],
          ),
      ],
    );
  }
}
