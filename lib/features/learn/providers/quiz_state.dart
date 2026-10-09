import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/quiz_session.dart';

class QuizState {
  const QuizState({
    this.session,
    this.loading = false,
    this.error,
    this.selectedMethod,
    this.selectedCount,
  });

  final QuizSession? session;

  final bool loading;

  final String? error;

  final LearnMethod? selectedMethod;

  final int? selectedCount;

  QuizState copyWith({
    QuizSession? session,
    bool? loading,
    String? error,
    LearnMethod? selectedMethod,
    int? selectedCount,
  }) {
    return QuizState(
      session: session ?? this.session,
      loading: loading ?? this.loading,
      error: error,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      selectedCount: selectedCount ?? this.selectedCount,
    );
  }

  static const initial = QuizState();
}
