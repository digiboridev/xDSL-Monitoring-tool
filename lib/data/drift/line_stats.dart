import 'package:drift/drift.dart';
import 'package:xdslmt/data/drift/db.dart';
import 'package:xdslmt/data/models/line_stats.dart';

part 'line_stats.g.dart';

@DriftAccessor(tables: [LineStatsTable])
class LineStatsDao extends DatabaseAccessor<DB> with _$LineStatsDaoMixin {
  LineStatsDao(DB db) : super(db);

  Future<int> insert(LineStatsTableCompanion entry) => into(lineStatsTable).insert(entry);

  Future<DriftLineStats?> getLast() => (select(lineStatsTable)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.time, mode: OrderingMode.desc)])
        ..limit(1))
      .getSingleOrNull();
  Future<List<DriftLineStats>> getAll() => select(lineStatsTable).get();

  Future<List<DriftLineStats>> getBySnapshot(String snapshotId) => (select(lineStatsTable)..where((tbl) => tbl.snapshotId.equals(snapshotId))).get();

  Future<List<String>> getSnapshots() async {
    final r = await customSelect('SELECT DISTINCT snapshot_id FROM line_stats_table ORDER BY time DESC').get();
    return r.map((row) => row.read<String>('snapshot_id')).toList();

    // Same as the above, but using the Drift API
    // final q = selectOnly(lineStatsTable, distinct: true);
    // q.addColumns([lineStatsTable.snapshotId]);
    // q.orderBy([OrderingTerm(expression: lineStatsTable.time, mode: OrderingMode.desc)]);
    // final s = q.map((row) => row.read<String>(lineStatsTable.snapshotId)).map((s) => s!);
    // return await s.get();
  }

  Future<void> deleteAll() => delete(lineStatsTable).go();
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
