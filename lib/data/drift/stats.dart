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

  Future deleteStats(String snapshotId) async {
    await (delete(snapshotStatsTable)..where((tbl) => tbl.snapshotId.equals(snapshotId))).go();
    await (delete(lineStatsTable)..where((tbl) => tbl.snapshotId.equals(snapshotId))).go();
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
  IntColumn get upMargin => integer().nullable()();
  IntColumn get downMargin => integer().nullable()();
  IntColumn get upAttenuation => integer().nullable()();
  IntColumn get downAttenuation => integer().nullable()();
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
  IntColumn get downSNRmLast => integer().nullable()();
  IntColumn get downSNRmMin => integer().nullable()();
  IntColumn get downSNRmMax => integer().nullable()();
  IntColumn get downSNRmAvg => integer().nullable()();
  IntColumn get upSNRmLast => integer().nullable()();
  IntColumn get upSNRmMin => integer().nullable()();
  IntColumn get upSNRmMax => integer().nullable()();
  IntColumn get upSNRmAvg => integer().nullable()();
  IntColumn get downAttenuationLast => integer().nullable()();
  IntColumn get downAttenuationMin => integer().nullable()();
  IntColumn get downAttenuationMax => integer().nullable()();
  IntColumn get downAttenuationAvg => integer().nullable()();
  IntColumn get upAttenuationLast => integer().nullable()();
  IntColumn get upAttenuationMin => integer().nullable()();
  IntColumn get upAttenuationMax => integer().nullable()();
  IntColumn get upAttenuationAvg => integer().nullable()();
  IntColumn get downFecLast => integer().nullable()();
  IntColumn get downFecTotal => integer().nullable()();
  IntColumn get upFecLast => integer().nullable()();
  IntColumn get upFecTotal => integer().nullable()();
  IntColumn get downCrcLast => integer().nullable()();
  IntColumn get downCrcTotal => integer().nullable()();
  IntColumn get upCrcLast => integer().nullable()();
  IntColumn get upCrcTotal => integer().nullable()();
}
