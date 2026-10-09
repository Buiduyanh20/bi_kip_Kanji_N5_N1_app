import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/features/settings/providers/settings_stats_provider.dart';
import 'package:bikip_kanji_app/features/settings/widgets/legal_document_widgets.dart';

/// Lối tắt: Yêu thích, Ôn tập, Góp ý.
class SettingsShortcutsWidget extends ConsumerWidget {
  const SettingsShortcutsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsStatsProvider);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.error,
            ),
            title: const Text('Danh sách yêu thích'),
            subtitle: Text(
              s.favorites == 0
                  ? 'Chưa lưu Kanji nào'
                  : '${s.favorites} Kanji đã lưu',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: mở màn yêu thích khi đã có FavoriteScreen
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.replay_rounded, color: AppColors.warning),
            title: const Text('Ôn tập'),
            subtitle: Text(
              s.reviewItems == 0
                  ? 'Chưa có câu nào cần ôn'
                  : '${s.reviewItems} chữ cần ôn',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.review),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.mail_outline, color: AppColors.primary),
            title: const Text('Góp ý & liên hệ'),
            subtitle: const Text(kLegalContactEmail),
            trailing: const Icon(Icons.copy_rounded, size: 20),
            onTap: () async {
              await Clipboard.setData(
                const ClipboardData(text: kLegalContactEmail),
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã sao chép email.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
