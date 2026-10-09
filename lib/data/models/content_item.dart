import 'package:bikip_kanji_app/data/models/enums.dart';

abstract class ContentItem {
  const ContentItem();

  String get id;
  JlptLevel get level;
  List<String> get meanings;
  ContentType get type;
}

List<String> readStringList(Object? value) {
  if (value is! List) return const [];
  return value.map((e) => e.toString()).toList();
}

JlptLevel readLevel(Object? value, String id) {
  final level = JlptLevel.tryParse(value?.toString());
  if (level == null) {
    throw FormatException('Level không hợp lệ ($value) ở item $id');
  }
  return level;
}
