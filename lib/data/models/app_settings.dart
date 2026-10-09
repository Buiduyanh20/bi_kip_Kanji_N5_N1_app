import 'package:bikip_kanji_app/core/constants/app_constants.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';

/// Web: `lastCount?: number | "all"`.
class CountChoice {
  const CountChoice.all() : count = null;
  const CountChoice.of(int n) : count = n;

  final int? count;
  bool get isAll => count == null;

  String get storageValue => isAll ? 'all' : '$count';
  Object toJson() => isAll ? 'all' : count!;

  static CountChoice? fromJson(Object? v) {
    if (v == 'all') return const CountChoice.all();
    if (v is num && v > 0) return CountChoice.of(v.toInt());
    return null;
  }

  static CountChoice? tryParseStorage(String? s) {
    if (s == null) return null;
    if (s == 'all') return const CountChoice.all();
    final n = int.tryParse(s);
    return (n != null && n > 0) ? CountChoice.of(n) : null;
  }

  @override
  bool operator ==(Object other) =>
      other is CountChoice && other.count == count;

  @override
  int get hashCode => count.hashCode;
}

class AppSettings {
  const AppSettings({this.userName = '', this.lastMethod, this.lastCount});

  final String userName;
  final LearnMethod? lastMethod;
  final CountChoice? lastCount;

  /// Web: `userName.trim().slice(0, 30)`.
  static String sanitizeUserName(String value) {
    final trimmed = value.trim();
    return String.fromCharCodes(
      trimmed.runes.take(AppConstants.maxUserNameLength),
    );
  }

  AppSettings copyWith({
    String? userName,
    LearnMethod? lastMethod,
    CountChoice? lastCount,
  }) => AppSettings(
    userName: userName ?? this.userName,
    lastMethod: lastMethod ?? this.lastMethod,
    lastCount: lastCount ?? this.lastCount,
  );

  Map<String, dynamic> toJson() => {
    'userName': userName,
    if (lastMethod != null) 'lastMethod': lastMethod!.name,
    if (lastCount != null) 'lastCount': lastCount!.toJson(),
  };

  factory AppSettings.fromJson(Map<dynamic, dynamic> json) {
    final name = json['userName'];
    final method = json['lastMethod'];
    return AppSettings(
      userName: name is String ? sanitizeUserName(name) : '',
      lastMethod: method is String ? LearnMethod.tryParse(method) : null,
      lastCount: CountChoice.fromJson(json['lastCount']),
    );
  }
}
