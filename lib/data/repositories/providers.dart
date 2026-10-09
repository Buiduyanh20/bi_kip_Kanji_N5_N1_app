import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bikip_kanji_app/core/database/app_database.dart';
import 'package:bikip_kanji_app/data/repositories/backup_repository.dart';
import 'package:bikip_kanji_app/data/repositories/content_repository.dart';
import 'package:bikip_kanji_app/data/repositories/favorite_repository.dart';
import 'package:bikip_kanji_app/data/repositories/progress_repository.dart';
import 'package:bikip_kanji_app/data/repositories/settings_repository.dart';

/// Các provider dưới đây được override trong main().
final contentRepositoryProvider = Provider<ContentRepository>(
      (ref) => throw UnimplementedError('contentRepositoryProvider'),
);

final appDatabaseProvider = Provider<AppDatabase>(
      (ref) => throw UnimplementedError('appDatabaseProvider'),
);

final progressRepositoryProvider = Provider<ProgressRepository>(
      (ref) => ProgressRepository(ref.watch(appDatabaseProvider)),
);

final favoriteRepositoryProvider = Provider<FavoriteRepository>(
      (ref) => FavoriteRepository(ref.watch(appDatabaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
      (ref) => SettingsRepository(ref.watch(appDatabaseProvider)),
);

final backupRepositoryProvider = Provider<BackupRepository>(
      (ref) => BackupRepository(
    db: ref.watch(appDatabaseProvider),
    progress: ref.watch(progressRepositoryProvider),
    favorites: ref.watch(favoriteRepositoryProvider),
    settings: ref.watch(settingsRepositoryProvider),
    content: ref.watch(contentRepositoryProvider),
  ),
);