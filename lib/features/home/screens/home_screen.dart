import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/features/home/widgets/home_hero_widget.dart';
import 'package:bikip_kanji_app/features/home/widgets/home_status_widget.dart';
import 'package:bikip_kanji_app/features/home/widgets/mode_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _maxWidth = 896;

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      ModeCard(
        icon: '📚',
        title: 'Học Kanji',
        description: 'Nhớ chữ qua âm Hán Việt, nghĩa và cách đọc.',
        onTap: () =>
            context.push('${AppRoutes.quizLevel}?type=${QuizType.kanji}'),
      ),
      ModeCard(
        icon: '📖',
        title: 'Học từ vựng',
        description: 'Luyện đọc và nghĩa của những từ quen thuộc.',
        onTap: () =>
            context.push('${AppRoutes.quizLevel}?type=${QuizType.vocabulary}'),
      ),
      ModeCard(
        icon: '🔍',
        title: 'Tra Kanji',
        description: 'Tìm Kanji, âm Hán Việt, nghĩa và cách đọc.',
        onTap: () => context.push(AppRoutes.kanjiSearch),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = constraints.maxWidth < 360 ? 12.0 : 16.0;
                return ListView(
                  padding: EdgeInsets.fromLTRB(horizontal, 12, horizontal, 24),
                  children: [
                    const SizedBox(height: 8),
                    const HomeHero(child: HomeStatusView()),
                    const SizedBox(height: 24),
                    _ModeGrid(cards: cards),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Web: `grid gap-4 md:grid-cols-2`.
class _ModeGrid extends StatelessWidget {
  const _ModeGrid({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 16.0;
        final twoColumns = constraints.maxWidth >= 600;
        final width = twoColumns
            ? (constraints.maxWidth - gap) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final card in cards) SizedBox(width: width, child: card),
          ],
        );
      },
    );
  }
}