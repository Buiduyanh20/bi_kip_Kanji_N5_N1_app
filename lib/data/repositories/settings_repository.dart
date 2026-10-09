import 'package:bikip_kanji_app/core/database/app_database.dart';
import 'package:bikip_kanji_app/data/models/app_settings.dart';
import 'package:bikip_kanji_app/data/models/enums.dart';

abstract final class _Keys {
  static const userName = 'userName';
  static const lastMethod = 'lastMethod';
  static const lastCount = 'lastCount';
}

class SettingsRepository {
  SettingsRepository(this._db);
  final AppDatabase _db;

  Future<AppSettings> load() async {
    final rows = await _db.select(_db.settingRows).get();
    final map = {for (final r in rows) r.settingKey: r.settingValue};
    return AppSettings(
      userName: map[_Keys.userName] ?? '',
      lastMethod: LearnMethod.tryParse(map[_Keys.lastMethod]),
      lastCount: CountChoice.tryParseStorage(map[_Keys.lastCount]),
    );
  }

  Future<void> _put(String key, String value) => _db
      .into(_db.settingRows)
      .insertOnConflictUpdate(
    SettingRowsCompanion.insert(settingKey: key, settingValue: value),
  );

  Future<void> setUserName(String name) =>
      _put(_Keys.userName, AppSettings.sanitizeUserName(name));

  Future<void> setLastLearningOptions(LearnMethod method, CountChoice count) =>
      _db.transaction(() async {
        await _put(_Keys.lastMethod, method.name);
        await _put(_Keys.lastCount, count.storageValue);
      });

  /// Dùng khi nhập backup: chỉ ghi các trường có giá trị.
  Future<void> applyImported(AppSettings s) async {
    if (s.userName.isNotEmpty) await setUserName(s.userName);
    if (s.lastMethod != null) await _put(_Keys.lastMethod, s.lastMethod!.name);
    if (s.lastCount != null) {
      await _put(_Keys.lastCount, s.lastCount!.storageValue);
    }
  }

  Future<void> clear() => _db.delete(_db.settingRows).go();
}