import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:bikip_kanji_app/core/logic/answer_checker.dart';
import 'package:bikip_kanji_app/core/logic/mastery.dart';
import 'package:bikip_kanji_app/core/logic/quiz_builder.dart';
import 'package:bikip_kanji_app/core/logic/text_normalizer.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/kanji.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';
import 'package:bikip_kanji_app/data/models/vocab.dart';

const ichi = Kanji(
  id: 'kanji_n5_001',
  char: '一',
  level: JlptLevel.n5,
  hanViet: ['Nhất'],
  meanings: ['Một'],
  onyomi: ['イチ', 'イツ'],
  kunyomi: ['ひと.つ'],
);

const inu = Vocab(
  id: 'vocab_n4_004',
  word: '犬',
  reading: 'いぬ',
  meanings: ['Con chó'],
  level: JlptLevel.n4,
  kanjiIds: ['kanji_n4_009'],
);

Kanji k(String id) => Kanji(
  id: id,
  char: id,
  level: JlptLevel.n5,
  hanViet: const ['x'],
  meanings: const ['y'],
);

void main() {
  group('normalizeViet', () {
    test('bỏ dấu, đ→d, gộp khoảng trắng', () {
      expect(normalizeViet('  Mẫu '), 'mau');
      expect(normalizeViet('Đức   Hạnh'), 'duc hanh');
      expect(normalizeViet('Nhất'), 'nhat');
    });
    test('capitalizeFirst', () {
      expect(capitalizeFirst('nhất'), 'Nhất');
      expect(capitalizeFirst('  '), '');
    });
  });

  group('Hán Việt / Nghĩa', () {
    test('Hán Việt: gõ không dấu vẫn exact', () {
      final r = checkAnswer(
        method: LearnMethod.hanviet,
        input: 'nhat',
        item: ichi,
      );
      expect(r.status, AnswerStatus.exact);
      expect(r.expected, ['Nhất']);
    });
    test('Hán Việt sai', () {
      final r = checkAnswer(
        method: LearnMethod.hanviet,
        input: 'mot',
        item: ichi,
      );
      expect(r.correct, isFalse);
    });
    test('Nghĩa: exact và near', () {
      expect(
        checkAnswer(
          method: LearnMethod.meaning,
          input: 'mot',
          item: ichi,
        ).status,
        AnswerStatus.exact,
      );
      expect(
        checkAnswer(
          method: LearnMethod.meaning,
          input: 'số một',
          item: ichi,
        ).status,
        AnswerStatus.near,
      );
    });
    test('Từ khóa bỏ qua "con"', () {
      expect(
        checkAnswer(
          method: LearnMethod.meaning,
          input: 'con cho',
          item: inu,
        ).status,
        AnswerStatus.exact,
      );
      expect(
        checkAnswer(
          method: LearnMethod.meaning,
          input: 'cho',
          item: inu,
        ).status,
        AnswerStatus.near,
      );
      expect(
        checkAnswer(
          method: LearnMethod.meaning,
          input: 'con',
          item: inu,
        ).correct,
        isFalse,
      );
    });
    test('Input rỗng là sai', () {
      expect(
        checkAnswer(
          method: LearnMethod.meaning,
          input: '   ',
          item: ichi,
        ).correct,
        isFalse,
      );
    });
  });

  group('Cách đọc', () {
    test('đáp án mong đợi bỏ tiền tố', () {
      expect(getReadingAnswers(ichi), ['いち', 'いつ', 'ひとつ', 'ひと']);
    });
    test('một cách đọc là near, đủ hết là exact', () {
      expect(
        checkAnswer(
          method: LearnMethod.reading,
          input: 'いち',
          item: ichi,
        ).status,
        AnswerStatus.near,
      );
      expect(
        checkAnswer(
          method: LearnMethod.reading,
          input: 'ichi',
          item: ichi,
        ).status,
        AnswerStatus.near,
      );
      expect(
        checkAnswer(
          method: LearnMethod.reading,
          input: 'イチ',
          item: ichi,
        ).status,
        AnswerStatus.near,
      );
      expect(
        checkAnswer(
          method: LearnMethod.reading,
          input: 'いち いつ ひとつ',
          item: ichi,
        ).status,
        AnswerStatus.exact,
      );
      expect(
        checkAnswer(
          method: LearnMethod.reading,
          input: 'ひと',
          item: ichi,
        ).status,
        AnswerStatus.near,
      );
    });
    test('sai', () {
      expect(
        checkAnswer(
          method: LearnMethod.reading,
          input: 'ほげ',
          item: ichi,
        ).correct,
        isFalse,
      );
    });
    test('Vocab: đúng một cách đọc là exact', () {
      expect(
        checkAnswer(
          method: LearnMethod.reading,
          input: 'inu',
          item: inu,
        ).status,
        AnswerStatus.exact,
      );
    });
  });

  group('Tiến độ', () {
    test('2 lần đúng liên tiếp → mastered, sai → về learning', () {
      var p = const MethodProgress();
      p = p.afterAnswer(isCorrect: true);
      expect(p.status, MasteryStatus.learning);
      expect(p.streak, 1);
      p = p.afterAnswer(isCorrect: true);
      expect(p.status, MasteryStatus.mastered);
      p = p.afterAnswer(isCorrect: false);
      expect(p.status, MasteryStatus.learning);
      expect(p.streak, 0);
      expect(p.wrong, 1);
      expect(isNeedsReview(p), isTrue);
    });

    test('toJson/fromJson khứ hồi', () {
      final item = const ItemProgress(
        itemId: 'a',
        type: ContentType.kanji,
      ).recordAnswer(LearnMethod.hanviet, isCorrect: false, nowMs: 5);
      final back = ItemProgress.fromJson(item.toJson());
      expect(back.methods[LearnMethod.hanviet]!.wrong, 1);
      expect(back.methods[LearnMethod.hanviet]!.lastAnsweredAt, 5);
    });

    test('getMistakes sắp theo số lần sai giảm dần', () {
      final items = {
        'a': ItemProgress(
          itemId: 'a',
          type: ContentType.kanji,
          methods: {
            LearnMethod.hanviet: const MethodProgress(
              wrong: 1,
              status: MasteryStatus.learning,
            ),
          },
        ),
        'b': ItemProgress(
          itemId: 'b',
          type: ContentType.kanji,
          methods: {
            LearnMethod.meaning: const MethodProgress(
              wrong: 3,
              status: MasteryStatus.learning,
            ),
            LearnMethod.reading: const MethodProgress(
              wrong: 5,
              status: MasteryStatus.mastered,
            ),
          },
        ),
      };
      final m = getMistakes(items);
      expect(m.map((e) => e.itemId), [
        'b',
        'a',
      ]); // reading đã mastered nên bị loại
    });
  });

  group('Quiz builder', () {
    test('learning → new → mastered, rồi cắt theo count', () {
      final items = [k('a1'), k('a2'), k('a3'), k('a4')];
      final progress = {
        'a1': ItemProgress(
          itemId: 'a1',
          type: ContentType.kanji,
          methods: {
            LearnMethod.hanviet: const MethodProgress(
              status: MasteryStatus.learning,
            ),
          },
        ),
        'a2': ItemProgress(
          itemId: 'a2',
          type: ContentType.kanji,
          methods: {
            LearnMethod.hanviet: const MethodProgress(
              status: MasteryStatus.mastered,
            ),
          },
        ),
      };
      final all = buildLearnQuiz(
        contentType: ContentType.kanji,
        items: items,
        method: LearnMethod.hanviet,
        count: 4,
        progress: progress,
        rng: Random(1),
      );
      expect(all.first.itemId, 'a1');
      expect(all.last.itemId, 'a2');
      expect({all[1].itemId, all[2].itemId}, {'a3', 'a4'});

      final two = buildLearnQuiz(
        contentType: ContentType.kanji,
        items: items,
        method: LearnMethod.hanviet,
        count: 2,
        progress: progress,
        rng: Random(1),
      );
      expect(two.length, 2);
      expect(two.first.key, 'a1:hanviet');
    });

    test('Review chỉ lấy lỗi sai theo contentType', () {
      final progress = {
        'a': ItemProgress(
          itemId: 'a',
          type: ContentType.kanji,
          methods: {
            LearnMethod.hanviet: const MethodProgress(
              wrong: 2,
              status: MasteryStatus.learning,
            ),
          },
        ),
        'v': ItemProgress(
          itemId: 'v',
          type: ContentType.vocabulary,
          methods: {
            LearnMethod.meaning: const MethodProgress(
              wrong: 1,
              status: MasteryStatus.learning,
            ),
          },
        ),
      };
      final q = buildReviewQuiz(
        progress: progress,
        contentType: ContentType.vocabulary,
        rng: Random(1),
      );
      expect(q.map((e) => e.key), ['v:meaning']);
    });
  });
}
