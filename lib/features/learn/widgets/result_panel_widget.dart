import 'package:flutter/material.dart';

import 'package:bikip_kanji_app/core/logic/answer_checker.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';

class ResultPanelWidget extends StatelessWidget {
  const ResultPanelWidget({
    super.key,
    required this.item,
    required this.correct,
    required this.status,
    required this.input,
    required this.expected,
    required this.onNext,
    required this.last,
  });

  final dynamic item;

  final bool correct;

  final AnswerStatus status;

  final String input;

  final List<String> expected;

  final VoidCallback onNext;

  final bool last;

  @override
  Widget build(BuildContext context) {
    final isNear = status == AnswerStatus.near;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              isNear
                  ? '△ Gần đúng'
                  : correct
                  ? '✓ Chính xác'
                  : '✕ Chưa đúng',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: correct ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 12),

            Text('Bạn nhập: ${input.isEmpty ? "Không có đáp án" : input}'),

            const SizedBox(height: 8),

            Text(
              isNear
                  ? 'Đáp án đầy đủ: ${expected.join(", ")}'
                  : 'Đáp án: ${expected.join(", ")}',
            ),

            if (!correct) ...[
              const SizedBox(height: 8),
              Text(
                'Đã thêm vào danh sách ôn tập',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],

            const SizedBox(height: 24),

            Text(
              item is Kanji ? item.char : item.word,
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(item is Vocab ? item.reading : item.meanings.join(' · ')),

            if (item is Kanji && item.hint.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Mẹo: ${item.hint}'),
              ),
            ],

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onNext,
                child: Text(last ? 'Xem kết quả' : 'Tiếp tục'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
