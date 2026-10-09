import 'package:flutter/material.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';

class QuestionCardWidget extends StatelessWidget {
  const QuestionCardWidget({super.key, required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    final text = item is Kanji
        ? item.char
        : item is Vocab
        ? item.word
        : '';

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w700),
            ),
            if (item is Vocab) ...[
              const SizedBox(height: 8),
              Text(
                'Từ vựng',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
