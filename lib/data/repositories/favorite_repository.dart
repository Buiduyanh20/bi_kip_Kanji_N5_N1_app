import 'package:drift/drift.dart';

import 'package:bikip_kanji_app/core/database/app_database.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';
import 'package:bikip_kanji_app/data/models/favorite.dart';

class FavoriteRepository {
  FavoriteRepository(this._db);
  final AppDatabase _db;

  Favorite? _fromRow(FavoriteRow r) {
    final level = JlptLevel.tryParse(r.level);
    if (level == null) return null;
    return Favorite(kanjiId: r.kanjiId, level: level, createdAt: r.createdAt);
  }

  SimpleSelectStatement<$FavoriteRowsTable, FavoriteRow> _selectNewestFirst() =>
      _db.select(_db.favoriteRows)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

  Future<List<Favorite>> getAll() async {
    final rows = await _selectNewestFirst().get();
    return rows.map(_fromRow).whereType<Favorite>().toList();
  }

  Stream<List<Favorite>> watchAll() => _selectNewestFirst().watch().map(
    (rows) => rows.map(_fromRow).whereType<Favorite>().toList(),
  );

  /// Trả về true nếu sau thao tác Kanji đang ở trạng thái yêu thích.
  Future<bool> toggle(String kanjiId, JlptLevel level) {
    return _db.transaction(() async {
      final existing = await (_db.select(
        _db.favoriteRows,
      )..where((t) => t.kanjiId.equals(kanjiId))).getSingleOrNull();
      if (existing != null) {
        await (_db.delete(
          _db.favoriteRows,
        )..where((t) => t.kanjiId.equals(kanjiId))).go();
        return false;
      }
      await _db
          .into(_db.favoriteRows)
          .insert(
            FavoriteRowsCompanion.insert(
              kanjiId: kanjiId,
              level: level.code,
              createdAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );
      return true;
    });
  }

  Future<void> remove(String kanjiId) => (_db.delete(
    _db.favoriteRows,
  )..where((t) => t.kanjiId.equals(kanjiId))).go();

  Future<void> replaceAll(List<Favorite> favorites) {
    return _db.transaction(() async {
      await _db.delete(_db.favoriteRows).go();
      await _db.batch(
        (b) => b.insertAll(_db.favoriteRows, [
          for (final f in favorites)
            FavoriteRowsCompanion.insert(
              kanjiId: f.kanjiId,
              level: f.level.code,
              createdAt: f.createdAt,
            ),
        ], mode: InsertMode.insertOrReplace),
      );
    });
  }

  Future<void> clear() => _db.delete(_db.favoriteRows).go();
}
