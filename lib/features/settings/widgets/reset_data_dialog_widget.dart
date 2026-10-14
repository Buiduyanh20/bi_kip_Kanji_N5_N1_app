import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/features/learn/providers/quiz_controller.dart';

class ResetLearningWidget extends ConsumerWidget {
  const ResetLearningWidget({super.key});

  Future<void> _showResetSheet(BuildContext context, WidgetRef ref) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,

      showDragHandle: true,

      // Cho phép sheet cao hơn mặc định 9/16 màn hình
      isScrollControlled: true,

      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  width: 64,

                  height: 64,

                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),

                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.restart_alt,

                    size: 36,

                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Bắt đầu lại hành trình?',

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Toàn bộ tiến độ học hiện tại sẽ được đặt lại:',

                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                const _ResetItem(
                  icon: Icons.menu_book,

                  text: 'Tiến độ Kanji và từ vựng',
                ),

                const _ResetItem(
                  icon: Icons.history,

                  text: 'Lịch sử trả lời quiz',
                ),

                const _ResetItem(
                  icon: Icons.bookmark,

                  text: 'Danh sách ôn tập',
                ),

                const _ResetItem(icon: Icons.settings, text: 'Cài đặt cá nhân'),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,

                      foregroundColor: Colors.white,

                      minimumSize: const Size(0, 48),
                    ),

                    onPressed: () {
                      Navigator.pop(ctx, true);
                    },

                    child: const Text('Xác nhận bắt đầu lại'),
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,

                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx, false);
                    },

                    child: const Text('Hủy'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await _reset(context, ref);
  }

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final actions = ref.read(backupActionsProvider);

    ref.invalidate(quizControllerProvider);

    try {
      await actions.resetAll();

      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('has_seen_welcome');
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể đặt lại dữ liệu.')),
      );

      return;
    }

    if (!context.mounted) {
      return;
    }

    context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),

        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(Icons.restart_alt, color: Colors.orange),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Bắt đầu lại hành trình',

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Xóa tiến độ hiện tại và học lại từ đầu. '
            'Dữ liệu backup sẽ không bị ảnh hưởng.',

            style: TextStyle(color: AppColors.textHint, height: 1.4),
          ),

          const SizedBox(height: 16),

          OutlinedButton.icon(
            icon: const Icon(Icons.restart_alt),

            label: const Text('Học lại từ đầu'),

            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,

              backgroundColor: Colors.red.withValues(alpha: 0.05),

              side: const BorderSide(color: Colors.red),

              minimumSize: const Size(0, 48),
            ),

            onPressed: () => _showResetSheet(context, ref),
          ),
        ],
      ),
    );
  }
}

class _ResetItem extends StatelessWidget {
  final IconData icon;

  final String text;

  const _ResetItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),

          const SizedBox(width: 12),

          Text(text),
        ],
      ),
    );
  }
}
