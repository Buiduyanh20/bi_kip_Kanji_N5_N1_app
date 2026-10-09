import 'package:bikip_kanji_app/data/models/enums.dart';

class Favorite {
  const Favorite({
    required this.kanjiId,
    required this.level,
    required this.createdAt,
  });

  final String kanjiId;
  final JlptLevel level;

  /// Epoch milliseconds, cùng kiểu với `lastAnsweredAt`.
  final int createdAt;

  Map<String, dynamic> toJson() => {
    'kanjiId': kanjiId,
    'level': level.code,
    'createdAt': createdAt,
  };

  static Favorite? tryFromJson(Object? raw) {
    if (raw is! Map) return null;
    final id = raw['kanjiId'];
    final level = JlptLevel.tryParse(raw['level']?.toString());
    final created = raw['createdAt'];
    if (id is! String || id.isEmpty || level == null) return null;
    return Favorite(
      kanjiId: id,
      level: level,
      createdAt: created is num ? created.toInt() : 0,
    );
  }
}