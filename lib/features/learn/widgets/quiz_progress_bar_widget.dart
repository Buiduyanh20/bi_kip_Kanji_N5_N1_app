import 'package:flutter/material.dart';

class QuizProgressBarWidget extends StatelessWidget {
  const QuizProgressBarWidget({
    super.key,
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('Tiến độ'), Text('$current / $total')],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: total == 0 ? 0 : current / total),
      ],
    );
  }
}
