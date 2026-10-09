import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'data/repositories/content_repository.dart';
import 'data/repositories/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final content = await ContentRepository.load();

  runApp(
    ProviderScope(
      overrides: [contentRepositoryProvider.overrideWithValue(content)],
      child: const BikipKanjiApp(),
    ),
  );
}