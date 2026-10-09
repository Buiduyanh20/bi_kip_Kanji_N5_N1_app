import 'package:drift/drift.dart';

import 'package:bikip_kanji_app/core/database/app_database.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/progress.dart';

class ProgressRepository {
  ProgressRepository(this._db);
  final AppDatabase _db;

  Future<Map<String, ItemProgress>> loadAll() async {
    final rows = await _db.select(_db.progressRows).get();
    return _group(rows);
  }

  /// Ghi đúng một dòng (item, method) sau mỗi câu trả lời.
  Future<void> upsert(ItemProgress item, LearnMethod method) async {
    final mp = item.methods[method];
    if (mp == null) return;
    await _db
        .into(_db.progressRows)
        .insertOnConflictUpdate(_toCompanion(item, method, mp));
  }

  /// Thay toàn bộ (giống `replaceProgress` của web).
  Future<void> replaceAll(Map<String, ItemProgress> items) {
    return _db.transaction(() async {
      await _db.delete(_db.progressRows).go();
      final rows = <ProgressRowsCompanion>[
        for (final item in items.values)
          for (final e in item.methods.entries)
            _toCompanion(item, e.key, e.value),
      ];
      await _db.batch((b) => b.insertAll(
        _db.progressRows,
        rows,
        mode: InsertMode.insertOrReplace,
      ));
    });
  }

  Future<void> clear() => _db.delete(_db.progressRows).go();

  ProgressRowsCompanion _toCompanion(
      ItemProgress item,
      LearnMethod method,
      MethodProgress mp,
      ) =>
      ProgressRowsCompanion.insert(
        itemId: item.itemId,
        method: method.name,
        contentType: item.type.name,
        level: Value(item.level?.code),
        correct: Value(mp.correct),
        wrong: Value(mp.wrong),
        streak: Value(mp.streak),
        status: Value(mp.status.key),
        lastAnsweredAt: Value(mp.lastAnsweredAt),
      );

  Map<String, ItemProgress> _group(List<ProgressRow> rows) {
    final result = <String, ItemProgress>{};
    for (final r in rows) {
      final method = LearnMethod.tryParse(r.method);
      if (method == null) continue;
      final mp = MethodProgress(
        correct: r.correct,
        wrong: r.wrong,
        streak: r.streak,
        status: MasteryStatus.fromKey(r.status),
        lastAnsweredAt: r.lastAnsweredAt,
      );
      final existing = result[r.itemId];
      result[r.itemId] = ItemProgress(
        itemId: r.itemId,
        type: ContentType.tryParse(r.contentType) ?? ContentType.kanji,
        level: JlptLevel.tryParse(r.level),
        methods: {...?existing?.methods, method: mp},
      );
    }
    return result;
  }
}