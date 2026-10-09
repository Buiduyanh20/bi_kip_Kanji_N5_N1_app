import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bí Kíp Kanji')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('HOME SCREEN', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () =>
                  context.push(AppRoutes.quizConfigOf(QuizType.kanji)),
              child: const Text('📚 Học Kanji'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  context.push(AppRoutes.quizConfigOf(QuizType.vocab)),
              child: const Text('📖 Học từ vựng'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push(AppRoutes.kanjiDetailOf('1')),
              child: const Text('Xem chi tiết Kanji 母 (id = 1)'),
            ),
          ],
        ),
      ),
    );
  }
}