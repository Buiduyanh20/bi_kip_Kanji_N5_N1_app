import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';

class QuizConfigScreen extends StatelessWidget {
  final String type; // kanji | vocab | review

  const QuizConfigScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn bài học')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('QUIZ CONFIG ($type)', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            FilledButton(
              // pushReplacement: back từ màn quiz sẽ về thẳng nơi đã mở config
              onPressed: () => context.pushReplacement(AppRoutes.quizPlayOf(type)),
              child: const Text('Bắt đầu'),
            ),
          ],
        ),
      ),
    );
  }
}