import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bikip_kanji_app/core/logic/answer_checker.dart';
import 'package:bikip_kanji_app/core/logic/quiz_builder.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/quiz_session.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import 'quiz_state.dart';

class QuizController extends Notifier<QuizState> {
  @override
  QuizState build() {
    return QuizState.initial;
  }

  void start({
    required ContentType contentType,
    required JlptLevel level,
    required LearnMethod method,
    required int count,
  }) {
    final content = ref.read(contentRepositoryProvider);

    final progress = ref.read(progressProvider);

    final questions = buildLearnQuiz(
      contentType: contentType,
      items: content.itemsByLevel(contentType, level),
      method: method,
      count: count,
      progress: progress,
      rng: Random(),
    );

    final session = QuizSession(
      mode: QuizMode.learn,
      contentType: contentType,
      level: level,
      method: method,
      questions: questions,
    );

    state = state.copyWith(
      session: session,
      selectedMethod: method,
      selectedCount: count,
      error: null,
    );
  }

  /// Ôn tập từ toàn bộ lỗi sai trong tiến độ (web: ReviewClient.startReview).
  /// Trả về false nếu không có câu nào.
  bool startReview({ContentType? contentType, int? count}) {
    final content = ref.read(contentRepositoryProvider);

    final questions = buildReviewQuiz(
      progress: ref.read(progressProvider),
      contentType: contentType,
      count: count,
      rng: Random(),
    ).where((q) => content.itemById(q.contentType, q.itemId) != null).toList();

    if (questions.isEmpty) return false;

    // QuizSession của bạn bắt buộc có contentType/level/method (không null),
    // trong khi ôn tập trộn nhiều loại. Lấy theo câu đầu tiên, giống web
    // (`contentType: questions[0]?.contentType ?? "kanji"`).
    final first = questions.first;
    final firstItem = content.itemById(first.contentType, first.itemId)!;

    state = state.copyWith(
      session: QuizSession(
        mode: QuizMode.review,
        contentType: first.contentType,
        level: firstItem.level,
        method: first.method,
        questions: questions,
      ),
      error: null,
    );
    return true;
  }

  Future<void> submit(String answer) async {
    final session = state.session;

    if (session == null) return;

    if (session.phase != QuizPhase.answering) return;

    final question = session.currentQuestion;

    if (question == null) return;

    if (session.results.containsKey(question.key)) {
      return;
    }

    final content = ref.read(contentRepositoryProvider);

    final item = content.itemById(question.contentType, question.itemId);

    if (item == null) return;

    final result = checkAnswer(
      method: question.method,
      input: answer,
      item: item,
    );

    await ref
        .read(progressProvider.notifier)
        .recordAnswer(
          item: item,
          method: question.method,
          isCorrect: result.correct,
        );

    state = state.copyWith(
      session: session.copyWith(
        phase: QuizPhase.result,
        lastInput: answer,
        lastCorrect: result.correct,
        lastResult: result,
        results: {...session.results, question.key: result.correct},
      ),
    );
  }

  void next() {
    final session = state.session;

    if (session == null) return;

    if (session.phase != QuizPhase.result) return;

    final nextIndex = session.currentIndex + 1;

    if (nextIndex >= session.questions.length) {
      state = state.copyWith(
        session: session.copyWith(phase: QuizPhase.finished),
      );
      return;
    }

    state = state.copyWith(
      session: session.copyWith(
        currentIndex: nextIndex,
        phase: QuizPhase.answering,
        lastInput: null,
        lastCorrect: null,
        lastResult: null,
      ),
    );
  }

  void restart() {
    clear();
  }

  void reviewMistakes() {
    final session = state.session;
    if (session == null) return;

    final wrong = session.questions
        .where((q) => session.results[q.key] == false)
        .toList();
    if (wrong.isEmpty) return;

    state = state.copyWith(
      session: QuizSession(
        mode: QuizMode.review,
        contentType: session.contentType,
        level: session.level,
        method: session.method,
        questions: wrong,
      ),
    );
  }

  void clear() {
    state = QuizState.initial;
  }
}

final quizControllerProvider = NotifierProvider<QuizController, QuizState>(
  QuizController.new,
);
