import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class BikipKanjiApp extends StatelessWidget {
  const BikipKanjiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bí Kíp Kanji',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}