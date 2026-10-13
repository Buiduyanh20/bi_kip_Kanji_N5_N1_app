import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class BikipKanjiApp extends StatefulWidget {
  const BikipKanjiApp({super.key, required this.hasSeenWelcome});

  final bool hasSeenWelcome;

  @override
  State<BikipKanjiApp> createState() => _BikipKanjiAppState();
}

class _BikipKanjiAppState extends State<BikipKanjiApp> {
  late final router = createAppRouter(hasSeenWelcome: widget.hasSeenWelcome);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bí Kíp Kanji',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      routerConfig: router,
    );
  }
}
