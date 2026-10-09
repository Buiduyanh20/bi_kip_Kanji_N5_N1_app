import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/features/home/providers/home_status_provider.dart';

/// Port của `HomeStatus.tsx` (3 trạng thái).
class HomeStatusView extends ConsumerWidget {
  const HomeStatusView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(settingsProvider.select((s) => s.userName));
    final status = ref.watch(homeStatusProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (name.isNotEmpty) ...[
          Text(
            'Chào $name',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
        ],
        ...switch (status.stage) {
          HomeStage.notStarted => _notStarted(),
          HomeStage.completed => _completed(context, status),
          HomeStage.inProgress => _inProgress(context, status),
        },
      ],
    );
  }

  // ── studied = 0: không có nút (giống web) ──
  List<Widget> _notStarted() => const [
    _Title('Học Kanji nhẹ nhàng hơn mỗi ngày'),
    SizedBox(height: 12),
    Text(
      'Bắt đầu hành trình chinh phục Kanji Nhật Bản',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        height: 1.6,
        color: AppColors.textSecondary,
      ),
    ),
    SizedBox(height: 8),
    Text(
      'Từ N5 đến N1, học bằng âm Hán Việt, nghĩa và phương pháp ghi nhớ.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textHint),
    ),
  ];

  // ── Đã làm hết N5 ──
  List<Widget> _completed(BuildContext context, HomeStatusData s) => [
    const _Title('🎉 Chúc mừng!'),
    const SizedBox(height: 12),
    Text(
      'Bạn đã hoàn thành ${kHomeLevel.code} Kanji',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    ),
    const SizedBox(height: 20),
    _StatBox(
      children: [
        _Count('${s.studied} / ${s.total}'),
        const SizedBox(height: 8),
        Text(
          'Đã nhớ: ${s.mastered} · Cần ôn: ${s.reviewCount}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    ),
    const SizedBox(height: 24),
    const Text(
      'Tiếp tục chinh phục:',
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
    const SizedBox(height: 12),
    _ActionButton(
      label: 'Bắt đầu ${kHomeNextLevel.code} Kanji',
      filled: false,
      onPressed: () => context.push(
        AppRoutes.quizConfigOf(QuizType.kanji, level: kHomeNextLevel.code),
      ),
    ),
  ];

  // ── Đang học ──
  List<Widget> _inProgress(BuildContext context, HomeStatusData s) => [
    const _Title('Tiếp tục hành trình của bạn'),
    const SizedBox(height: 24),
    _StatBox(
      children: [
        Text(
          '${kHomeLevel.code} Kanji',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        _Count('${s.studied} / ${s.total}'),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 4,
          children: [
            _Stat('🟢 Đã nhớ: ${s.mastered}'),
            _Stat('🟡 Đang học: ${s.learning}'),
            _Stat('🔴 Cần ôn: ${s.reviewCount}'),
          ],
        ),
      ],
    ),
    const SizedBox(height: 24),
    _ActionButton(
      label: 'Học tiếp',
      filled: true,
      onPressed: () => context.push(
        AppRoutes.quizConfigOf(QuizType.kanji, level: kHomeLevel.code),
      ),
    ),
    if (s.reviewCount > 0) ...[
      const SizedBox(height: 12),
      _ActionButton(
        label: 'Ôn các câu cần nhớ',
        filled: false,
        onPressed: () => context.push(AppRoutes.review),
      ),
    ],
  ];
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      height: 1.2,
      letterSpacing: -0.5,
      color: AppColors.textPrimary,
    ),
  );
}

class _Count extends StatelessWidget {
  const _Count(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
  );
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(children: children),
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 320, minWidth: 220),
    child: SizedBox(
      width: double.infinity,
      height: 48,
      child: filled
          ? FilledButton(onPressed: onPressed, child: Text(label))
          : OutlinedButton(onPressed: onPressed, child: Text(label)),
    ),
  );
}
