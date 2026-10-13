import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/core/widgets/kanji_display.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/features/favorite/providers/favorite_entries_provider.dart';

Color levelColor(JlptLevel level) {
  switch (level) {
    case JlptLevel.n5:
      return const Color(0xFF16A34A);
    case JlptLevel.n4:
      return const Color(0xFF2563EB);
    case JlptLevel.n3:
      return const Color(0xFF9333EA);
    case JlptLevel.n2:
      return const Color(0xFFEA580C);
    case JlptLevel.n1:
      return const Color(0xFFE11D48);
  }
}

class FavoriteCardWidget extends StatelessWidget {
  const FavoriteCardWidget({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onRemove,
  });

  final FavoriteEntry entry;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final k = entry.kanji;
    final color = levelColor(k.level);
    final radius = BorderRadius.circular(20);

    return Material(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
          child: Row(
            children: [
              SizedBox(width: 64, child: KanjiDisplay(k.char, size: 44)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          k.hanViet.join(', '),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            k.level.code,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      k.meanings.join(', '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Bỏ yêu thích',
                    onPressed: onRemove,
                    icon: const Icon(Icons.favorite, color: AppColors.error),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textHint),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}