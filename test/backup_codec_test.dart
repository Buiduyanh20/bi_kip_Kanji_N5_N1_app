import 'package:flutter_test/flutter_test.dart';

import 'package:bikip_kanji_app/core/logic/backup_codec.dart';
import 'package:bikip_kanji_app/data/models/app_settings.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/favorite.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';

/// Đúng định dạng web xuất ra.
const webFile = '''
{
  "version": 1,
  "exportedAt": "2026-10-09T00:00:00.000Z",
  "items": {
    "kanji_n5_001": {
      "itemId": "kanji_n5_001", "type": "kanji", "level": "N5",
      "methods": {
        "hanviet": {"correct": 2, "wrong": 1, "streak": 2, "status": "mastered", "lastAnsweredAt": 1760000000000}
      }
    },
    "vocab_n4_004": {
      "itemId": "vocab_n4_004", "type": "vocabulary", "level": "N4",
      "methods": {
        "meaning": {"correct": 0, "wrong": 3, "streak": 0, "status": "learning", "lastAnsweredAt": 1760000000001},
        "hanviet": {"correct": 1, "wrong": 0, "streak": 1, "status": "learning", "lastAnsweredAt": 1}
      }
    }
  }
}
''';

void main() {
  group('Nhập file từ web', () {
    test('đọc đúng items, không có favorites/settings', () {
      final r = decodeBackup(webFile);
      expect(r.skipped, 0);
      expect(r.data.favorites, isNull);
      expect(r.data.settings, isNull);

      final kanji = r.data.items['kanji_n5_001']!;
      expect(kanji.type, ContentType.kanji);
      expect(kanji.level, JlptLevel.n5);
      final mp = kanji.methods[LearnMethod.hanviet]!;
      expect(mp.status, MasteryStatus.mastered);
      expect(mp.streak, 2);
      expect(mp.lastAnsweredAt, 1760000000000);
    });

    test('Vocab bị loại method hanviet không hợp lệ', () {
      final v = decodeBackup(webFile).data.items['vocab_n4_004']!;
      expect(v.methods.keys, [LearnMethod.meaning]);
    });

    test('bỏ qua id không có trong nội dung', () {
      final r = decodeBackup(
        webFile,
        isKnown: (type, id) => id == 'kanji_n5_001',
      );
      expect(r.data.items.keys, ['kanji_n5_001']);
      expect(r.skipped, 1);
    });

    test('chịu được BOM', () {
      expect(decodeBackup('\uFEFF$webFile').data.items.length, 2);
    });
  });

  group('File sai định dạng', () {
    test('không phải JSON', () {
      expect(() => decodeBackup('xxx'), throwsA(isA<BackupFormatException>()));
    });
    test('items là mảng hoặc thiếu', () {
      expect(
        () => decodeBackup('{"items": []}'),
        throwsA(isA<BackupFormatException>()),
      );
      expect(
        () => decodeBackup('{"version": 1}'),
        throwsA(isA<BackupFormatException>()),
      );
    });
    test('gốc không phải object', () {
      expect(() => decodeBackup('[]'), throwsA(isA<BackupFormatException>()));
    });
    test('version mới hơn bị từ chối', () {
      expect(
        () => decodeBackup('{"version": 2, "items": {}}'),
        throwsA(isA<BackupFormatException>()),
      );
    });
  });

  group('Xuất rồi nhập lại', () {
    test('khứ hồi giữ nguyên items, favorites, settings', () {
      final items = {
        'kanji_n5_001': const ItemProgress(
          itemId: 'kanji_n5_001',
          type: ContentType.kanji,
          level: JlptLevel.n5,
        ).recordAnswer(LearnMethod.hanviet, isCorrect: false, nowMs: 42),
      };
      final text = encodeBackup(
        BackupData(
          items: items,
          favorites: const [
            Favorite(
              kanjiId: 'kanji_n5_001',
              level: JlptLevel.n5,
              createdAt: 7,
            ),
          ],
          settings: const AppSettings(
            userName: 'ANH',
            lastMethod: LearnMethod.reading,
            lastCount: CountChoice.all(),
          ),
          exportedAt: DateTime.utc(2026, 10, 9),
        ),
      );

      final r = decodeBackup(text);
      expect(r.skipped, 0);
      final mp = r.data.items['kanji_n5_001']!.methods[LearnMethod.hanviet]!;
      expect(mp.wrong, 1);
      expect(mp.lastAnsweredAt, 42);
      expect(r.data.favorites!.single.kanjiId, 'kanji_n5_001');
      expect(r.data.settings!.userName, 'ANH');
      expect(r.data.settings!.lastMethod, LearnMethod.reading);
      expect(r.data.settings!.lastCount!.isAll, isTrue);
    });

    test('file xuất vẫn có đúng khóa web cần', () {
      final text = encodeBackup(const BackupData(items: {}));
      expect(text, contains('"version": 1'));
      expect(text, contains('"items": {}'));
    });
  });

  group('AppSettings', () {
    test('tên cắt 30 ký tự và trim', () {
      expect(AppSettings.sanitizeUserName('  ${'a' * 40}  ').length, 30);
    });
    test('lastCount số hoặc "all"', () {
      expect(CountChoice.fromJson(10)!.count, 10);
      expect(CountChoice.fromJson('all')!.isAll, isTrue);
      expect(CountChoice.fromJson('x'), isNull);
    });
  });
}
