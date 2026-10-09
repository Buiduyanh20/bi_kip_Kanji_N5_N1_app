import 'package:bikip_kanji_app/data/models/enums.dart';

class QuizQuestion {
  const QuizQuestion({
    required this.itemId,
    required this.contentType,
    required this.method,
  });

  final String itemId;
  final ContentType contentType;
  final LearnMethod method;

  /// Giống web: `itemId:method`.
  String get key => '$itemId:${method.name}';
}
