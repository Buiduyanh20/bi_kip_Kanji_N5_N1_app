import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/features/learn/providers/quiz_controller.dart';

/// Port của `ResetDataDialog.tsx`.
class ResetDataDialogWidget extends ConsumerWidget {
  const ResetDataDialogWidget({super.key});

  ButtonStyle get _destructive => FilledButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: Colors.white,
    minimumSize: const Size(0, 48),
  );

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    // Tương đương window.confirm.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa dữ liệu?'),
        content: const Text(
          'Xóa toàn bộ tiến độ, danh sách yêu thích, phiên học và cài đặt?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: _destructive,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final actions = ref.read(backupActionsProvider);
    ref.invalidate(quizControllerProvider); // web: sessionStore.clear()
    try {
      await actions
          .resetAll(); // tiến độ + yêu thích + cài đặt, rồi nạp lại state
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không thể xóa dữ liệu.')));
      return;
    }
    if (context.mounted) context.go(AppRoutes.home); // web: router.push("/")
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Xóa dữ liệu',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Xóa tiến độ, danh sách ôn tập, danh sách yêu thích, '
            'phiên quiz hiện tại và cài đặt.',
            style: TextStyle(fontSize: 14, color: AppColors.textHint),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              style: _destructive,
              onPressed: () => _reset(context, ref),
              child: const Text('Xóa dữ liệu'),
            ),
          ),
        ],
      ),
    );
  }
}
