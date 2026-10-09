import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Mỗi dòng = một (item, method). Làm phẳng từ `items[id].methods[method]` của web.
@DataClassName('ProgressRow')
class ProgressRows extends Table {
  TextColumn get itemId => text()();
  TextColumn get method => text()();
  TextColumn get contentType => text()();
  TextColumn get level => text().nullable()();
  IntColumn get correct => integer().withDefault(const Constant(0))();
  IntColumn get wrong => integer().withDefault(const Constant(0))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('new'))();
  IntColumn get lastAnsweredAt => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {itemId, method};
}

@DataClassName('FavoriteRow')
class FavoriteRows extends Table {
  TextColumn get kanjiId => text()();
  TextColumn get level => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {kanjiId};
}

@DataClassName('SettingRow')
class SettingRows extends Table {
  TextColumn get settingKey => text()();
  TextColumn get settingValue => text()();

  @override
  Set<Column> get primaryKey => {settingKey};
}

@DriftDatabase(tables: [ProgressRows, FavoriteRows, SettingRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // Khi đổi schema: tăng schemaVersion và xử lý ở đây, không xóa DB người dùng.
  );
}

LazyDatabase _openConnection() => LazyDatabase(() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'bikip_kanji.sqlite'));
  return NativeDatabase.createInBackground(file);
});