import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';
import 'package:bikip_kanji_app/data/providers/app_state.dart';
import 'package:bikip_kanji_app/data/repositories/content_repository.dart';
import 'package:bikip_kanji_app/data/repositories/providers.dart';
import 'package:bikip_kanji_app/features/progress/providers/progress_summary_provider.dart';
import 'package:bikip_kanji_app/features/progress/screens/progress_screen.dart';

Kanji _k(String id, String ch) => Kanji(
  id: id,
  char: ch,
  level: JlptLevel.n5,
  hanViet: const ['x'],
  meanings: const ['y'],
  onyomi: const ['イチ'], // để đủ 3 phương pháp
);

final _k1 = _k('k1', '一');
final _k2 = _k('k2', '二');
final _k3 = _k('k3', '三');
const _v1 = Vocab(
  id: 'v1',
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

final _progress = <String, ItemProgress>{
  // k1: mastered cả 3 phương pháp
  'k1': ItemProgress(
    itemId: 'k1',
    type: ContentType.kanji,
    level: JlptLevel.n5,
    methods: {for (final m in LearnMethod.values) m: _mastered},
  ),
  // k2: mới mastered 1/3 → cần cải thiện
  'k2': const ItemProgress(
    itemId: 'k2',
    type: ContentType.kanji,
    level: JlptLevel.n5,
    methods: {LearnMethod.hanviet: _mastered},
  ),
  // k3: chưa có bản ghi → chưa học
  // v1: có bản ghi, chưa mastered → cần cải thiện
  'v1': const ItemProgress(
    itemId: 'v1',
    type: ContentType.vocabulary,
    level: JlptLevel.n4,
    methods: {
      LearnMethod.meaning: MethodProgress(
        wrong: 1,
        status: MasteryStatus.learning,
      ),
    },
  ),
};

ContentRepository _content() => ContentRepository([_k1, _k2, _k3], const [_v1]);

void main() {
  test('computeProgressSections chia 3 nhóm giống ProgressSummary.tsx', () {
    final sections = computeProgressSections(
      content: [_k1, _k2, _k3],
      type: ContentType.kanji,
      methods: LearnMethod.values,
      progress: _progress,
    );
    expect(sections.length, 1);
    final s = sections.single;
    expect(s.title, 'N5 Kanji');
    expect(s.total, 3);
    expect(s.mastered.map((i) => i.id), ['k1']);
    expect(s.learning.map((i) => i.id), ['k2']);
    expect(s.fresh.map((i) => i.id), ['k3']);
  });

  test('chưa học gì: tất cả là chưa học', () {
    final s = computeProgressSections(
      content: [_k1, _k2],
      type: ContentType.kanji,
      methods: LearnMethod.values,
      progress: const {},
    ).single;
    expect(s.mastered, isEmpty);
    expect(s.learning, isEmpty);
    expect(s.fresh.length, 2);
  });

  testWidgets('màn Tiến độ hiện hai thẻ Kanji N5 và Từ vựng N4', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentRepositoryProvider.overrideWithValue(_content()),
          initialProgressProvider.overrideWithValue(_progress),
        ],
        child: const MaterialApp(home: ProgressScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Theo dõi những gì bạn đã nhớ.'), findsOneWidget);
    expect(find.text('N5 Kanji'), findsOneWidget);
    expect(find.text('1/3'), findsOneWidget);
    expect(find.text('N4 Từ vựng'), findsOneWidget);
    expect(find.text('0/1'), findsOneWidget);
    expect(find.text('Còn 1 mục chưa học.'), findsOneWidget); // chỉ Kanji
    expect(find.text('一'), findsOneWidget); // đã nhớ
    expect(find.text('二'), findsOneWidget); // cần cải thiện
    expect(find.text('犬'), findsOneWidget); // cần cải thiện (Từ vựng)
    expect(find.text('Chưa có'), findsOneWidget); // Từ vựng chưa có mục đã nhớ
  });
}
