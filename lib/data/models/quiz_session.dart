import 'package:bikip_kanji_app/core/logic/answer_checker.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/quiz_question.dart';

enum QuizMode { learn, review }

enum QuizPhase { answering, result, finished }

class QuizSession {
  const QuizSession({
    required this.mode,
    required this.contentType,
    required this.level,
    required this.method,
    required this.questions,
    this.currentIndex = 0,
    this.phase = QuizPhase.answering,
    this.results = const {},
    this.lastInput,
    this.lastCorrect,
    this.lastResult,
  });

  final QuizMode mode;

  final ContentType contentType;

  final JlptLevel level;

  final LearnMethod method;

  final List<QuizQuestion> questions;

  final int currentIndex;

  final QuizPhase phase;

  final Map<String, bool> results;

  final String? lastInput;

  final bool? lastCorrect;

  final AnswerResult? lastResult;

  QuizQuestion? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  QuizSession copyWith({
    QuizMode? mode,
    int? currentIndex,
    QuizPhase? phase,
    Map<String, bool>? results,
    String? lastInput,
    bool? lastCorrect,
    AnswerResult? lastResult,
  }) {
    return QuizSession(
      mode: mode ?? this.mode,
      contentType: contentType,
      level: level,
      method: method,
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      phase: phase ?? this.phase,
      results: results ?? this.results,
      lastInput: lastInput,
      lastCorrect: lastCorrect,
      lastResult: lastResult,
    );
  }
}
