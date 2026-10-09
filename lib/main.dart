import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/database/app_database.dart';
import 'data/providers/app_state.dart';
import 'data/repositories/content_repository.dart';
import 'data/repositories/progress_repository.dart';
import 'data/repositories/providers.dart';
import 'data/repositories/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final content = await ContentRepository.load();
  final progress = await ProgressRepository(db).loadAll();
  final settings = await SettingsRepository(db).load();

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        contentRepositoryProvider.overrideWithValue(content),
        initialProgressProvider.overrideWithValue(progress),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const BikipKanjiApp(),
    ),
  );
}