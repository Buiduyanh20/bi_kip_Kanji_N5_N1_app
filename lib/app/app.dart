import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class BikipKanjiApp extends StatelessWidget {
  const BikipKanjiApp({super.key, required this.hasSeenWelcome});

  final bool hasSeenWelcome;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bí Kíp Kanji',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: createAppRouter(hasSeenWelcome: hasSeenWelcome),
    );
  }
}
