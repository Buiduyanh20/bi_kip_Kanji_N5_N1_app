import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/core/constants/labels.dart';
import 'package:bikip_kanji_app/data/models/quiz_session.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import 'package:bikip_kanji_app/features/learn/widgets/result_panel_widget.dart' ;
import '../widgets/question_card_widget.dart';
import '../providers/quiz_controller.dart';
import '../widgets/answer_input_widget.dart';

import '../widgets/quiz_progress_bar_widget.dart';
import '../widgets/quiz_summary_widget.dart';

class QuizPlayScreen extends ConsumerWidget {
  const QuizPlayScreen({super.key});

  static const double _maxWidth = 672;

  Future<void> _confirmExit(BuildContext context) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thoát phiên học?'),
        content: const Text('Các câu đã trả lời đã được lưu vào tiến độ.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Ở lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
    if (leave == true && context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(quizControllerProvider).session;

    if (session == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Không có phiên học')),
      );
    }

    final finished = session.phase == QuizPhase.finished;

    return PopScope(
      canPop: finished,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Đóng',
            onPressed: () => finished ? context.pop() : _confirmExit(context),
          ),
          title: Text(session.mode == QuizMode.review ? 'Ôn tập' : 'Luyện tập'),
        ),
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxWidth),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontal = constraints.maxWidth < 360 ? 12.0 : 16.0;
                  return finished
                      ? _buildSummary(context, ref, session, horizontal)
                      : _buildQuestion(context, ref, session, horizontal);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(
      BuildContext context,
      WidgetRef ref,
      QuizSession session,
      double horizontal,
      ) {
    final correct = session.results.values.where((e) => e).length;
    final mistakes =
    session.questions.where((q) => session.results[q.key] == false).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 16),
      child: QuizSummaryWidget(
        correct: correct,
        total: session.questions.length,
        mistakes: mistakes,
        reviewMode: session.mode == QuizMode.review,
        onReview: () =>
            ref.read(quizControllerProvider.notifier).reviewMistakes(),
        onRestart: () {
          // Web: "Học lại" quay về trang cấu hình của level.
          context.pushReplacement(
            AppRoutes.quizConfigOf(
              session.contentType.name,
              level: session.level.code,
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestion(
      BuildContext context,
      WidgetRef ref,
      QuizSession session,
      double horizontal,
      ) {
    final question = session.currentQuestion;
    final item = question == null
        ? null
        : ref
        .watch(contentRepositoryProvider)
        .itemById(question.contentType, question.itemId);

    if (question == null || item == null) {
      return const Center(child: Text('Không tìm thấy dữ liệu'));
    }

    final controller = ref.read(quizControllerProvider.notifier);
    final result = session.lastResult;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 12),
      child: Column(
        children: [
          QuizProgressBarWidget(
            current: session.currentIndex + 1,
            total: session.questions.length,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  Text(
                    questionLabel(question.contentType, question.method),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  QuestionCardWidget(item: item, method: question.method),
                  const SizedBox(height: 16),
                  if (session.phase == QuizPhase.answering)
                    AnswerInputWidget(
                      // Key mới cho mỗi câu để ô nhập được làm trống.
                      key: ValueKey('${session.mode.name}:${question.key}:'
                          '${session.currentIndex}'),
                      onSubmit: controller.submit,
                    ),
                  if (session.phase == QuizPhase.result && result != null)
                    ResultPanelWidget(
                      item: item,
                      method: question.method,
                      correct: result.correct,
                      status: result.status,
                      input: session.lastInput ?? '',
                      expected: result.expected,
                      last: session.currentIndex ==
                          session.questions.length - 1,
                      onNext: controller.next,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}