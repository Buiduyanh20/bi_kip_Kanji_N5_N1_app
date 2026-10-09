import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/features/settings/providers/settings_stats_provider.dart';
import 'package:bikip_kanji_app/features/settings/widgets/app_info_section_widget.dart';

/// Thẻ tổng quan ở đầu màn Cài đặt.
class SettingsHeaderWidget extends ConsumerWidget {
  const SettingsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsStatsProvider);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            bottom: -28,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Text(
                  '漢',
                  locale: const Locale('ja', 'JP'),
                  style: TextStyle(
                    fontSize: 150,
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Bí Kíp Kanji',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'v$kAppVersion',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Người Việt học Kanji dễ hơn bằng âm Hán Việt và mẹo ghi nhớ',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  spacing: 10,
                  children: [
                    _StatTile(
                      value: '${s.kanjiMastered}/${s.kanjiTotal}',
                      label: 'Kanji đã nhớ',
                    ),
                    _StatTile(
                      value: '${s.vocabMastered}/${s.vocabTotal}',
                      label: 'Từ vựng đã nhớ',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  spacing: 10,
                  children: [
                    _StatTile(value: '${s.reviewItems}', label: 'Cần ôn'),
                    _StatTile(value: '${s.favorites}', label: 'Yêu thích'),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  s.answered == 0
                      ? 'Chưa có câu trả lời nào. Bắt đầu học thôi!'
                      : 'Đã trả lời ${s.answered} câu · Chính xác ${s.accuracyPercent}%',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
