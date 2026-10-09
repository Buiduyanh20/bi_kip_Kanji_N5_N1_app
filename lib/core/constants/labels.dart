import 'package:bikip_kanji_app/data/models/enums.dart';

String methodLabel(ContentType type, LearnMethod method) {
  if (type == ContentType.kanji) {
    switch (method) {
      case LearnMethod.hanviet:
        return 'Kanji → Hán Việt';
      case LearnMethod.meaning:
        return 'Kanji → Nghĩa';
      case LearnMethod.reading:
        return 'Kanji → Cách đọc';
    }
  }
  return method == LearnMethod.reading ? 'Từ → Cách đọc' : 'Từ → Nghĩa';
}

String questionLabel(ContentType type, LearnMethod method) {
  if (type == ContentType.kanji) {
    switch (method) {
      case LearnMethod.hanviet:
        return 'Âm Hán Việt là gì?';
      case LearnMethod.meaning:
        return 'Nghĩa của chữ này là gì?';
      case LearnMethod.reading:
        return 'Cách đọc của chữ này là gì?';
    }
  }
  return method == LearnMethod.reading
      ? 'Từ này đọc thế nào?'
      : 'Từ này có nghĩa là gì?';
}

String contentTypeLabel(ContentType type) =>
    type == ContentType.kanji ? 'Kanji' : 'Từ vựng';

String statusLabel(MasteryStatus status) {
  switch (status) {
    case MasteryStatus.newItem:
      return 'Mới';
    case MasteryStatus.learning:
      return 'Đang học';
    case MasteryStatus.mastered:
      return 'Đã nhớ';
  }
}