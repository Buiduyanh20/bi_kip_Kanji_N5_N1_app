import 'package:bikip_kanji_app/core/constants/app_constants.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';

class MethodProgress {
  const MethodProgress({
    this.correct = 0,
    this.wrong = 0,
    this.streak = 0,
    this.status = MasteryStatus.newItem,
    this.lastAnsweredAt = 0,
  });

  final int correct;
  final int wrong;
  final int streak;
  final MasteryStatus status;

  /// Epoch milliseconds (0 = chưa trả lời), giống web.
  final int lastAnsweredAt;

  /// Port của `recordAnswer` bên web.
  MethodProgress afterAnswer({required bool isCorrect, int? nowMs}) {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    if (isCorrect) {
      final newStreak = streak + 1;
      return MethodProgress(
        correct: correct + 1,
        wrong: wrong,
        streak: newStreak,
        status: newStreak >= AppConstants.masteryStreak
            ? MasteryStatus.mastered
            : MasteryStatus.learning,
        lastAnsweredAt: now,
      );
    }
    return MethodProgress(
      correct: correct,
      wrong: wrong + 1,
      streak: 0,
      status: MasteryStatus.learning,
      lastAnsweredAt: now,
    );
  }

  Map<String, dynamic> toJson() => {
    'correct': correct,
    'wrong': wrong,
    'streak': streak,
    'status': status.key,
    'lastAnsweredAt': lastAnsweredAt,
  };

  factory MethodProgress.fromJson(Map<String, dynamic> json) => MethodProgress(
    correct: (json['correct'] as num?)?.toInt() ?? 0,
    wrong: (json['wrong'] as num?)?.toInt() ?? 0,
    streak: (json['streak'] as num?)?.toInt() ?? 0,
    status: MasteryStatus.fromKey(json['status'] as String?),
    lastAnsweredAt: (json['lastAnsweredAt'] as num?)?.toInt() ?? 0,
  );
}

class ItemProgress {
  const ItemProgress({
    required this.itemId,
    required this.type,
    this.level,
    this.methods = const {},
  });

  final String itemId;
  final ContentType type;
  final JlptLevel? level;
  final Map<LearnMethod, MethodProgress> methods;

  ItemProgress recordAnswer(
      LearnMethod method, {
        required bool isCorrect,
        int? nowMs,
      }) {
    final previous = methods[method] ?? const MethodProgress();
    return ItemProgress(
      itemId: itemId,
      type: type,
      level: level,
      methods: {
        ...methods,
        method: previous.afterAnswer(isCorrect: isCorrect, nowMs: nowMs),
      },
    );
  }

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'type': type.name,
    if (level != null) 'level': level!.code,
    'methods': {
      for (final e in methods.entries) e.key.name: e.value.toJson(),
    },
  };

  factory ItemProgress.fromJson(Map<String, dynamic> json) {
    final rawMethods = (json['methods'] as Map?) ?? const {};
    final methods = <LearnMethod, MethodProgress>{};
    rawMethods.forEach((key, value) {
      final method = LearnMethod.tryParse(key.toString());
      if (method != null && value is Map) {
        methods[method] =
            MethodProgress.fromJson(Map<String, dynamic>.from(value));
      }
    });
    return ItemProgress(
      itemId: json['itemId'] as String,
      type: ContentType.tryParse(json['type'] as String?) ?? ContentType.kanji,
      level: JlptLevel.tryParse(json['level'] as String?),
      methods: methods,
    );
  }
}