import 'package:flutter/material.dart';

class KanjiDetailScreen extends StatelessWidget {
  final String kanjiId;

  const KanjiDetailScreen({super.key, required this.kanjiId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết Kanji')),
      body: Center(
        child: Text(
          'KANJI DETAIL (id = $kanjiId)',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}