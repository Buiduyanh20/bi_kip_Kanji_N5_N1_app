import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/core/constants/labels.dart';
import 'package:bikip_kanji_app/core/widgets/kanji_display.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import 'package:bikip_kanji_app/features/favorite/widgets/favorite_button_widget.dart';

class KanjiDetailScreen extends ConsumerWidget {
  const KanjiDetailScreen({super.key, required this.kanjiId});

  final String kanjiId;

  static const double _maxWidth = 672;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanji = ref.watch(contentRepositoryProvider).kanjiById(kanjiId);

    if (kanji == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết Kanji')),
        body: const Center(child: Text('Không tìm thấy Kanji')),
      );
    }

    final progress = ref.watch(progressProvider)[kanji.id];

    return Scaffold(
      appBar: AppBar(
        title: Text(kanji.char, locale: const Locale('ja', 'JP')),
        actions: [FavoriteButtonWidget(kanji: kanji)],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Thẻ chữ ──
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      KanjiDisplay(kanji.char, size: 110),
                      const SizedBox(height: 8),
                      Text(
                        kanji.hanViet.join(' · '),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          kanji.level.code,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _InfoCard(
                  icon: '📖',
                  title: 'Nghĩa',
                  child: Text(
                    kanji.meanings.join(', '),
                    style: const TextStyle(fontSize: 17),
                  ),
                ),

                if (kanji.hasReadings)
                  _InfoCard(
                    icon: '🔊',
                    title: 'Cách đọc',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (kanji.onyomi.isNotEmpty)
                          _ReadingRow(label: 'On', values: kanji.onyomi),
                        if (kanji.kunyomi.isNotEmpty)
                          _ReadingRow(label: 'Kun', values: kanji.kunyomi),
                      ],
                    ),
                  ),

                if (kanji.hint.isNotEmpty)
                  _InfoCard(
                    icon: '💡',
                    title: 'Mẹo nhớ',
                    child: Text(
                      kanji.hint,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),

                if (kanji.story.isNotEmpty)
                  _InfoCard(
                    icon: '📝',
                    title: 'Câu chuyện',
                    child: Text(
                      kanji.story,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ),

                if (kanji.examples.isNotEmpty)
                  _InfoCard(
                    icon: '🧩',
                    title: 'Ví dụ',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final e in kanji.examples)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              e,
                              locale: const Locale('ja', 'JP'),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  ),

                _InfoCard(
                  icon: '📊',
                  title: 'Mức độ ghi nhớ',
                  child: Column(
                    children: [
                      for (final m in LearnMethod.values)
                        _StatusRow(
                          label: methodLabel(ContentType.kanji, m),
                          status: progress?.methods[m]?.status ??
                              MasteryStatus.newItem,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final String icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$icon  $title',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  const _ReadingRow({required this.label, required this.values});

  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textHint,
              ),
            ),
          ),
          Expanded(
            child: Text(
              values.join('、'),
              locale: const Locale('ja', 'JP'),
              style: const TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.status});

  final String label;
  final MasteryStatus status;

  Color get _color {
    switch (status) {
      case MasteryStatus.mastered:
        return AppColors.success;
      case MasteryStatus.learning:
        return AppColors.warning;
      case MasteryStatus.newItem:
        return AppColors.textHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusLabel(status),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
