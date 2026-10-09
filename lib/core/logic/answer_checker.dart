import 'package:bikip_kanji_app/core/logic/kana.dart';
import 'package:bikip_kanji_app/core/logic/text_normalizer.dart';
import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';

enum AnswerStatus { exact, near, incorrect }

class AnswerResult {
  const AnswerResult({required this.status, this.expected = const []});

  final AnswerStatus status;

  /// Đáp án hiển thị cho người học.
  final List<String> expected;

  /// Web tính cả `exact` và `near` là đúng.
  bool get correct => status != AnswerStatus.incorrect;
}

// ───────────────────────── Đáp án mong đợi ─────────────────────────

List<String> getMeaningAnswers(ContentItem item) => [
  for (final meaning in item.meanings)
    for (final part in meaning.split(','))
      if (part.trim().isNotEmpty) part.trim(),
];

final RegExp _dotOrDash = RegExp(r'[.\-]');

String _cleanReading(String value) =>
    toHiragana(value).replaceAll(_dotOrDash, '').replaceAll(RegExp(r'\s+'), '');

List<String> getReadingAnswers(ContentItem item) {
  final raw = <String>[];
  if (item is Vocab) {
    raw.add(item.reading);
  } else if (item is Kanji) {
    for (final reading in [...item.onyomi, ...item.kunyomi]) {
      final cleaned = reading.replaceAll(_dotOrDash, '');
      final root = reading.split(_dotOrDash).first;
      if (root.isNotEmpty && root != cleaned) {
        raw
          ..add(cleaned)
          ..add(root);
      } else {
        raw.add(cleaned);
      }
    }
  }
  return raw.map(_cleanReading).where((s) => s.isNotEmpty).toSet().toList();
}

// ───────────────────────── Cách đọc ─────────────────────────

final RegExp _readingSeparators = RegExp(r'[\s,，、;；/|]+');

List<String> _parseReadingInput(String value) => value
    .split(_readingSeparators)
    .map((p) => p.trim())
    .where((p) => p.isNotEmpty)
    .toList();

AnswerStatus _validateReading(String userAnswer, List<String> correctAnswers) {
  final input = _parseReadingInput(userAnswer)
      .map(_cleanReading)
      .where((s) => s.isNotEmpty)
      .toList();
  final normalized =
  correctAnswers.map(_cleanReading).where((s) => s.isNotEmpty).toList();

  // Bỏ đáp án là tiền tố của đáp án khác (ひと so với ひとつ).
  final expected = <String>[];
  for (var i = 0; i < normalized.length; i++) {
    final answer = normalized[i];
    var isPrefixOfOther = false;
    for (var j = 0; j < normalized.length; j++) {
      if (j != i && normalized[j].startsWith(answer)) {
        isPrefixOfOther = true;
        break;
      }
    }
    if (!isPrefixOfOther) expected.add(answer);
  }
  if (input.isEmpty || expected.isEmpty) return AnswerStatus.incorrect;

  final exactMatches = input.where(expected.contains).toSet();
  final nearMatches =
  input.where((part) => expected.any((a) => a.startsWith(part))).toSet();

  if (exactMatches.length == expected.length) return AnswerStatus.exact;
  if (nearMatches.isNotEmpty) return AnswerStatus.near;
  return AnswerStatus.incorrect;
}

// ───────────────────────── Nghĩa / Hán Việt ─────────────────────────

/// Các từ không tính là "từ khóa". Phải chuẩn hóa vì so sánh với từ đã bỏ dấu.
final Set<String> _nonKeywordWords =
{'bông', 'phía', 'hướng', 'cái', 'con', 'mùa', 'sức'}
    .map(normalizeViet)
    .toSet();

List<String> _meaningKeywords(String answer) {
  final normalized = normalizeAnswerText(answer);
  final words = normalized
      .split(' ')
      .where((w) => w.length > 1 && !_nonKeywordWords.contains(w))
      .toList();
  return words.isNotEmpty ? words : [normalized];
}

AnswerStatus _validateText(String userAnswer, List<String> correctAnswers) {
  final input = normalizeAnswerText(userAnswer);
  if (input.isEmpty) return AnswerStatus.incorrect;

  if (correctAnswers.any((a) => input == normalizeAnswerText(a))) {
    return AnswerStatus.exact;
  }
  final hasKeyword = correctAnswers.any(
        (a) => _meaningKeywords(a).any((keyword) => input.contains(keyword)),
  );
  return hasKeyword ? AnswerStatus.near : AnswerStatus.incorrect;
}

/// Port của `validateKanjiAnswer`.
AnswerStatus validateAnswer(
    String userAnswer,
    List<String> correctAnswers,
    LearnMethod method,
    ) {
  if (method == LearnMethod.reading) {
    return _validateReading(userAnswer, correctAnswers);
  }
  return _validateText(userAnswer, correctAnswers);
}

// ───────────────────────── API chính ─────────────────────────

AnswerResult checkAnswer({
  required LearnMethod method,
  required String input,
  required ContentItem item,
}) {
  switch (method) {
    case LearnMethod.hanviet:
      if (item is! Kanji) {
        return const AnswerResult(status: AnswerStatus.incorrect);
      }
      return AnswerResult(
        status: validateAnswer(input, item.hanViet, method),
        expected: item.hanViet.map(capitalizeFirst).toList(),
      );
    case LearnMethod.meaning:
      final answers = getMeaningAnswers(item);
      return AnswerResult(
        status: validateAnswer(input, answers, method),
        expected: answers.map(capitalizeFirst).toList(),
      );
    case LearnMethod.reading:
      final answers = getReadingAnswers(item);
      return AnswerResult(
        status: validateAnswer(input, answers, method),
        expected: answers,
      );
  }
}