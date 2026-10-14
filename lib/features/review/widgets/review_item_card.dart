import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/core/constants/labels.dart';
import 'package:bikip_kanji_app/core/widgets/kanji_display.dart';
import 'package:bikip_kanji_app/data/models/content_item_ext.dart';
import 'package:bikip_kanji_app/features/favorite/widgets/favorite_card_widget.dart'
    show levelColor;
import 'package:bikip_kanji_app/features/review/providers/review_provider.dart';

String _ago(int ms) {
  final d = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(ms));
  if (d.inMinutes < 1) return 'Vừa xong';
  if (d.inHours < 1) return '${d.inMinutes} phút trước';
  if (d.inDays < 1) return '${d.inHours} giờ trước';
  return '${d.inDays} ngày trước';
}

/// Port của `MistakeItem.tsx`, thêm cấp độ và thời điểm làm gần nhất.
class ReviewItemCard extends StatelessWidget {
  const ReviewItemCard({super.key, required this.entry, this.onTap});

  final ReviewEntry entry;

  /// Chỉ truyền cho Kanji để mở chi tiết (web không có).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    final m = entry.mistake;
    final color = levelColor(entry.item.level);

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
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            methodLabel(m.type, m.method),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            entry.item.level.code,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.lastAnsweredAt > 0
                          ? 'Sai ${m.wrong} lần · ${_ago(entry.lastAnsweredAt)}'
                          : 'Sai ${m.wrong} lần',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '×${m.wrong}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.error,
                  ),
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: AppColors.textHint),
              ],
            ],
          ),
        ),
      ),
    );
  }
}