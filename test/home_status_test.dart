import 'package:flutter_test/flutter_test.dart';

import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/features/home/providers/home_status_provider.dart';

Kanji k(String id) => Kanji(
  id: id,
  char: id,
  level: JlptLevel.n5,
  hanViet: const ['x'],
  meanings: const ['y'],
  onyomi: const ['イチ'],
);

ItemProgress prog(
  String id,
  Map<LearnMethod, MethodProgress> methods, {
  ContentType type = ContentType.kanji,
}) =>
    ItemProgress(itemId: id, type: type, level: JlptLevel.n5, methods: methods);

const all3 = [LearnMethod.hanviet, LearnMethod.meaning, LearnMethod.reading];
const mastered = MethodProgress(
  correct: 2,
  streak: 2,
  status: MasteryStatus.mastered,
);

HomeStatusData compute(Map<String, ItemProgress> progress) => computeHomeStatus(
  content: [k('a'), k('b'), k('c')],
  methods: all3,
  progress: progress,
);

void main() {
  test('chưa học gì → notStarted', () {
    final s = compute({});
    expect(s.stage, HomeStage.notStarted);
    expect(s.total, 3);
    expect(s.studied, 0);
    expect(s.reviewCount, 0);
  });

  test('đang học: mastered, learning, cần ôn', () {
    final s = compute({
      'a': prog('a', {for (final m in all3) m: mastered}),
      'b': prog('b', {
        LearnMethod.hanviet: const MethodProgress(
          wrong: 1,
          status: MasteryStatus.learning,
        ),
      }),
    });
    expect(s.stage, HomeStage.inProgress);
    expect(s.studied, 2);
    expect(s.mastered, 1);
    expect(s.learning, 1);
    expect(s.reviewCount, 1);
  });

  test(
    'completed khi mọi chữ đã làm ít nhất một lần; reviewCount đếm theo item',
    () {
      final s = compute({
        'a': prog('a', {for (final m in all3) m: mastered}),
        'b': prog('b', {
          LearnMethod.hanviet: const MethodProgress(
            wrong: 2,
            status: MasteryStatus.learning,
          ),
          LearnMethod.meaning: const MethodProgress(
            wrong: 1,
            status: MasteryStatus.learning,
          ),
        }),
        'c': prog('c', {LearnMethod.hanviet: mastered}),
      });
      expect(s.stage, HomeStage.completed);
      expect(s.studied, 3);
      expect(s.mastered, 1);
      expect(s.learning, 2);
      expect(s.reviewCount, 1); // b sai ở 2 method nhưng chỉ tính 1 chữ
    },
  );

  test('lỗi của Vocab hoặc Kanji ngoài N5 không tính', () {
    final s = compute({
      'vocab_x': prog('vocab_x', {
        LearnMethod.meaning: const MethodProgress(
          wrong: 3,
          status: MasteryStatus.learning,
        ),
      }, type: ContentType.vocabulary),
      'kanji_n4_x': prog('kanji_n4_x', {
        LearnMethod.hanviet: const MethodProgress(
          wrong: 3,
          status: MasteryStatus.learning,
        ),
      }),
    });
    expect(s.reviewCount, 0);
    expect(s.studied, 0);
    expect(s.stage, HomeStage.notStarted);
  });
}
