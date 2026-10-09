import 'package:bikip_kanji_app/data/models/quiz_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:bikip_kanji_app/app/router.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/content_repository.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import 'package:bikip_kanji_app/features/learn/providers/quiz_controller.dart';
import 'package:bikip_kanji_app/features/review/providers/review_provider.dart';
import 'package:bikip_kanji_app/features/review/screens/review_screen.dart';

const _ichi = Kanji(
  id: 'kanji_n5_001',
  char: '一',
  level: JlptLevel.n5,
  hanViet: ['Nhất'],
  meanings: ['Một'],
);
const _inu = Vocab(
  id: 'vocab_n4_004',
  word: '犬',
  reading: 'いぬ',
  meanings: ['Con chó'],
  level: JlptLevel.n4,
);

ContentRepository _content() => ContentRepository(const [_ichi], const [_inu]);

Map<String, ItemProgress> _mistakes() => {
  'kanji_n5_001': const ItemProgress(
    itemId: 'kanji_n5_001',
    type: ContentType.kanji,
    level: JlptLevel.n5,
    methods: {
      LearnMethod.hanviet: MethodProgress(
        wrong: 1,
        status: MasteryStatus.learning,
      ),
    },
  ),
  'vocab_n4_004': const ItemProgress(
    itemId: 'vocab_n4_004',
    type: ContentType.vocabulary,
    level: JlptLevel.n4,
    methods: {
      LearnMethod.meaning: MethodProgress(
        wrong: 3,
        status: MasteryStatus.learning,
      ),
    },
  ),
  // Không còn trong nội dung → bị bỏ (giống useMistakes).
  'kanji_ghost': const ItemProgress(
    itemId: 'kanji_ghost',
    type: ContentType.kanji,
    methods: {
      LearnMethod.hanviet: MethodProgress(
        wrong: 9,
        status: MasteryStatus.learning,
      ),
    },
  ),
};

Future<ProviderContainer> _pump(
  WidgetTester tester,
  Map<String, ItemProgress> progress,
) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: AppRoutes.review,
    routes: [
      GoRoute(path: AppRoutes.review, builder: (_, _) => const ReviewScreen()),
      GoRoute(
        path: AppRoutes.quizPlay,
        builder: (_, _) => const Scaffold(body: Text('QUIZ')),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, _) => const Scaffold(body: Text('KANJI TAB')),
      ),
      GoRoute(
        path: '${AppRoutes.kanjiDetail}/:id',
        builder: (_, s) =>
            Scaffold(body: Text('DETAIL ${s.pathParameters['id']}')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        contentRepositoryProvider.overrideWithValue(_content()),
        initialProgressProvider.overrideWithValue(progress),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(ReviewScreen)));
}

void main() {
  test(
    'computeReviewEntries sắp theo số lần sai và bỏ mục không có nội dung',
    () {
      final entries = computeReviewEntries(
        content: _content(),
        progress: _mistakes(),
      );
      expect(entries.map((e) => e.key), [
        'vocab_n4_004:meaning',
        'kanji_n5_001:hanviet',
      ]);
    },
  );

  testWidgets('không có lỗi: hiện empty state, nút Học Kanji về tab Kanji', (
    tester,
  ) async {
    await _pump(tester, const {});
    expect(find.text('Chưa có mục nào cần ôn'), findsOneWidget);
    expect(find.text('Ôn tập (0 mục)'), findsNothing);

    await tester.tap(find.text('Học Kanji'));
    await tester.pumpAndSettle();
    expect(find.text('KANJI TAB'), findsOneWidget);
  });

  testWidgets('có lỗi: hiện danh sách, số lượng và lọc', (tester) async {
    await _pump(tester, _mistakes());

    expect(find.text('2 mục cần cải thiện'), findsOneWidget);
    expect(find.text('Sai 3 lần'), findsOneWidget);
    expect(find.text('Sai 1 lần'), findsOneWidget);

    await tester.tap(find.text('Kanji').first);
    await tester.pump();
    expect(find.text('Sai 3 lần'), findsNothing);
    expect(find.text('Sai 1 lần'), findsOneWidget);
    // Subtitle không đổi theo bộ lọc (giống web).
    expect(find.text('2 mục cần cải thiện'), findsOneWidget);

    await tester.tap(find.text('Từ vựng'));
    await tester.pump();
    expect(find.text('Sai 3 lần'), findsOneWidget);
    expect(find.text('Sai 1 lần'), findsNothing);
  });

  testWidgets('bấm Ôn tập: dựng phiên review từ toàn bộ lỗi, bỏ qua bộ lọc', (
    tester,
  ) async {
    final c = await _pump(tester, _mistakes());

    await tester.tap(find.text('Từ vựng')); // lọc nhưng vẫn ôn tất cả
    await tester.pump();
    await tester.tap(find.text('Ôn tập (2 mục)'));
    await tester.pumpAndSettle();

    final s = c.read(quizControllerProvider).session!;
    expect(s.mode, QuizMode.review);
    expect(s.questions.map((q) => q.key).toSet(), {
      'kanji_n5_001:hanviet',
      'vocab_n4_004:meaning',
    });
    expect(find.text('QUIZ'), findsOneWidget);
  });

  testWidgets('chạm Kanji mở chi tiết, Từ vựng thì không', (tester) async {
    await _pump(tester, _mistakes());

    await tester.tap(find.text('一'));
    await tester.pumpAndSettle();
    expect(find.text('DETAIL kanji_n5_001'), findsOneWidget);
  });
}
