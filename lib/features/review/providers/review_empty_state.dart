import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';

/// Port của `ReviewEmptyState.tsx`.
class ReviewEmptyState extends StatelessWidget {
  const ReviewEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          const Text(
            'Chưa có mục nào cần ôn',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hãy học một vài câu để bắt đầu theo dõi tiến độ.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textHint),
          ),
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            // Web: Link "/kanji". Ở app, Kanji là một tab của shell.
            onPressed: () => {},
            child: const Text('Học Kanji'),
          ),
        ],
      ),
    );
  }
}
