import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/data/models/kanji.dart';

class KanjiSearchResultCard extends StatelessWidget {
  const KanjiSearchResultCard({
    super.key,

    required this.kanji,

    required this.onTap,
  });

  final Kanji kanji;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,

        leading: Text(
          kanji.char,

          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),

        title: Text(
          kanji.hanViet.join('・'),

          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        subtitle: Text(
          [...kanji.meanings, ...kanji.onyomi, ...kanji.kunyomi].join(' / '),
        ),
      ),
    );
  }
}
