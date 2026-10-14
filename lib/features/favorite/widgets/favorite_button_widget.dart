import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

/// Nút trái tim lưu Kanji vào Yêu thích (chỉ dành cho Kanji).
class FavoriteButtonWidget extends ConsumerWidget {
  const FavoriteButtonWidget({super.key, required this.kanji, this.size = 28});

  final Kanji kanji;
  final double size;

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(favoriteRepositoryProvider).toggle(kanji.id, kanji.level);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Không cập nhật được yêu thích.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      favoriteIdsProvider.select((ids) => ids.contains(kanji.id)),
    );

    // ExcludeFocus: bấm tim không làm mất focus ô nhập, bàn phím giữ nguyên.
    return ExcludeFocus(
      child: IconButton(
        tooltip: isFavorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích',
        onPressed: () => _toggle(context, ref),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Icon(
            isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            key: ValueKey(isFavorite),
            size: size,
            color: isFavorite ? AppColors.error : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}