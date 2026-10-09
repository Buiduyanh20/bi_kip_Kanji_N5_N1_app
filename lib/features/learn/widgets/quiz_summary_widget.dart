import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/quiz_question.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';

class QuizSummaryWidget extends ConsumerWidget {
  const QuizSummaryWidget({
    super.key,
    required this.correct,
    required this.total,
    required this.mistakes,
    required this.reviewMode,
    required this.onRestart,
    required this.onReview,
  });

  final int correct;
  final int total;

  final List<QuizQuestion> mistakes;

  final bool reviewMode;

  final VoidCallback onRestart;

  final VoidCallback onReview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(contentRepositoryProvider);

    final grouped = <String, List<QuizQuestion>>{};

    for (final question in mistakes) {
      grouped.putIfAbsent(question.itemId, () => []);

      grouped[question.itemId]!.add(question);
    }

    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                correct == total ? '🎉' : '💪',
                style: const TextStyle(fontSize: 56),
              ),

              const SizedBox(height: 16),

              const Text(
                'Hoàn thành phiên học',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                'Bạn đúng $correct/$total câu',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              if (grouped.isNotEmpty) ...[
                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Câu cần xem lại',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      ...grouped.values.map((questions) {
                        final question = questions.first;

                        final item = repo.itemById(
                          question.contentType,
                          question.itemId,
                        );

                        if (item == null) {
                          return const SizedBox();
                        }

                        final methodLabels = questions
                            .map((q) => q.method.name)
                            .toSet()
                            .join(' • ');

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item is Kanji
                                    ? item.char
                                    : (item as Vocab).word,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      methodLabels,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    if (item is Kanji)
                                      Text(
                                        'Hán Việt: ${item.hanViet.join(", ")}'
                                        '\nNghĩa: ${item.meanings.join(", ")}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),

                                    if (item is Vocab)
                                      Text(
                                        'Đọc: ${item.reading}'
                                        '\nNghĩa: ${item.meanings.join(", ")}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              if (grouped.isNotEmpty && !reviewMode)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: onReview,
                    child: const Text('Ôn các câu sai'),
                  ),
                ),

              if (!reviewMode) ...[
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onRestart,
                    child: const Text('Học lại'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
