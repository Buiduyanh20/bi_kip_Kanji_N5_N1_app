import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/data/repositories/content_repository.dart';

/// Được override trong main() sau khi nạp xong JSON.
final contentRepositoryProvider = Provider<ContentRepository>(
      (ref) => throw UnimplementedError('contentRepositoryProvider chưa được override'),
);