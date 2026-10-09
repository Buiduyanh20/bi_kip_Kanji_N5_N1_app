import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';

class Kanji extends ContentItem {
  const Kanji({
    required this.id,
    required this.char,
    required this.level,
    required this.hanViet,
    required this.meanings,
    this.onyomi = const [],
    this.kunyomi = const [],
    this.hint = '',
    this.story = '',
    this.examples = const [],
  });

  @override
  final String id;
  final String char;
  @override
  final JlptLevel level;
  final List<String> hanViet;
  @override
  final List<String> meanings;
  final List<String> onyomi;
  final List<String> kunyomi;

  /// Mẹo liên tưởng.
  final String hint;
  final String story;
  final List<String> examples;

  @override
  ContentType get type => ContentType.kanji;

  bool get hasReadings => onyomi.isNotEmpty || kunyomi.isNotEmpty;

  factory Kanji.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return Kanji(
      id: id,
      char: json['char'] as String,
      level: readLevel(json['level'], id),
      hanViet: readStringList(json['hanViet']),
      meanings: readStringList(json['meanings']),
      onyomi: readStringList(json['onyomi']),
      kunyomi: readStringList(json['kunyomi']),
      hint: (json['hint'] as String?) ?? '',
      story: (json['story'] as String?) ?? '',
      examples: readStringList(json['examples']),
    );
  }
}