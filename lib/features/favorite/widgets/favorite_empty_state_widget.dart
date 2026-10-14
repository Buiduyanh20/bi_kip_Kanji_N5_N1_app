import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/app/theme/app_colors.dart';

/// [noFavorites] = true: chưa lưu gì. false: có yêu thích nhưng bộ lọc không khớp.
class FavoriteEmptyStateWidget extends StatelessWidget {
  const FavoriteEmptyStateWidget({super.key, required this.noFavorites});

  final bool noFavorites;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              noFavorites ? Icons.favorite_border_rounded : Icons.search_off,
              size: 56,
              color: const Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 16),
            Text(
              noFavorites ? 'Chưa có Kanji yêu thích' : 'Không tìm thấy kết quả',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              noFavorites
                  ? 'Bấm ♡ khi đang học hoặc ở màn chi tiết Kanji để lưu lại tại đây.'
                  : 'Thử từ khóa hoặc cấp độ khác.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textHint),
            ),
            if (noFavorites) ...[
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
                onPressed: () =>
                    context.push(AppRoutes.quizLevelOf(QuizType.kanji)),
                child: const Text('Học Kanji'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}