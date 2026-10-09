import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/screens/home_screen.dart';
import '../features/kanji_detail/screens/kanji_detail_screen.dart';
import '../features/learn/screens/quiz_config_screen.dart';
import '../features/learn/screens/quiz_play_screen.dart';
import '../features/progress/screens/progress_screen.dart';
import '../features/review/screens/review_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/shell/screens/main_shell_screen.dart';

/// Các loại quiz, truyền qua query param `type`.
abstract final class QuizType {
  static const kanji = 'kanji';
  static const vocab = 'vocab';
  static const review = 'review';
}

/// Toàn bộ đường dẫn tập trung một chỗ, tránh gõ chuỗi rải rác.
abstract final class AppRoutes {
  // Tab trong shell
  static const home = '/home';
  static const review = '/review';
  static const progress = '/progress';
  static const settings = '/settings';

  // Toàn màn hình
  static const quizConfig = '/learn/config';
  static const quizPlay = '/learn/play';
  static const kanjiDetail = '/kanji'; // + /:id

  // Helper dựng đường dẫn
  static String quizConfigOf(String type) => '$quizConfig?type=$type';
  static String quizPlayOf(String type) => '$quizPlay?type=$type';
  static String kanjiDetailOf(String id) => '$kanjiDetail/$id';
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    // ── Shell: bottom nav 4 tab, mỗi tab giữ state riêng ──
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShellScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.review,
            name: 'review',
            builder: (context, state) => const ReviewScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.progress,
            name: 'progress',
            builder: (context, state) => const ProgressScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ]),
      ],
    ),

    // ── Toàn màn hình (đè lên bottom nav nhờ root navigator) ──
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.quizConfig,
      name: 'quizConfig',
      builder: (context, state) => QuizConfigScreen(
        type: state.uri.queryParameters['type'] ?? QuizType.kanji,
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.quizPlay,
      name: 'quizPlay',
      builder: (context, state) => QuizPlayScreen(
        type: state.uri.queryParameters['type'] ?? QuizType.kanji,
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '${AppRoutes.kanjiDetail}/:id',
      name: 'kanjiDetail',
      builder: (context, state) => KanjiDetailScreen(
        kanjiId: state.pathParameters['id']!,
      ),
    ),
  ],
);