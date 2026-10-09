import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ôn tập')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('REVIEW SCREEN', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () =>
                  context.push(AppRoutes.quizPlayOf(QuizType.review)),
              child: const Text('Bắt đầu ôn'),
            ),
          ],
        ),
      ),
    );
  }
}