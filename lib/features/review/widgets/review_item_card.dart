import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/core/constants/labels.dart';
import 'package:bikip_kanji_app/core/widgets/kanji_display.dart';
import 'package:bikip_kanji_app/data/models/content_item_ext.dart';
import 'package:bikip_kanji_app/features/review/providers/review_provider.dart';

/// Port của `MistakeItem.tsx`.
class ReviewItemCard extends StatelessWidget {
  const ReviewItemCard({super.key, required this.entry, this.onTap});

  final ReviewEntry entry;

  /// Chỉ truyền cho Kanji để mở chi tiết (web không có).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    final m = entry.mistake;
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                child: KanjiDisplay(entry.item.displayText, size: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      methodLabel(m.type, m.method),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sai ${m.wrong} lần',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(Icons.chevron_right, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}
