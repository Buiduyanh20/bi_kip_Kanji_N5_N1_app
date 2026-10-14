import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/app/theme/app_colors.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/features/progress/providers/progress_summary_provider.dart';
import 'package:bikip_kanji_app/features/progress/widgets/level_progress_card_widget.dart';
import 'package:bikip_kanji_app/features/progress/widgets/progress_filter_bar_widget.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  ContentType _type = ContentType.kanji;
  JlptLevel? _level;

  // TODO: nối với router / navigation_provider hiện có của app.
  void _openReview() {}
  void _openKanjiDetail(ContentItem item) {}

  @override
  Widget build(BuildContext context) {
    final levels = ref.watch(availableLevelsProvider(_type));
    final selected = levels.contains(_level)
        ? _level
        : (levels.contains(JlptLevel.n5) ? JlptLevel.n5 : levels.firstOrNull);

    return Scaffold(
      appBar: AppBar(title: const Text('Tiến độ')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 672),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Theo dõi những gì bạn đã nhớ.',
                style: TextStyle(fontSize: 14, color: AppColors.textHint),
              ),
              const SizedBox(height: 16),
              ProgressFilterBarWidget(
                type: _type,
                levels: levels,
                level: selected,
                onTypeChanged: (t) => setState(() {
                  _type = t;
                  _level = null;
                }),
                onLevelChanged: (l) => setState(() => _level = l),
              ),
              const SizedBox(height: 16),
              if (selected == null)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text('Chưa có nội dung cho mục này.',
                        style: TextStyle(color: AppColors.textHint)),
                  ),
                )
              else
                _Body(
                  type: _type,
                  level: selected,
                  onReview: _openReview,
                  onItemTap: _type == ContentType.kanji ? _openKanjiDetail : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.type,
    required this.level,
    required this.onReview,
    required this.onItemTap,
  });

  final ContentType type;
  final JlptLevel level;
  final VoidCallback onReview;
  final void Function(ContentItem)? onItemTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(levelProgressProvider((type, level)));
    return LevelProgressCardWidget(
      data: data,
      onReview: onReview,
      onItemTap: onItemTap,
    );
  }
}