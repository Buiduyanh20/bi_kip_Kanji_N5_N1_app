import 'dart:convert';

import 'package:bikip_kanji_app/data/models/app_settings.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/favorite.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';

/// Giữ 1 để file web nhập được file của app và ngược lại.
const int kBackupVersion = 1;

class BackupFormatException implements Exception {
  const BackupFormatException(this.message);
  final String message;

  @override
  String toString() => message;
}

class BackupData {
  const BackupData({
    required this.items,
    this.favorites,
    this.settings,
    this.exportedAt,
  });

  final Map<String, ItemProgress> items;

  /// null = file không có trường này (vd file từ web) → giữ nguyên dữ liệu hiện tại.
  final List<Favorite>? favorites;
  final AppSettings? settings;
  final DateTime? exportedAt;
}

class BackupDecodeResult {
  const BackupDecodeResult({required this.data, required this.skipped});
  final BackupData data;

  /// Số mục bị bỏ vì sai cấu trúc hoặc không có trong nội dung app.
  final int skipped;
}

String encodeBackup(BackupData data) {
  final payload = <String, dynamic>{
    'version': kBackupVersion,
    'exportedAt': (data.exportedAt ?? DateTime.now()).toUtc().toIso8601String(),
    'items': {for (final e in data.items.entries) e.key: e.value.toJson()},
    if (data.favorites != null)
      'favorites': [for (final f in data.favorites!) f.toJson()],
    if (data.settings != null) 'settings': data.settings!.toJson(),
  };
  return const JsonEncoder.withIndent('  ').convert(payload);
}

List<LearnMethod> _allowedMethods(ContentType type) => type == ContentType.kanji
    ? LearnMethod.values
    : const [LearnMethod.reading, LearnMethod.meaning];

ItemProgress? _parseItem(String key, Object? raw) {
  if (raw is! Map) return null;
  try {
    final json = Map<String, dynamic>.from(raw);
    final innerId = json['itemId'];
    final itemId = (innerId is String && innerId.isNotEmpty) ? innerId : key;
    json['itemId'] = itemId;
    if (ContentType.tryParse(json['type']?.toString()) == null) {
      json['type'] = itemId.startsWith('vocab') ? 'vocabulary' : 'kanji';
    }
    final parsed = ItemProgress.fromJson(json);
    final allowed = _allowedMethods(parsed.type);
    return ItemProgress(
      itemId: parsed.itemId,
      type: parsed.type,
      level: parsed.level,
      methods: {
        for (final e in parsed.methods.entries)
          if (allowed.contains(e.key)) e.key: e.value,
      },
    );
  } catch (_) {
    return null;
  }
}

/// [isKnown] cho biết id có tồn tại trong nội dung app không.
BackupDecodeResult decodeBackup(
  String text, {
  bool Function(ContentType type, String id)? isKnown,
}) {
  var source = text;
  if (source.startsWith('\uFEFF')) source = source.substring(1);

  Object? root;
  try {
    root = jsonDecode(source);
  } on FormatException {
    throw const BackupFormatException('Tệp không phải JSON hợp lệ.');
  }
  if (root is! Map) {
    throw const BackupFormatException('Tệp tiến độ không hợp lệ.');
  }

  final version = root['version'];
  if (version is num && version > kBackupVersion) {
    throw const BackupFormatException(
      'Tệp được tạo bởi phiên bản mới hơn của ứng dụng.',
    );
  }

  // Giống web: items phải là object (không phải null / mảng).
  final rawItems = root['items'];
  if (rawItems is! Map) {
    throw const BackupFormatException('Tệp tiến độ không hợp lệ.');
  }

  var skipped = 0;

  final items = <String, ItemProgress>{};
  rawItems.forEach((key, value) {
    final item = _parseItem(key.toString(), value);
    if (item == null ||
        item.methods.isEmpty ||
        (isKnown != null && !isKnown(item.type, item.itemId))) {
      skipped++;
      return;
    }
    items[item.itemId] = item;
  });

  List<Favorite>? favorites;
  final rawFavorites = root['favorites'];
  if (rawFavorites is List) {
    final list = <Favorite>[];
    for (final raw in rawFavorites) {
      final fav = Favorite.tryFromJson(raw);
      if (fav == null ||
          (isKnown != null && !isKnown(ContentType.kanji, fav.kanjiId))) {
        skipped++;
        continue;
      }
      list.add(fav);
    }
    favorites = list;
  }

  final rawSettings = root['settings'];
  final settings = rawSettings is Map
      ? AppSettings.fromJson(rawSettings)
      : null;

  final exported = root['exportedAt'];

  return BackupDecodeResult(
    data: BackupData(
      items: items,
      favorites: favorites,
      settings: settings,
      exportedAt: exported is String ? DateTime.tryParse(exported) : null,
    ),
    skipped: skipped,
  );
}
