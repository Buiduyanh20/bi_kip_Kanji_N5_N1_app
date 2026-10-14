import 'package:flutter/material.dart';

/// Thanh nút cố định ở đáy màn Ôn tập.
class ReviewStartBar extends StatelessWidget {
  const ReviewStartBar({
    super.key,
    required this.count,
    required this.onStart,
    this.quickCount = 10,
    this.onQuick,
  });

  /// Số mục trong nhóm đang lọc.
  final int count;
  final VoidCallback? onStart;

  final int quickCount;

  /// null = ẩn nút ôn nhanh.
  final VoidCallback? onQuick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: count == 0 ? null : onStart,
              child: Text('Ôn tập ($count mục)'),
            ),
          ),
          if (onQuick != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: onQuick,
                icon: const Icon(Icons.bolt_rounded),
                label: Text('Ôn nhanh $quickCount câu khó nhất'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}