import 'package:bikip_kanji_app/features/welcome/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models/enums.dart';
import '../features/favorite/screens/favorite_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/kanji_detail/screens/kanji_detail_screen.dart';
import '../features/learn/screens/quiz_config_screen.dart';
import '../features/learn/screens/quiz_play_screen.dart';
import '../features/progress/screens/progress_screen.dart';
import '../features/review/screens/review_screen.dart';
import '../features/search/screens/kanji_search_screen.dart';
import '../features/settings/screens/privacy_policy_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/settings/screens/terms_of_service_screen.dart';
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
  static const favorite = '/favorite';
  static const progress = '/progress';
  static const settings = '/settings';

  // Toàn màn hình
  static const quizConfig = '/learn/config';
  static const quizPlay = '/learn/play';
  static const kanjiDetail = '/kanji'; // + /:id
  static const kanjiSearch = '/kanji/search';
  static const welcome = '/welcome';
  static const privacyPolicy = '/settings/privacy';
  static const termsOfService = '/settings/terms';

  // Helper dựng đường dẫn
  static String quizConfigOf(String type, {String level = 'n5'}) =>
      '$quizConfig?type=$type&level=$level';
  static String quizPlayOf(String type) => '$quizPlay?type=$type';
  static String kanjiDetailOf(String id) => '$kanjiDetail/$id';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

GoRouter createAppRouter({required bool hasSeenWelcome}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: hasSeenWelcome ? AppRoutes.home : AppRoutes.welcome,
    routes: [
      // ── Welcome (chỉ lần đầu) ──
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      // ── Shell: bottom nav 5 tab ──
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.review,
                name: 'review',
                builder: (context, state) => const ReviewScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorite,
                name: 'favorite',
                builder: (context, state) => const FavoriteScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                name: 'progress',
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Toàn màn hình ──
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.quizConfig,
        name: 'quizConfig',
        builder: (context, state) {
          final typeStr = state.uri.queryParameters['type'] ?? 'kanji';
          final levelStr = state.uri.queryParameters['level'] ?? 'n5';

          return QuizConfigScreen(
            contentType: ContentType.values.byName(typeStr),
            level: JlptLevel.values.byName(levelStr),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.quizPlay,
        name: 'quizPlay',
        builder: (context, state) => const QuizPlayScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.kanjiSearch,
        builder: (context, state) => const KanjiSearchScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoutes.termsOfService,
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '${AppRoutes.kanjiDetail}/:id',
        name: 'kanjiDetail',
        builder: (context, state) =>
            KanjiDetailScreen(kanjiId: state.pathParameters['id']!),
      ),
    ],
  );
}
