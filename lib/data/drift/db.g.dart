// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $LineStatsTableTable extends LineStatsTable
    with TableInfo<$LineStatsTableTable, DriftLineStats> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LineStatsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
      'time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sessionMeta =
      const VerificationMeta('session');
  @override
  late final GeneratedColumn<String> session =
      GeneratedColumn<String>('session', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<SampleStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SampleStatus>($LineStatsTableTable.$converterstatus);
  static const VerificationMeta _statusTextMeta =
      const VerificationMeta('statusText');
  @override
  late final GeneratedColumn<String> statusText = GeneratedColumn<String>(
      'status_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _connectionTypeMeta =
      const VerificationMeta('connectionType');
  @override
  late final GeneratedColumn<String> connectionType = GeneratedColumn<String>(
      'connection_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upAttainableRateMeta =
      const VerificationMeta('upAttainableRate');
  @override
  late final GeneratedColumn<int> upAttainableRate = GeneratedColumn<int>(
      'up_attainable_rate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _downAttainableRateMeta =
      const VerificationMeta('downAttainableRate');
  @override
  late final GeneratedColumn<int> downAttainableRate = GeneratedColumn<int>(
      'down_attainable_rate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _upRateMeta = const VerificationMeta('upRate');
  @override
  late final GeneratedColumn<int> upRate = GeneratedColumn<int>(
      'up_rate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _downRateMeta =
      const VerificationMeta('downRate');
  @override
  late final GeneratedColumn<int> downRate = GeneratedColumn<int>(
      'down_rate', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _upMarginMeta =
      const VerificationMeta('upMargin');
  @override
  late final GeneratedColumn<double> upMargin = GeneratedColumn<double>(
      'up_margin', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _downMarginMeta =
      const VerificationMeta('downMargin');
  @override
  late final GeneratedColumn<double> downMargin = GeneratedColumn<double>(
      'down_margin', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _upAttenuationMeta =
      const VerificationMeta('upAttenuation');
  @override
  late final GeneratedColumn<double> upAttenuation = GeneratedColumn<double>(
      'up_attenuation', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _downAttenuationMeta =
      const VerificationMeta('downAttenuation');
  @override
  late final GeneratedColumn<double> downAttenuation = GeneratedColumn<double>(
      'down_attenuation', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _upCRCMeta = const VerificationMeta('upCRC');
  @override
  late final GeneratedColumn<int> upCRC = GeneratedColumn<int>(
      'up_c_r_c', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _downCRCMeta =
      const VerificationMeta('downCRC');
  @override
  late final GeneratedColumn<int> downCRC = GeneratedColumn<int>(
      'down_c_r_c', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _upFECMeta = const VerificationMeta('upFEC');
  @override
  late final GeneratedColumn<int> upFEC = GeneratedColumn<int>(
      'up_f_e_c', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _downFECMeta =
      const VerificationMeta('downFEC');
  @override
  late final GeneratedColumn<int> downFEC = GeneratedColumn<int>(
      'down_f_e_c', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        time,
        session,
        status,
        statusText,
        connectionType,
        upAttainableRate,
        downAttainableRate,
        upRate,
        downRate,
        upMargin,
        downMargin,
        upAttenuation,
        downAttenuation,
        upCRC,
        downCRC,
        upFEC,
        downFEC
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'line_stats_table';
  @override
  VerificationContext validateIntegrity(Insertable<DriftLineStats> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('session')) {
      context.handle(_sessionMeta,
          session.isAcceptableOrUnknown(data['session']!, _sessionMeta));
    } else if (isInserting) {
      context.missing(_sessionMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('status_text')) {
      context.handle(
          _statusTextMeta,
          statusText.isAcceptableOrUnknown(
              data['status_text']!, _statusTextMeta));
    } else if (isInserting) {
      context.missing(_statusTextMeta);
    }
    if (data.containsKey('connection_type')) {
      context.handle(
          _connectionTypeMeta,
          connectionType.isAcceptableOrUnknown(
              data['connection_type']!, _connectionTypeMeta));
    }
    if (data.containsKey('up_attainable_rate')) {
      context.handle(
          _upAttainableRateMeta,
          upAttainableRate.isAcceptableOrUnknown(
              data['up_attainable_rate']!, _upAttainableRateMeta));
    }
    if (data.containsKey('down_attainable_rate')) {
      context.handle(
          _downAttainableRateMeta,
          downAttainableRate.isAcceptableOrUnknown(
              data['down_attainable_rate']!, _downAttainableRateMeta));
    }
    if (data.containsKey('up_rate')) {
      context.handle(_upRateMeta,
          upRate.isAcceptableOrUnknown(data['up_rate']!, _upRateMeta));
    }
    if (data.containsKey('down_rate')) {
      context.handle(_downRateMeta,
          downRate.isAcceptableOrUnknown(data['down_rate']!, _downRateMeta));
    }
    if (data.containsKey('up_margin')) {
      context.handle(_upMarginMeta,
          upMargin.isAcceptableOrUnknown(data['up_margin']!, _upMarginMeta));
    }
    if (data.containsKey('down_margin')) {
      context.handle(
          _downMarginMeta,
          downMargin.isAcceptableOrUnknown(
              data['down_margin']!, _downMarginMeta));
    }
    if (data.containsKey('up_attenuation')) {
      context.handle(
          _upAttenuationMeta,
          upAttenuation.isAcceptableOrUnknown(
              data['up_attenuation']!, _upAttenuationMeta));
    }
    if (data.containsKey('down_attenuation')) {
      context.handle(
          _downAttenuationMeta,
          downAttenuation.isAcceptableOrUnknown(
              data['down_attenuation']!, _downAttenuationMeta));
    }
    if (data.containsKey('up_c_r_c')) {
      context.handle(_upCRCMeta,
          upCRC.isAcceptableOrUnknown(data['up_c_r_c']!, _upCRCMeta));
    }
    if (data.containsKey('down_c_r_c')) {
      context.handle(_downCRCMeta,
          downCRC.isAcceptableOrUnknown(data['down_c_r_c']!, _downCRCMeta));
    }
    if (data.containsKey('up_f_e_c')) {
      context.handle(_upFECMeta,
          upFEC.isAcceptableOrUnknown(data['up_f_e_c']!, _upFECMeta));
    }
    if (data.containsKey('down_f_e_c')) {
      context.handle(_downFECMeta,
          downFEC.isAcceptableOrUnknown(data['down_f_e_c']!, _downFECMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftLineStats map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftLineStats(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}time'])!,
      session: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session'])!,
      status: $LineStatsTableTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      statusText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status_text'])!,
      connectionType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}connection_type']),
      upAttainableRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}up_attainable_rate']),
      downAttainableRate: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}down_attainable_rate']),
      upRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}up_rate']),
      downRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}down_rate']),
      upMargin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}up_margin']),
      downMargin: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}down_margin']),
      upAttenuation: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}up_attenuation']),
      downAttenuation: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}down_attenuation']),
      upCRC: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}up_c_r_c']),
      downCRC: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}down_c_r_c']),
      upFEC: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}up_f_e_c']),
      downFEC: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}down_f_e_c']),
    );
  }

  @override
  $LineStatsTableTable createAlias(String alias) {
    return $LineStatsTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SampleStatus, String, String> $converterstatus =
      const EnumNameConverter<SampleStatus>(SampleStatus.values);
}

class DriftLineStats extends DataClass implements Insertable<DriftLineStats> {
  final int id;
  final DateTime time;
  final String session;
  final SampleStatus status;
  final String statusText;
  final String? connectionType;
  final int? upAttainableRate;
  final int? downAttainableRate;
  final int? upRate;
  final int? downRate;
  final double? upMargin;
  final double? downMargin;
  final double? upAttenuation;
  final double? downAttenuation;
  final int? upCRC;
  final int? downCRC;
  final int? upFEC;
  final int? downFEC;
  const DriftLineStats(
      {required this.id,
      required this.time,
      required this.session,
      required this.status,
      required this.statusText,
      this.connectionType,
      this.upAttainableRate,
      this.downAttainableRate,
      this.upRate,
      this.downRate,
      this.upMargin,
      this.downMargin,
      this.upAttenuation,
      this.downAttenuation,
      this.upCRC,
      this.downCRC,
      this.upFEC,
      this.downFEC});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<DateTime>(time);
    map['session'] = Variable<String>(session);
    {
      final converter = $LineStatsTableTable.$converterstatus;
      map['status'] = Variable<String>(converter.toSql(status));
    }
    map['status_text'] = Variable<String>(statusText);
    if (!nullToAbsent || connectionType != null) {
      map['connection_type'] = Variable<String>(connectionType);
    }
    if (!nullToAbsent || upAttainableRate != null) {
      map['up_attainable_rate'] = Variable<int>(upAttainableRate);
    }
    if (!nullToAbsent || downAttainableRate != null) {
      map['down_attainable_rate'] = Variable<int>(downAttainableRate);
    }
    if (!nullToAbsent || upRate != null) {
      map['up_rate'] = Variable<int>(upRate);
    }
    if (!nullToAbsent || downRate != null) {
      map['down_rate'] = Variable<int>(downRate);
    }
    if (!nullToAbsent || upMargin != null) {
      map['up_margin'] = Variable<double>(upMargin);
    }
    if (!nullToAbsent || downMargin != null) {
      map['down_margin'] = Variable<double>(downMargin);
    }
    if (!nullToAbsent || upAttenuation != null) {
      map['up_attenuation'] = Variable<double>(upAttenuation);
    }
    if (!nullToAbsent || downAttenuation != null) {
      map['down_attenuation'] = Variable<double>(downAttenuation);
    }
    if (!nullToAbsent || upCRC != null) {
      map['up_c_r_c'] = Variable<int>(upCRC);
    }
    if (!nullToAbsent || downCRC != null) {
      map['down_c_r_c'] = Variable<int>(downCRC);
    }
    if (!nullToAbsent || upFEC != null) {
      map['up_f_e_c'] = Variable<int>(upFEC);
    }
    if (!nullToAbsent || downFEC != null) {
      map['down_f_e_c'] = Variable<int>(downFEC);
    }
    return map;
  }

  LineStatsTableCompanion toCompanion(bool nullToAbsent) {
    return LineStatsTableCompanion(
      id: Value(id),
      time: Value(time),
      session: Value(session),
      status: Value(status),
      statusText: Value(statusText),
      connectionType: connectionType == null && nullToAbsent
          ? const Value.absent()
          : Value(connectionType),
      upAttainableRate: upAttainableRate == null && nullToAbsent
          ? const Value.absent()
          : Value(upAttainableRate),
      downAttainableRate: downAttainableRate == null && nullToAbsent
          ? const Value.absent()
          : Value(downAttainableRate),
      upRate:
          upRate == null && nullToAbsent ? const Value.absent() : Value(upRate),
      downRate: downRate == null && nullToAbsent
          ? const Value.absent()
          : Value(downRate),
      upMargin: upMargin == null && nullToAbsent
          ? const Value.absent()
          : Value(upMargin),
      downMargin: downMargin == null && nullToAbsent
          ? const Value.absent()
          : Value(downMargin),
      upAttenuation: upAttenuation == null && nullToAbsent
          ? const Value.absent()
          : Value(upAttenuation),
      downAttenuation: downAttenuation == null && nullToAbsent
          ? const Value.absent()
          : Value(downAttenuation),
      upCRC:
          upCRC == null && nullToAbsent ? const Value.absent() : Value(upCRC),
      downCRC: downCRC == null && nullToAbsent
          ? const Value.absent()
          : Value(downCRC),
      upFEC:
          upFEC == null && nullToAbsent ? const Value.absent() : Value(upFEC),
      downFEC: downFEC == null && nullToAbsent
          ? const Value.absent()
          : Value(downFEC),
    );
  }

  factory DriftLineStats.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftLineStats(
      id: serializer.fromJson<int>(json['id']),
      time: serializer.fromJson<DateTime>(json['time']),
      session: serializer.fromJson<String>(json['session']),
      status: $LineStatsTableTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      statusText: serializer.fromJson<String>(json['statusText']),
      connectionType: serializer.fromJson<String?>(json['connectionType']),
      upAttainableRate: serializer.fromJson<int?>(json['upAttainableRate']),
      downAttainableRate: serializer.fromJson<int?>(json['downAttainableRate']),
      upRate: serializer.fromJson<int?>(json['upRate']),
      downRate: serializer.fromJson<int?>(json['downRate']),
      upMargin: serializer.fromJson<double?>(json['upMargin']),
      downMargin: serializer.fromJson<double?>(json['downMargin']),
      upAttenuation: serializer.fromJson<double?>(json['upAttenuation']),
      downAttenuation: serializer.fromJson<double?>(json['downAttenuation']),
      upCRC: serializer.fromJson<int?>(json['upCRC']),
      downCRC: serializer.fromJson<int?>(json['downCRC']),
      upFEC: serializer.fromJson<int?>(json['upFEC']),
      downFEC: serializer.fromJson<int?>(json['downFEC']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<DateTime>(time),
      'session': serializer.toJson<String>(session),
      'status': serializer
          .toJson<String>($LineStatsTableTable.$converterstatus.toJson(status)),
      'statusText': serializer.toJson<String>(statusText),
      'connectionType': serializer.toJson<String?>(connectionType),
      'upAttainableRate': serializer.toJson<int?>(upAttainableRate),
      'downAttainableRate': serializer.toJson<int?>(downAttainableRate),
      'upRate': serializer.toJson<int?>(upRate),
      'downRate': serializer.toJson<int?>(downRate),
      'upMargin': serializer.toJson<double?>(upMargin),
      'downMargin': serializer.toJson<double?>(downMargin),
      'upAttenuation': serializer.toJson<double?>(upAttenuation),
      'downAttenuation': serializer.toJson<double?>(downAttenuation),
      'upCRC': serializer.toJson<int?>(upCRC),
      'downCRC': serializer.toJson<int?>(downCRC),
      'upFEC': serializer.toJson<int?>(upFEC),
      'downFEC': serializer.toJson<int?>(downFEC),
    };
  }

  DriftLineStats copyWith(
          {int? id,
          DateTime? time,
          String? session,
          SampleStatus? status,
          String? statusText,
          Value<String?> connectionType = const Value.absent(),
          Value<int?> upAttainableRate = const Value.absent(),
          Value<int?> downAttainableRate = const Value.absent(),
          Value<int?> upRate = const Value.absent(),
          Value<int?> downRate = const Value.absent(),
          Value<double?> upMargin = const Value.absent(),
          Value<double?> downMargin = const Value.absent(),
          Value<double?> upAttenuation = const Value.absent(),
          Value<double?> downAttenuation = const Value.absent(),
          Value<int?> upCRC = const Value.absent(),
          Value<int?> downCRC = const Value.absent(),
          Value<int?> upFEC = const Value.absent(),
          Value<int?> downFEC = const Value.absent()}) =>
      DriftLineStats(
        id: id ?? this.id,
        time: time ?? this.time,
        session: session ?? this.session,
        status: status ?? this.status,
        statusText: statusText ?? this.statusText,
        connectionType:
            connectionType.present ? connectionType.value : this.connectionType,
        upAttainableRate: upAttainableRate.present
            ? upAttainableRate.value
            : this.upAttainableRate,
        downAttainableRate: downAttainableRate.present
            ? downAttainableRate.value
            : this.downAttainableRate,
        upRate: upRate.present ? upRate.value : this.upRate,
        downRate: downRate.present ? downRate.value : this.downRate,
        upMargin: upMargin.present ? upMargin.value : this.upMargin,
        downMargin: downMargin.present ? downMargin.value : this.downMargin,
        upAttenuation:
            upAttenuation.present ? upAttenuation.value : this.upAttenuation,
        downAttenuation: downAttenuation.present
            ? downAttenuation.value
            : this.downAttenuation,
        upCRC: upCRC.present ? upCRC.value : this.upCRC,
        downCRC: downCRC.present ? downCRC.value : this.downCRC,
        upFEC: upFEC.present ? upFEC.value : this.upFEC,
        downFEC: downFEC.present ? downFEC.value : this.downFEC,
      );
  @override
  String toString() {
    return (StringBuffer('DriftLineStats(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('session: $session, ')
          ..write('status: $status, ')
          ..write('statusText: $statusText, ')
          ..write('connectionType: $connectionType, ')
          ..write('upAttainableRate: $upAttainableRate, ')
          ..write('downAttainableRate: $downAttainableRate, ')
          ..write('upRate: $upRate, ')
          ..write('downRate: $downRate, ')
          ..write('upMargin: $upMargin, ')
          ..write('downMargin: $downMargin, ')
          ..write('upAttenuation: $upAttenuation, ')
          ..write('downAttenuation: $downAttenuation, ')
          ..write('upCRC: $upCRC, ')
          ..write('downCRC: $downCRC, ')
          ..write('upFEC: $upFEC, ')
          ..write('downFEC: $downFEC')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      time,
      session,
      status,
      statusText,
      connectionType,
      upAttainableRate,
      downAttainableRate,
      upRate,
      downRate,
      upMargin,
      downMargin,
      upAttenuation,
      downAttenuation,
      upCRC,
      downCRC,
      upFEC,
      downFEC);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftLineStats &&
          other.id == this.id &&
          other.time == this.time &&
          other.session == this.session &&
          other.status == this.status &&
          other.statusText == this.statusText &&
          other.connectionType == this.connectionType &&
          other.upAttainableRate == this.upAttainableRate &&
          other.downAttainableRate == this.downAttainableRate &&
          other.upRate == this.upRate &&
          other.downRate == this.downRate &&
          other.upMargin == this.upMargin &&
          other.downMargin == this.downMargin &&
          other.upAttenuation == this.upAttenuation &&
          other.downAttenuation == this.downAttenuation &&
          other.upCRC == this.upCRC &&
          other.downCRC == this.downCRC &&
          other.upFEC == this.upFEC &&
          other.downFEC == this.downFEC);
}

class LineStatsTableCompanion extends UpdateCompanion<DriftLineStats> {
  final Value<int> id;
  final Value<DateTime> time;
  final Value<String> session;
  final Value<SampleStatus> status;
  final Value<String> statusText;
  final Value<String?> connectionType;
  final Value<int?> upAttainableRate;
  final Value<int?> downAttainableRate;
  final Value<int?> upRate;
  final Value<int?> downRate;
  final Value<double?> upMargin;
  final Value<double?> downMargin;
  final Value<double?> upAttenuation;
  final Value<double?> downAttenuation;
  final Value<int?> upCRC;
  final Value<int?> downCRC;
  final Value<int?> upFEC;
  final Value<int?> downFEC;
  const LineStatsTableCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.session = const Value.absent(),
    this.status = const Value.absent(),
    this.statusText = const Value.absent(),
    this.connectionType = const Value.absent(),
    this.upAttainableRate = const Value.absent(),
    this.downAttainableRate = const Value.absent(),
    this.upRate = const Value.absent(),
    this.downRate = const Value.absent(),
    this.upMargin = const Value.absent(),
    this.downMargin = const Value.absent(),
    this.upAttenuation = const Value.absent(),
    this.downAttenuation = const Value.absent(),
    this.upCRC = const Value.absent(),
    this.downCRC = const Value.absent(),
    this.upFEC = const Value.absent(),
    this.downFEC = const Value.absent(),
  });
  LineStatsTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime time,
    required String session,
    required SampleStatus status,
    required String statusText,
    this.connectionType = const Value.absent(),
    this.upAttainableRate = const Value.absent(),
    this.downAttainableRate = const Value.absent(),
    this.upRate = const Value.absent(),
    this.downRate = const Value.absent(),
    this.upMargin = const Value.absent(),
    this.downMargin = const Value.absent(),
    this.upAttenuation = const Value.absent(),
    this.downAttenuation = const Value.absent(),
    this.upCRC = const Value.absent(),
    this.downCRC = const Value.absent(),
    this.upFEC = const Value.absent(),
    this.downFEC = const Value.absent(),
  })  : time = Value(time),
        session = Value(session),
        status = Value(status),
        statusText = Value(statusText);
  static Insertable<DriftLineStats> custom({
    Expression<int>? id,
    Expression<DateTime>? time,
    Expression<String>? session,
    Expression<String>? status,
    Expression<String>? statusText,
    Expression<String>? connectionType,
    Expression<int>? upAttainableRate,
    Expression<int>? downAttainableRate,
    Expression<int>? upRate,
    Expression<int>? downRate,
    Expression<double>? upMargin,
    Expression<double>? downMargin,
    Expression<double>? upAttenuation,
    Expression<double>? downAttenuation,
    Expression<int>? upCRC,
    Expression<int>? downCRC,
    Expression<int>? upFEC,
    Expression<int>? downFEC,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (session != null) 'session': session,
      if (status != null) 'status': status,
      if (statusText != null) 'status_text': statusText,
      if (connectionType != null) 'connection_type': connectionType,
      if (upAttainableRate != null) 'up_attainable_rate': upAttainableRate,
      if (downAttainableRate != null)
        'down_attainable_rate': downAttainableRate,
      if (upRate != null) 'up_rate': upRate,
      if (downRate != null) 'down_rate': downRate,
      if (upMargin != null) 'up_margin': upMargin,
      if (downMargin != null) 'down_margin': downMargin,
      if (upAttenuation != null) 'up_attenuation': upAttenuation,
      if (downAttenuation != null) 'down_attenuation': downAttenuation,
      if (upCRC != null) 'up_c_r_c': upCRC,
      if (downCRC != null) 'down_c_r_c': downCRC,
      if (upFEC != null) 'up_f_e_c': upFEC,
      if (downFEC != null) 'down_f_e_c': downFEC,
    });
  }

  LineStatsTableCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? time,
      Value<String>? session,
      Value<SampleStatus>? status,
      Value<String>? statusText,
      Value<String?>? connectionType,
      Value<int?>? upAttainableRate,
      Value<int?>? downAttainableRate,
      Value<int?>? upRate,
      Value<int?>? downRate,
      Value<double?>? upMargin,
      Value<double?>? downMargin,
      Value<double?>? upAttenuation,
      Value<double?>? downAttenuation,
      Value<int?>? upCRC,
      Value<int?>? downCRC,
      Value<int?>? upFEC,
      Value<int?>? downFEC}) {
    return LineStatsTableCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      session: session ?? this.session,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
      connectionType: connectionType ?? this.connectionType,
      upAttainableRate: upAttainableRate ?? this.upAttainableRate,
      downAttainableRate: downAttainableRate ?? this.downAttainableRate,
      upRate: upRate ?? this.upRate,
      downRate: downRate ?? this.downRate,
      upMargin: upMargin ?? this.upMargin,
      downMargin: downMargin ?? this.downMargin,
      upAttenuation: upAttenuation ?? this.upAttenuation,
      downAttenuation: downAttenuation ?? this.downAttenuation,
      upCRC: upCRC ?? this.upCRC,
      downCRC: downCRC ?? this.downCRC,
      upFEC: upFEC ?? this.upFEC,
      downFEC: downFEC ?? this.downFEC,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (session.present) {
      map['session'] = Variable<String>(session.value);
    }
    if (status.present) {
      final converter = $LineStatsTableTable.$converterstatus;
      map['status'] = Variable<String>(converter.toSql(status.value));
    }
    if (statusText.present) {
      map['status_text'] = Variable<String>(statusText.value);
    }
    if (connectionType.present) {
      map['connection_type'] = Variable<String>(connectionType.value);
    }
    if (upAttainableRate.present) {
      map['up_attainable_rate'] = Variable<int>(upAttainableRate.value);
    }
    if (downAttainableRate.present) {
      map['down_attainable_rate'] = Variable<int>(downAttainableRate.value);
    }
    if (upRate.present) {
      map['up_rate'] = Variable<int>(upRate.value);
    }
    if (downRate.present) {
      map['down_rate'] = Variable<int>(downRate.value);
    }
    if (upMargin.present) {
      map['up_margin'] = Variable<double>(upMargin.value);
    }
    if (downMargin.present) {
      map['down_margin'] = Variable<double>(downMargin.value);
    }
    if (upAttenuation.present) {
      map['up_attenuation'] = Variable<double>(upAttenuation.value);
    }
    if (downAttenuation.present) {
      map['down_attenuation'] = Variable<double>(downAttenuation.value);
    }
    if (upCRC.present) {
      map['up_c_r_c'] = Variable<int>(upCRC.value);
    }
    if (downCRC.present) {
      map['down_c_r_c'] = Variable<int>(downCRC.value);
    }
    if (upFEC.present) {
      map['up_f_e_c'] = Variable<int>(upFEC.value);
    }
    if (downFEC.present) {
      map['down_f_e_c'] = Variable<int>(downFEC.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LineStatsTableCompanion(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('session: $session, ')
          ..write('status: $status, ')
          ..write('statusText: $statusText, ')
          ..write('connectionType: $connectionType, ')
          ..write('upAttainableRate: $upAttainableRate, ')
          ..write('downAttainableRate: $downAttainableRate, ')
          ..write('upRate: $upRate, ')
          ..write('downRate: $downRate, ')
          ..write('upMargin: $upMargin, ')
          ..write('downMargin: $downMargin, ')
          ..write('upAttenuation: $upAttenuation, ')
          ..write('downAttenuation: $downAttenuation, ')
          ..write('upCRC: $upCRC, ')
          ..write('downCRC: $downCRC, ')
          ..write('upFEC: $upFEC, ')
          ..write('downFEC: $downFEC')
          ..write(')'))
        .toString();
  }
}

abstract class _$DB extends GeneratedDatabase {
  _$DB(QueryExecutor e) : super(e);
  late final $LineStatsTableTable lineStatsTable = $LineStatsTableTable(this);
  late final LineStatsDao lineStatsDao = LineStatsDao(this as DB);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [lineStatsTable];
}
