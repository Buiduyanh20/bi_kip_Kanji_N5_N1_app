import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/data/repositories/providers.dart';

class KanjiDetailScreen extends ConsumerWidget {
  final String kanjiId;

  const KanjiDetailScreen({super.key, required this.kanjiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(contentRepositoryProvider);

    final kanji = repo.kanjiById(kanjiId);

    if (kanji == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết Kanji')),

        body: const Center(child: Text('Không tìm thấy Kanji')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(kanji.char)),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Text(
                kanji.char,

                style: const TextStyle(
                  fontSize: 100,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Center(
              child: Text(
                kanji.hanViet.join('・'),

                style: const TextStyle(
                  fontSize: 28,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text('📖 Nghĩa'),

            Text(kanji.meanings.join(', ')),

            const SizedBox(height: 16),

            Text('🔊 Cách đọc'),

            Text([...kanji.onyomi, ...kanji.kunyomi].join(', ')),

            if (kanji.hint.isNotEmpty) ...[
              const SizedBox(height: 16),

              Text('💡 Mẹo nhớ'),

              Text(kanji.hint),
            ],
          ],
        ),
      ),
    );
  }
}
