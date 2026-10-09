import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/data/models/app_settings.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/favorite.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/backup_repository.dart';
import 'package:bikip_kanji_app/data/repositories/content_repository.dart';
import 'package:bikip_kanji_app/data/repositories/favorite_repository.dart';
import 'package:bikip_kanji_app/data/repositories/progress_repository.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import 'package:bikip_kanji_app/data/repositories/settings_repository.dart';
import 'package:bikip_kanji_app/features/settings/providers/settings_stats_provider.dart';
import 'package:bikip_kanji_app/features/settings/screens/settings_screen.dart';

const _ichi = Kanji(
  id: 'kanji_n5_001',
  char: '一',
  level: JlptLevel.n5,
  hanViet: ['Nhất'],
  meanings: ['Một'],
  onyomi: ['イチ'],
);
const _ni = Kanji(
  id: 'kanji_n5_002',
  char: '二',
  level: JlptLevel.n5,
  hanViet: ['Nhị'],
  meanings: ['Hai'],
);
const _inu = Vocab(
  id: 'vocab_n4_004',
  word: '犬',
  reading: 'いぬ',
  meanings: ['Con chó'],
  level: JlptLevel.n4,
);

const _mastered = MethodProgress(
  correct: 2,
  streak: 2,
  status: MasteryStatus.mastered,
);

/// 一 mastered cả 3 phương pháp (6 câu đúng); 犬 sai 2 lần ở "meaning".
final _progress = <String, ItemProgress>{
  'kanji_n5_001': ItemProgress(
    itemId: 'kanji_n5_001',
    type: ContentType.kanji,
    level: JlptLevel.n5,
    methods: {for (final m in LearnMethod.values) m: _mastered},
  ),
  'vocab_n4_004': const ItemProgress(
    itemId: 'vocab_n4_004',
    type: ContentType.vocabulary,
    level: JlptLevel.n4,
    methods: {
      LearnMethod.meaning: MethodProgress(
        wrong: 2,
        status: MasteryStatus.learning,
      ),
    },
  ),
};

class _FakeSettingsRepo extends Fake implements SettingsRepository {
  @override
  Future<AppSettings> load() async => const AppSettings();
}

class _FakeProgressRepo extends Fake implements ProgressRepository {
  @override
  Future<Map<String, ItemProgress>> loadAll() async => {};
}

class _FakeFavoriteRepo extends Fake implements FavoriteRepository {
  @override
  Stream<List<Favorite>> watchAll() => Stream.value([
    Favorite(kanjiId: 'kanji_n5_001', level: JlptLevel.n5, createdAt: 1),
  ]);
}

class _FakeBackupRepo extends Fake implements BackupRepository {
  int resetCalls = 0;

  @override
  Future<void> resetAll() async => resetCalls++;
}

Future<_FakeBackupRepo> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final backup = _FakeBackupRepo();
  final router = GoRouter(
    initialLocation: AppRoutes.settings,
    routes: [
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, _) => const Scaffold(body: Text('HOME')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentRepositoryProvider.overrideWithValue(
          ContentRepository(const [_ichi, _ni], const [_inu]),
        ),
        initialSettingsProvider.overrideWithValue(const AppSettings()),
        initialProgressProvider.overrideWithValue(_progress),
        settingsRepositoryProvider.overrideWithValue(_FakeSettingsRepo()),
        progressRepositoryProvider.overrideWithValue(_FakeProgressRepo()),
        favoriteRepositoryProvider.overrideWithValue(_FakeFavoriteRepo()),
        backupRepositoryProvider.overrideWithValue(backup),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return backup;
}

void main() {
  test('computeSettingsStats cộng dồn đúng', () {
    final s = computeSettingsStats(
      content: ContentRepository(const [_ichi, _ni], const [_inu]),
      progress: _progress,
      favoriteCount: 1,
    );
    expect(s.kanjiMastered, 1);
    expect(s.kanjiTotal, 2);
    expect(s.vocabMastered, 0);
    expect(s.vocabTotal, 1);
    expect(s.reviewItems, 1);
    expect(s.favorites, 1);
    expect(s.answered, 8);
    expect(s.correct, 6);
    expect(s.accuracyPercent, 75);
  });

  test('chưa có tiến độ: không chia cho 0', () {
    final s = computeSettingsStats(
      content: ContentRepository(const [_ichi], const []),
      progress: const {},
      favoriteCount: 0,
    );
    expect(s.answered, 0);
    expect(s.accuracyPercent, 0);
  });

  testWidgets('hiện thống kê và các khối của màn Cài đặt', (tester) async {
    await _pump(tester);

    expect(find.text('1/2'), findsOneWidget); // Kanji đã nhớ
    expect(find.text('0/1'), findsOneWidget); // Từ vựng đã nhớ
    expect(find.text('Cần ôn'), findsOneWidget);
    expect(find.textContaining('Chính xác 75%'), findsOneWidget);
    expect(find.text('1 chữ cần ôn'), findsOneWidget);
    expect(find.text('1 Kanji đã lưu'), findsOneWidget);
    expect(find.text('Xuất dữ liệu'), findsOneWidget);
    expect(find.text('Nhập dữ liệu'), findsOneWidget);
    expect(find.text('Điều khoản sử dụng'), findsOneWidget);
    expect(find.text('Tên của bạn'), findsNothing);
  });

  testWidgets('Xóa dữ liệu: bấm Hủy thì không xóa', (tester) async {
    final backup = await _pump(tester);
    final button = find.widgetWithText(FilledButton, 'Xóa dữ liệu');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();

    expect(backup.resetCalls, 0);
    expect(find.text('HOME'), findsNothing);
  });

  testWidgets('Xóa dữ liệu: xác nhận thì xóa và về trang chủ', (tester) async {
    final backup = await _pump(tester);
    final button = find.widgetWithText(FilledButton, 'Xóa dữ liệu');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Xóa'));
    await tester.pumpAndSettle();

    expect(backup.resetCalls, 1);
    expect(find.text('HOME'), findsOneWidget);
  });
}
