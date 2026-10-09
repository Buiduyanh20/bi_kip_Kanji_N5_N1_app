import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';

class Vocab extends ContentItem {
  const Vocab({
    required this.id,
    required this.word,
    required this.reading,
    required this.meanings,
    required this.level,
    this.kanjiIds = const [],
  });

  @override
  final String id;
  final String word;
  final String reading;
  @override
  final List<String> meanings;
  @override
  final JlptLevel level;
  final List<String> kanjiIds;

  @override
  ContentType get type => ContentType.vocabulary;

  factory Vocab.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return Vocab(
      id: id,
      word: json['word'] as String,
      reading: json['reading'] as String,
      meanings: readStringList(json['meanings']),
      level: readLevel(json['level'], id),
      kanjiIds: readStringList(json['kanjiIds']),
    );
  }
}