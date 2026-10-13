import 'package:flutter/material.dart';

class KanjiRecentList extends StatelessWidget {
  const KanjiRecentList({super.key});

  @override
  Widget build(BuildContext context) {
    const recent = ['母', '父', '犬', '学', '日'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          'Tra gần đây',

          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,

          children: [for (final item in recent) Chip(label: Text(item))],
        ),
      ],
    );
  }
}
