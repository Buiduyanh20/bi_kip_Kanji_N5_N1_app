import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/content_item_ext.dart';
import 'package:bikip_kanji_app/features/progress/providers/progress_summary_provider.dart';
import 'package:bikip_kanji_app/features/progress/widgets/item_chip_widget.dart';

const _kLearning = Color(0xFFF59E0B);
const _kFresh = Color(0xFFE2E8F0);
const _kChipLimit = 24;

class LevelProgressCardWidget extends StatelessWidget {
  const LevelProgressCardWidget({
    super.key,
    required this.data,
    this.onReview,
    this.onItemTap,
  });

  final LevelProgressData data;
  final VoidCallback? onReview;
  final void Function(ContentItem)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(data.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              Text('${data.mastered.length}',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.success)),
              Text(' / ${data.total}',
                  style: const TextStyle(fontSize: 14, color: AppColors.textHint)),
            ],
          ),
          const SizedBox(height: 12),
          _StackedBar(data: data),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat('Đã nhớ', data.mastered.length, AppColors.success),
              _Stat('Đang học', data.learning.length, _kLearning),
              _Stat('Chưa học', data.fresh.length, AppColors.textHint),
            ],
          ),
          if (!data.hasStarted) ...[
            const SizedBox(height: 16),
            const Text(
              'Bạn chưa bắt đầu mục này. Hãy làm một bài quiz để thấy tiến độ ở đây.',
              style: TextStyle(fontSize: 13, color: AppColors.textHint),
            ),
          ],
          if (data.methodMastered.isNotEmpty && data.hasStarted) ...[
            const SizedBox(height: 20),
            const Text('Theo phương pháp',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            for (final e in data.methodMastered.entries)
              _MethodRow(
                label: methodLabel(e.key),
                done: e.value,
                total: data.total,
              ),
          ],
          if (data.learning.isNotEmpty) ...[
            const SizedBox(height: 20),
            _ChipGroup(
              label: 'Đang học (cần ôn)',
              color: _kLearning,
              items: data.learning,
              onItemTap: onItemTap,
            ),
            if (onReview != null) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onReview,
                icon: const Icon(Icons.refresh),
                label: Text('Ôn ${data.learning.length} mục còn yếu'),
              ),
            ],
          ],
          if (data.mastered.isNotEmpty) ...[
            const SizedBox(height: 20),
            _ChipGroup(
              label: 'Đã nhớ',
              color: AppColors.success,
              items: data.mastered,
              onItemTap: onItemTap,
            ),
          ],
        ],
      ),
    );
  }
}

class _StackedBar extends StatelessWidget {
  const _StackedBar({required this.data});
  final LevelProgressData data;

  @override
  Widget build(BuildContext context) {
    final parts = [
      (data.mastered.length, AppColors.success),
      (data.learning.length, _kLearning),
      (data.fresh.length, _kFresh),
    ].where((p) => p.$1 > 0).toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 10,
        child: parts.isEmpty
            ? const ColoredBox(color: _kFresh)
            : Row(children: [
          for (final p in parts)
            Expanded(flex: p.$1, child: ColoredBox(color: p.$2)),
        ]),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.count, this.color);
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text('$count',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  const _MethodRow({required this.label, required this.done, required this.total});
  final String label;
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 96, child: Text(label, style: const TextStyle(fontSize: 13))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
                minHeight: 6,
                backgroundColor: const Color(0xFFF1F5F9),
                color: AppColors.success,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$done/$total',
              style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

class _ChipGroup extends StatefulWidget {
  const _ChipGroup({
    required this.label,
    required this.color,
    required this.items,
    this.onItemTap,
  });
  final String label;
  final Color color;
  final List<ContentItem> items;
  final void Function(ContentItem)? onItemTap;

  @override
  State<_ChipGroup> createState() => _ChipGroupState();
}

class _ChipGroupState extends State<_ChipGroup> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final shown = _expanded ? items : items.take(_kChipLimit).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${widget.label} (${items.length})',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: widget.color)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final i in shown)
              ItemChipWidget(
                label: i.displayText,
                onTap: widget.onItemTap == null ? null : () => widget.onItemTap!(i),
              ),
          ],
        ),
        if (items.length > _kChipLimit)
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Text(_expanded ? 'Thu gọn' : 'Xem tất cả ${items.length}'),
          ),
      ],
    );
  }
}