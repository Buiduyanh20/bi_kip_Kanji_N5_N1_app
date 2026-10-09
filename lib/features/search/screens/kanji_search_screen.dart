import 'package:flutter/material.dart';

/// Tạm thời. Sẽ được thay khi migrate components/search/* và app/kanji/search.
class KanjiSearchScreen extends StatelessWidget {
  const KanjiSearchScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tra Kanji')),
    body: const Center(child: Text('Màn Tra Kanji (chờ migrate).')),
  );
}
