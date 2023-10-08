import 'package:drift/drift.dart';
import 'package:xdslmt/data/drift/db.dart';
import 'package:xdslmt/data/models/line_stats.dart';

part 'stats.g.dart';

@DriftAccessor(tables: [LineStatsTable, SnapshotStatsTable])
class StatsDao extends DatabaseAccessor<DB> with _$StatsDaoMixin {
  StatsDao(DB db) : super(db);

  Future insertLineStats(LineStatsTableCompanion entry) => into(lineStatsTable).insert(entry);

  Future<List<DriftLineStats>> lineStatsBySnapshot(String snapshotId) {
    return (select(lineStatsTable)..where((tbl) => tbl.snapshotId.equals(snapshotId))).get();
  }

  Future<List<String>> snapshotIds() async {
    final r = await customSelect('SELECT DISTINCT snapshot_id FROM line_stats_table ORDER BY time DESC').get();
    return r.map((row) => row.read<String>('snapshot_id')).toList();
  }

  Future upsertSnapshotStats(DriftSnapshotStats entry) {
    return into(snapshotStatsTable).insertOnConflictUpdate(entry);
  }

  Future<DriftSnapshotStats> snapshotStatsById(String snapshotId) {
    return (select(snapshotStatsTable)..where((tbl) => tbl.snapshotId.equals(snapshotId))).getSingle();
  }
}

@DataClassName('DriftLineStats')
class LineStatsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get time => dateTime()();
  TextColumn get snapshotId => text().withLength(min: 1)();
  TextColumn get status => textEnum<SampleStatus>()();
  TextColumn get statusText => text()();
  TextColumn get connectionType => text().nullable()();
  IntColumn get upAttainableRate => integer().nullable()();
  IntColumn get downAttainableRate => integer().nullable()();
  IntColumn get upRate => integer().nullable()();
  IntColumn get downRate => integer().nullable()();
  RealColumn get upMargin => real().nullable()();
  RealColumn get downMargin => real().nullable()();
  RealColumn get upAttenuation => real().nullable()();
  RealColumn get downAttenuation => real().nullable()();
  IntColumn get upCRC => integer().nullable()();
  IntColumn get downCRC => integer().nullable()();
  IntColumn get upFEC => integer().nullable()();
  IntColumn get downFEC => integer().nullable()();
}

@DataClassName('DriftSnapshotStats')
class SnapshotStatsTable extends Table {
  @override
  Set<Column> get primaryKey => {snapshotId};

  TextColumn get snapshotId => text().unique().withLength(min: 1)();
  TextColumn get host => text()();
  TextColumn get login => text()();
  TextColumn get password => text()();
  DateTimeColumn get startTime => dateTime()();
  IntColumn get samples => integer()();
  IntColumn get disconnects => integer()();
  IntColumn get samplingErrors => integer()();
  IntColumn get samplingDuration => integer()();
  IntColumn get uplinkDuration => integer()();
  TextColumn get lastSampleStatus => textEnum<SampleStatus>().nullable()();
  DateTimeColumn get lastSampleTime => dateTime().nullable()();
  IntColumn get downRateLast => integer().nullable()();
  IntColumn get downRateMin => integer().nullable()();
  IntColumn get downRateMax => integer().nullable()();
  IntColumn get downRateAvg => integer().nullable()();
  IntColumn get downAttainableRateLast => integer().nullable()();
  IntColumn get downAttainableRateMin => integer().nullable()();
  IntColumn get downAttainableRateMax => integer().nullable()();
  IntColumn get downAttainableRateAvg => integer().nullable()();
  IntColumn get upRateLast => integer().nullable()();
  IntColumn get upRateMin => integer().nullable()();
  IntColumn get upRateMax => integer().nullable()();
  IntColumn get upRateAvg => integer().nullable()();
  IntColumn get upAttainableRateLast => integer().nullable()();
  IntColumn get upAttainableRateMin => integer().nullable()();
  IntColumn get upAttainableRateMax => integer().nullable()();
  IntColumn get upAttainableRateAvg => integer().nullable()();
  RealColumn get downSNRmLast => real().nullable()();
  RealColumn get downSNRmMin => real().nullable()();
  RealColumn get downSNRmMax => real().nullable()();
  RealColumn get downSNRmAvg => real().nullable()();
  RealColumn get upSNRmLast => real().nullable()();
  RealColumn get upSNRmMin => real().nullable()();
  RealColumn get upSNRmMax => real().nullable()();
  RealColumn get upSNRmAvg => real().nullable()();
  RealColumn get downAttenuationLast => real().nullable()();
  RealColumn get downAttenuationMin => real().nullable()();
  RealColumn get downAttenuationMax => real().nullable()();
  RealColumn get downAttenuationAvg => real().nullable()();
  RealColumn get upAttenuationLast => real().nullable()();
  RealColumn get upAttenuationMin => real().nullable()();
  RealColumn get upAttenuationMax => real().nullable()();
  RealColumn get upAttenuationAvg => real().nullable()();
  IntColumn get downFecLast => integer().nullable()();
  IntColumn get downFecTotal => integer().nullable()();
  IntColumn get upFecLast => integer().nullable()();
  IntColumn get upFecTotal => integer().nullable()();
  IntColumn get downCrcLast => integer().nullable()();
  IntColumn get downCrcTotal => integer().nullable()();
  IntColumn get upCrcLast => integer().nullable()();
  IntColumn get upCrcTotal => integer().nullable()();
}



  // final String snapshotId;
  // final String host;
  // final String login;
  // final String password;
  // final DateTime startTime;
  // final int samples;
  // final int disconnects;
  // final int samplingErrors;
  // final Duration samplingDuration;
  // final Duration uplinkDuration;
  // final SampleStatus? lastSampleStatus;
  // final DateTime? lastSampleTime;
  // final int? downRateLast;
  // final int? downRateMin;
  // final int? downRateMax;
  // final int? downRateAvg;
  // final int? downAttainableRateLast;
  // final int? downAttainableRateMin;
  // final int? downAttainableRateMax;
  // final int? downAttainableRateAvg;
  // final int? upRateLast;
  // final int? upRateMin;
  // final int? upRateMax;
  // final int? upRateAvg;
  // final int? upAttainableRateLast;
  // final int? upAttainableRateMin;
  // final int? upAttainableRateMax;
  // final int? upAttainableRateAvg;
  // final double? downSNRmLast;
  // final double? downSNRmMin;
  // final double? downSNRmMax;
  // final double? downSNRmAvg;
  // final double? upSNRmLast;
  // final double? upSNRmMin;
  // final double? upSNRmMax;
  // final double? upSNRmAvg;
  // final double? downAttenuationLast;
  // final double? downAttenuationMin;
  // final double? downAttenuationMax;
  // final double? downAttenuationAvg;
  // final double? upAttenuationLast;
  // final double? upAttenuationMin;
  // final double? upAttenuationMax;
  // final double? upAttenuationAvg;
  // final int? downFecLast;
  // final int? downFecTotal;
  // final int? upFecLast;
  // final int? upFecTotal;
  // final int? downCrcLast;
  // final int? downCrcTotal;
  // final int? upCrcLast;
  // final int? upCrcTotal;