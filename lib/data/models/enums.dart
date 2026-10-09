enum JlptLevel {
  n5('N5'),
  n4('N4'),
  n3('N3'),
  n2('N2'),
  n1('N1');

  const JlptLevel(this.code);
  final String code;

  /// Không phân biệt hoa thường: 'n5' và 'N5' đều được.
  static JlptLevel? tryParse(String? value) {
    if (value == null) return null;
    final upper = value.toUpperCase();
    for (final level in values) {
      if (level.code == upper) return level;
    }
    return null;
  }
}

enum ContentType {
  kanji,
  vocabulary;

  static ContentType? tryParse(String? value) {
    for (final t in values) {
      if (t.name == value) return t;
    }
    return null;
  }
}

enum LearnMethod {
  hanviet,
  meaning,
  reading;

  static LearnMethod? tryParse(String? value) {
    for (final m in values) {
      if (m.name == value) return m;
    }
    return null;
  }
}

enum MasteryStatus {
  newItem('new'),
  learning('learning'),
  mastered('mastered');

  const MasteryStatus(this.key);

  /// Chuỗi lưu trong DB / backup, trùng với web.
  final String key;

  static MasteryStatus fromKey(String? key) {
    for (final s in values) {
      if (s.key == key) return s;
    }
    return MasteryStatus.newItem;
  }
}
