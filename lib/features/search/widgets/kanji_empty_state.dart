import 'package:flutter/material.dart';

class KanjiEmptyState extends StatelessWidget {
  const KanjiEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: const [
        Icon(Icons.search, size: 64, color: Colors.grey),

        SizedBox(height: 16),

        Text('Nhập Kanji để tra cứu'),
      ],
    );
  }
}
