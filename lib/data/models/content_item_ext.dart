import 'package:bikip_kanji_app/data/models/content_item.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';

extension ContentItemDisplay on ContentItem {
  /// Web: `"char" in item ? item.char : item.word`.
  String get displayText {
    final self = this;
    if (self is Kanji) return self.char;
    if (self is Vocab) return self.word;
    return id;
  }
}
