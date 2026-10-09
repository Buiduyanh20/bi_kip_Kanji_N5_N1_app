// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProgressRowsTable extends ProgressRows
    with TableInfo<$ProgressRowsTable, ProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
      'item_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentTypeMeta =
      const VerificationMeta('contentType');
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
      'content_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _correctMeta =
      const VerificationMeta('correct');
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
      'correct', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wrongMeta = const VerificationMeta('wrong');
  @override
  late final GeneratedColumn<int> wrong = GeneratedColumn<int>(
      'wrong', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('new'));
  static const VerificationMeta _lastAnsweredAtMeta =
      const VerificationMeta('lastAnsweredAt');
  @override
  late final GeneratedColumn<int> lastAnsweredAt = GeneratedColumn<int>(
      'last_answered_at', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        itemId,
        method,
        contentType,
        level,
        correct,
        wrong,
        streak,
        status,
        lastAnsweredAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_rows';
  @override
  VerificationContext validateIntegrity(Insertable<ProgressRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta,
          itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
          _contentTypeMeta,
          contentType.isAcceptableOrUnknown(
              data['content_type']!, _contentTypeMeta));
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    if (data.containsKey('correct')) {
      context.handle(_correctMeta,
          correct.isAcceptableOrUnknown(data['correct']!, _correctMeta));
    }
    if (data.containsKey('wrong')) {
      context.handle(
          _wrongMeta, wrong.isAcceptableOrUnknown(data['wrong']!, _wrongMeta));
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('last_answered_at')) {
      context.handle(
          _lastAnsweredAtMeta,
          lastAnsweredAt.isAcceptableOrUnknown(
              data['last_answered_at']!, _lastAnsweredAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, method};
  @override
  ProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressRow(
      itemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      contentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_type'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level']),
      correct: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}correct'])!,
      wrong: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wrong'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      lastAnsweredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_answered_at'])!,
    );
  }

  @override
  $ProgressRowsTable createAlias(String alias) {
    return $ProgressRowsTable(attachedDatabase, alias);
  }
}

class ProgressRow extends DataClass implements Insertable<ProgressRow> {
  final String itemId;
  final String method;
  final String contentType;
  final String? level;
  final int correct;
  final int wrong;
  final int streak;
  final String status;
  final int lastAnsweredAt;
  const ProgressRow(
      {required this.itemId,
      required this.method,
      required this.contentType,
      this.level,
      required this.correct,
      required this.wrong,
      required this.streak,
      required this.status,
      required this.lastAnsweredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['method'] = Variable<String>(method);
    map['content_type'] = Variable<String>(contentType);
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<String>(level);
    }
    map['correct'] = Variable<int>(correct);
    map['wrong'] = Variable<int>(wrong);
    map['streak'] = Variable<int>(streak);
    map['status'] = Variable<String>(status);
    map['last_answered_at'] = Variable<int>(lastAnsweredAt);
    return map;
  }

  ProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return ProgressRowsCompanion(
      itemId: Value(itemId),
      method: Value(method),
      contentType: Value(contentType),
      level:
          level == null && nullToAbsent ? const Value.absent() : Value(level),
      correct: Value(correct),
      wrong: Value(wrong),
      streak: Value(streak),
      status: Value(status),
      lastAnsweredAt: Value(lastAnsweredAt),
    );
  }

  factory ProgressRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressRow(
      itemId: serializer.fromJson<String>(json['itemId']),
      method: serializer.fromJson<String>(json['method']),
      contentType: serializer.fromJson<String>(json['contentType']),
      level: serializer.fromJson<String?>(json['level']),
      correct: serializer.fromJson<int>(json['correct']),
      wrong: serializer.fromJson<int>(json['wrong']),
      streak: serializer.fromJson<int>(json['streak']),
      status: serializer.fromJson<String>(json['status']),
      lastAnsweredAt: serializer.fromJson<int>(json['lastAnsweredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'method': serializer.toJson<String>(method),
      'contentType': serializer.toJson<String>(contentType),
      'level': serializer.toJson<String?>(level),
      'correct': serializer.toJson<int>(correct),
      'wrong': serializer.toJson<int>(wrong),
      'streak': serializer.toJson<int>(streak),
      'status': serializer.toJson<String>(status),
      'lastAnsweredAt': serializer.toJson<int>(lastAnsweredAt),
    };
  }

  ProgressRow copyWith(
          {String? itemId,
          String? method,
          String? contentType,
          Value<String?> level = const Value.absent(),
          int? correct,
          int? wrong,
          int? streak,
          String? status,
          int? lastAnsweredAt}) =>
      ProgressRow(
        itemId: itemId ?? this.itemId,
        method: method ?? this.method,
        contentType: contentType ?? this.contentType,
        level: level.present ? level.value : this.level,
        correct: correct ?? this.correct,
        wrong: wrong ?? this.wrong,
        streak: streak ?? this.streak,
        status: status ?? this.status,
        lastAnsweredAt: lastAnsweredAt ?? this.lastAnsweredAt,
      );
  ProgressRow copyWithCompanion(ProgressRowsCompanion data) {
    return ProgressRow(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      method: data.method.present ? data.method.value : this.method,
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      level: data.level.present ? data.level.value : this.level,
      correct: data.correct.present ? data.correct.value : this.correct,
      wrong: data.wrong.present ? data.wrong.value : this.wrong,
      streak: data.streak.present ? data.streak.value : this.streak,
      status: data.status.present ? data.status.value : this.status,
      lastAnsweredAt: data.lastAnsweredAt.present
          ? data.lastAnsweredAt.value
          : this.lastAnsweredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressRow(')
          ..write('itemId: $itemId, ')
          ..write('method: $method, ')
          ..write('contentType: $contentType, ')
          ..write('level: $level, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('streak: $streak, ')
          ..write('status: $status, ')
          ..write('lastAnsweredAt: $lastAnsweredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, method, contentType, level, correct,
      wrong, streak, status, lastAnsweredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressRow &&
          other.itemId == this.itemId &&
          other.method == this.method &&
          other.contentType == this.contentType &&
          other.level == this.level &&
          other.correct == this.correct &&
          other.wrong == this.wrong &&
          other.streak == this.streak &&
          other.status == this.status &&
          other.lastAnsweredAt == this.lastAnsweredAt);
}

class ProgressRowsCompanion extends UpdateCompanion<ProgressRow> {
  final Value<String> itemId;
  final Value<String> method;
  final Value<String> contentType;
  final Value<String?> level;
  final Value<int> correct;
  final Value<int> wrong;
  final Value<int> streak;
  final Value<String> status;
  final Value<int> lastAnsweredAt;
  final Value<int> rowid;
  const ProgressRowsCompanion({
    this.itemId = const Value.absent(),
    this.method = const Value.absent(),
    this.contentType = const Value.absent(),
    this.level = const Value.absent(),
    this.correct = const Value.absent(),
    this.wrong = const Value.absent(),
    this.streak = const Value.absent(),
    this.status = const Value.absent(),
    this.lastAnsweredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressRowsCompanion.insert({
    required String itemId,
    required String method,
    required String contentType,
    this.level = const Value.absent(),
    this.correct = const Value.absent(),
    this.wrong = const Value.absent(),
    this.streak = const Value.absent(),
    this.status = const Value.absent(),
    this.lastAnsweredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : itemId = Value(itemId),
        method = Value(method),
        contentType = Value(contentType);
  static Insertable<ProgressRow> custom({
    Expression<String>? itemId,
    Expression<String>? method,
    Expression<String>? contentType,
    Expression<String>? level,
    Expression<int>? correct,
    Expression<int>? wrong,
    Expression<int>? streak,
    Expression<String>? status,
    Expression<int>? lastAnsweredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (method != null) 'method': method,
      if (contentType != null) 'content_type': contentType,
      if (level != null) 'level': level,
      if (correct != null) 'correct': correct,
      if (wrong != null) 'wrong': wrong,
      if (streak != null) 'streak': streak,
      if (status != null) 'status': status,
      if (lastAnsweredAt != null) 'last_answered_at': lastAnsweredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressRowsCompanion copyWith(
      {Value<String>? itemId,
      Value<String>? method,
      Value<String>? contentType,
      Value<String?>? level,
      Value<int>? correct,
      Value<int>? wrong,
      Value<int>? streak,
      Value<String>? status,
      Value<int>? lastAnsweredAt,
      Value<int>? rowid}) {
    return ProgressRowsCompanion(
      itemId: itemId ?? this.itemId,
      method: method ?? this.method,
      contentType: contentType ?? this.contentType,
      level: level ?? this.level,
      correct: correct ?? this.correct,
      wrong: wrong ?? this.wrong,
      streak: streak ?? this.streak,
      status: status ?? this.status,
      lastAnsweredAt: lastAnsweredAt ?? this.lastAnsweredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (wrong.present) {
      map['wrong'] = Variable<int>(wrong.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lastAnsweredAt.present) {
      map['last_answered_at'] = Variable<int>(lastAnsweredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressRowsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('method: $method, ')
          ..write('contentType: $contentType, ')
          ..write('level: $level, ')
          ..write('correct: $correct, ')
          ..write('wrong: $wrong, ')
          ..write('streak: $streak, ')
          ..write('status: $status, ')
          ..write('lastAnsweredAt: $lastAnsweredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoriteRowsTable extends FavoriteRows
    with TableInfo<$FavoriteRowsTable, FavoriteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kanjiIdMeta =
      const VerificationMeta('kanjiId');
  @override
  late final GeneratedColumn<String> kanjiId = GeneratedColumn<String>(
      'kanji_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
      'level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [kanjiId, level, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_rows';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kanji_id')) {
      context.handle(_kanjiIdMeta,
          kanjiId.isAcceptableOrUnknown(data['kanji_id']!, _kanjiIdMeta));
    } else if (isInserting) {
      context.missing(_kanjiIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kanjiId};
  @override
  FavoriteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteRow(
      kanjiId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kanji_id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}level'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FavoriteRowsTable createAlias(String alias) {
    return $FavoriteRowsTable(attachedDatabase, alias);
  }
}

class FavoriteRow extends DataClass implements Insertable<FavoriteRow> {
  final String kanjiId;
  final String level;
  final int createdAt;
  const FavoriteRow(
      {required this.kanjiId, required this.level, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kanji_id'] = Variable<String>(kanjiId);
    map['level'] = Variable<String>(level);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  FavoriteRowsCompanion toCompanion(bool nullToAbsent) {
    return FavoriteRowsCompanion(
      kanjiId: Value(kanjiId),
      level: Value(level),
      createdAt: Value(createdAt),
    );
  }

  factory FavoriteRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteRow(
      kanjiId: serializer.fromJson<String>(json['kanjiId']),
      level: serializer.fromJson<String>(json['level']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kanjiId': serializer.toJson<String>(kanjiId),
      'level': serializer.toJson<String>(level),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  FavoriteRow copyWith({String? kanjiId, String? level, int? createdAt}) =>
      FavoriteRow(
        kanjiId: kanjiId ?? this.kanjiId,
        level: level ?? this.level,
        createdAt: createdAt ?? this.createdAt,
      );
  FavoriteRow copyWithCompanion(FavoriteRowsCompanion data) {
    return FavoriteRow(
      kanjiId: data.kanjiId.present ? data.kanjiId.value : this.kanjiId,
      level: data.level.present ? data.level.value : this.level,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRow(')
          ..write('kanjiId: $kanjiId, ')
          ..write('level: $level, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kanjiId, level, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteRow &&
          other.kanjiId == this.kanjiId &&
          other.level == this.level &&
          other.createdAt == this.createdAt);
}

class FavoriteRowsCompanion extends UpdateCompanion<FavoriteRow> {
  final Value<String> kanjiId;
  final Value<String> level;
  final Value<int> createdAt;
  final Value<int> rowid;
  const FavoriteRowsCompanion({
    this.kanjiId = const Value.absent(),
    this.level = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteRowsCompanion.insert({
    required String kanjiId,
    required String level,
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : kanjiId = Value(kanjiId),
        level = Value(level),
        createdAt = Value(createdAt);
  static Insertable<FavoriteRow> custom({
    Expression<String>? kanjiId,
    Expression<String>? level,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kanjiId != null) 'kanji_id': kanjiId,
      if (level != null) 'level': level,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteRowsCompanion copyWith(
      {Value<String>? kanjiId,
      Value<String>? level,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return FavoriteRowsCompanion(
      kanjiId: kanjiId ?? this.kanjiId,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kanjiId.present) {
      map['kanji_id'] = Variable<String>(kanjiId.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteRowsCompanion(')
          ..write('kanjiId: $kanjiId, ')
          ..write('level: $level, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingRowsTable extends SettingRows
    with TableInfo<$SettingRowsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta =
      const VerificationMeta('settingKey');
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
      'setting_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _settingValueMeta =
      const VerificationMeta('settingValue');
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
      'setting_value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setting_rows';
  @override
  VerificationContext validateIntegrity(Insertable<SettingRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
          _settingKeyMeta,
          settingKey.isAcceptableOrUnknown(
              data['setting_key']!, _settingKeyMeta));
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
          _settingValueMeta,
          settingValue.isAcceptableOrUnknown(
              data['setting_value']!, _settingValueMeta));
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      settingKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}setting_key'])!,
      settingValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}setting_value'])!,
    );
  }

  @override
  $SettingRowsTable createAlias(String alias) {
    return $SettingRowsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String settingKey;
  final String settingValue;
  const SettingRow({required this.settingKey, required this.settingValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    return map;
  }

  SettingRowsCompanion toCompanion(bool nullToAbsent) {
    return SettingRowsCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
    );
  }

  factory SettingRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
    };
  }

  SettingRow copyWith({String? settingKey, String? settingValue}) => SettingRow(
        settingKey: settingKey ?? this.settingKey,
        settingValue: settingValue ?? this.settingValue,
      );
  SettingRow copyWithCompanion(SettingRowsCompanion data) {
    return SettingRow(
      settingKey:
          data.settingKey.present ? data.settingKey.value : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class SettingRowsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> rowid;
  const SettingRowsCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingRowsCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.rowid = const Value.absent(),
  })  : settingKey = Value(settingKey),
        settingValue = Value(settingValue);
  static Insertable<SettingRow> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingRowsCompanion copyWith(
      {Value<String>? settingKey,
      Value<String>? settingValue,
      Value<int>? rowid}) {
    return SettingRowsCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingRowsCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProgressRowsTable progressRows = $ProgressRowsTable(this);
  late final $FavoriteRowsTable favoriteRows = $FavoriteRowsTable(this);
  late final $SettingRowsTable settingRows = $SettingRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [progressRows, favoriteRows, settingRows];
}

typedef $$ProgressRowsTableCreateCompanionBuilder = ProgressRowsCompanion
    Function({
  required String itemId,
  required String method,
  required String contentType,
  Value<String?> level,
  Value<int> correct,
  Value<int> wrong,
  Value<int> streak,
  Value<String> status,
  Value<int> lastAnsweredAt,
  Value<int> rowid,
});
typedef $$ProgressRowsTableUpdateCompanionBuilder = ProgressRowsCompanion
    Function({
  Value<String> itemId,
  Value<String> method,
  Value<String> contentType,
  Value<String?> level,
  Value<int> correct,
  Value<int> wrong,
  Value<int> streak,
  Value<String> status,
  Value<int> lastAnsweredAt,
  Value<int> rowid,
});

class $$ProgressRowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgressRowsTable,
    ProgressRow,
    $$ProgressRowsTableFilterComposer,
    $$ProgressRowsTableOrderingComposer,
    $$ProgressRowsTableCreateCompanionBuilder,
    $$ProgressRowsTableUpdateCompanionBuilder> {
  $$ProgressRowsTableTableManager(_$AppDatabase db, $ProgressRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProgressRowsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProgressRowsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> itemId = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String> contentType = const Value.absent(),
            Value<String?> level = const Value.absent(),
            Value<int> correct = const Value.absent(),
            Value<int> wrong = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> lastAnsweredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressRowsCompanion(
            itemId: itemId,
            method: method,
            contentType: contentType,
            level: level,
            correct: correct,
            wrong: wrong,
            streak: streak,
            status: status,
            lastAnsweredAt: lastAnsweredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String itemId,
            required String method,
            required String contentType,
            Value<String?> level = const Value.absent(),
            Value<int> correct = const Value.absent(),
            Value<int> wrong = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> lastAnsweredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressRowsCompanion.insert(
            itemId: itemId,
            method: method,
            contentType: contentType,
            level: level,
            correct: correct,
            wrong: wrong,
            streak: streak,
            status: status,
            lastAnsweredAt: lastAnsweredAt,
            rowid: rowid,
          ),
        ));
}

class $$ProgressRowsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProgressRowsTable> {
  $$ProgressRowsTableFilterComposer(super.$state);
  ColumnFilters<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get method => $state.composableBuilder(
      column: $state.table.method,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get contentType => $state.composableBuilder(
      column: $state.table.contentType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get level => $state.composableBuilder(
      column: $state.table.level,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get correct => $state.composableBuilder(
      column: $state.table.correct,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get wrong => $state.composableBuilder(
      column: $state.table.wrong,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get streak => $state.composableBuilder(
      column: $state.table.streak,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lastAnsweredAt => $state.composableBuilder(
      column: $state.table.lastAnsweredAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ProgressRowsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProgressRowsTable> {
  $$ProgressRowsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get itemId => $state.composableBuilder(
      column: $state.table.itemId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get method => $state.composableBuilder(
      column: $state.table.method,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get contentType => $state.composableBuilder(
      column: $state.table.contentType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get level => $state.composableBuilder(
      column: $state.table.level,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get correct => $state.composableBuilder(
      column: $state.table.correct,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get wrong => $state.composableBuilder(
      column: $state.table.wrong,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get streak => $state.composableBuilder(
      column: $state.table.streak,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lastAnsweredAt => $state.composableBuilder(
      column: $state.table.lastAnsweredAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$FavoriteRowsTableCreateCompanionBuilder = FavoriteRowsCompanion
    Function({
  required String kanjiId,
  required String level,
  required int createdAt,
  Value<int> rowid,
});
typedef $$FavoriteRowsTableUpdateCompanionBuilder = FavoriteRowsCompanion
    Function({
  Value<String> kanjiId,
  Value<String> level,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$FavoriteRowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoriteRowsTable,
    FavoriteRow,
    $$FavoriteRowsTableFilterComposer,
    $$FavoriteRowsTableOrderingComposer,
    $$FavoriteRowsTableCreateCompanionBuilder,
    $$FavoriteRowsTableUpdateCompanionBuilder> {
  $$FavoriteRowsTableTableManager(_$AppDatabase db, $FavoriteRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FavoriteRowsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FavoriteRowsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> kanjiId = const Value.absent(),
            Value<String> level = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoriteRowsCompanion(
            kanjiId: kanjiId,
            level: level,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String kanjiId,
            required String level,
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoriteRowsCompanion.insert(
            kanjiId: kanjiId,
            level: level,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$FavoriteRowsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FavoriteRowsTable> {
  $$FavoriteRowsTableFilterComposer(super.$state);
  ColumnFilters<String> get kanjiId => $state.composableBuilder(
      column: $state.table.kanjiId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get level => $state.composableBuilder(
      column: $state.table.level,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$FavoriteRowsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FavoriteRowsTable> {
  $$FavoriteRowsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get kanjiId => $state.composableBuilder(
      column: $state.table.kanjiId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get level => $state.composableBuilder(
      column: $state.table.level,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SettingRowsTableCreateCompanionBuilder = SettingRowsCompanion
    Function({
  required String settingKey,
  required String settingValue,
  Value<int> rowid,
});
typedef $$SettingRowsTableUpdateCompanionBuilder = SettingRowsCompanion
    Function({
  Value<String> settingKey,
  Value<String> settingValue,
  Value<int> rowid,
});

class $$SettingRowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingRowsTable,
    SettingRow,
    $$SettingRowsTableFilterComposer,
    $$SettingRowsTableOrderingComposer,
    $$SettingRowsTableCreateCompanionBuilder,
    $$SettingRowsTableUpdateCompanionBuilder> {
  $$SettingRowsTableTableManager(_$AppDatabase db, $SettingRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SettingRowsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SettingRowsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> settingKey = const Value.absent(),
            Value<String> settingValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingRowsCompanion(
            settingKey: settingKey,
            settingValue: settingValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String settingKey,
            required String settingValue,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingRowsCompanion.insert(
            settingKey: settingKey,
            settingValue: settingValue,
            rowid: rowid,
          ),
        ));
}

class $$SettingRowsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableFilterComposer(super.$state);
  ColumnFilters<String> get settingKey => $state.composableBuilder(
      column: $state.table.settingKey,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get settingValue => $state.composableBuilder(
      column: $state.table.settingValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SettingRowsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SettingRowsTable> {
  $$SettingRowsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get settingKey => $state.composableBuilder(
      column: $state.table.settingKey,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get settingValue => $state.composableBuilder(
      column: $state.table.settingValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProgressRowsTableTableManager get progressRows =>
      $$ProgressRowsTableTableManager(_db, _db.progressRows);
  $$FavoriteRowsTableTableManager get favoriteRows =>
      $$FavoriteRowsTableTableManager(_db, _db.favoriteRows);
  $$SettingRowsTableTableManager get settingRows =>
      $$SettingRowsTableTableManager(_db, _db.settingRows);
}
