import 'package:bikip_kanji_app/features/learn/widgets/result_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import 'package:bikip_kanji_app/data/models/quiz_session.dart';
import '../providers/quiz_controller.dart';
import '../widgets/answer_input_widget.dart';
import '../widgets/question_card_widget.dart';
import '../widgets/quiz_progress_bar_widget.dart';
import '../widgets/quiz_summary_widget.dart';

class QuizPlayScreen extends ConsumerWidget {
  const QuizPlayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizControllerProvider);

    final session = state.session;

    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('KhÃ´ng cÃ³ phiÃªn há»c')),
      );
    }

    if (session.phase == QuizPhase.finished) {
      final correct = session.results.values.where((e) => e).length;

      final mistakes = session.questions
          .where((q) => session.results[q.key] == false)
          .toList();

      return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: QuizSummaryWidget(
            correct: correct,
            total: session.questions.length,
            mistakes: mistakes,
            reviewMode: session.mode == QuizMode.review,
            onReview: () {
              ref.read(quizControllerProvider.notifier).reviewMistakes();
            },
            onRestart: () {
              ref.read(quizControllerProvider.notifier).restart();

              Navigator.pop(context);
            },
          ),
        ),
      );
    }

    final question = session.currentQuestion!;

    final repo = ref.read(contentRepositoryProvider);

    final item = repo.itemById(question.contentType, question.itemId);

    if (item == null) {
      return const Scaffold(
        body: Center(child: Text('KhÃ´ng tÃ¬m tháº¥y dá»¯ liá»‡u')),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            QuizProgressBarWidget(
              current: session.currentIndex + 1,
              total: session.questions.length,
            ),

            const SizedBox(height: 24),

            Expanded(child: QuestionCardWidget(item: item)),

            if (session.phase == QuizPhase.answering)
              AnswerInputWidget(
                onSubmit: (answer) {
                  ref.read(quizControllerProvider.notifier).submit(answer);
                },
              ),

            if (session.phase == QuizPhase.result && session.lastResult != null)
              ResultPanelWidget(
                item: item,
                correct: session.lastResult!.correct,
                status: session.lastResult!.status,
                input: session.lastInput ?? '',
                expected: session.lastResult!.expected,
                last: session.currentIndex == session.questions.length - 1,
                onNext: () {
                  ref.read(quizControllerProvider.notifier).next();
                },
              ),
          ],
        ),
      ),
    );
  }
}
