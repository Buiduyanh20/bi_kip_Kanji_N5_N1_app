import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuizPlayScreen extends StatelessWidget {
  final String type;

  const QuizPlayScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('QUIZ PLAY ($type)', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Kết thúc'),
            ),
          ],
        ),
      ),
    );
  }
}