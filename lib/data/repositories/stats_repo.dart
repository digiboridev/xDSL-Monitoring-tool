import 'package:drift/drift.dart';
import 'package:xdslmt/data/drift/db.dart';
import 'package:xdslmt/data/drift/stats.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';

abstract class StatsRepository {
  Future<void> insertLineStats(LineStats lineStats);
  Future<List<LineStats>> lineStatsBySnapshot(String snapshotId);
  Future<List<String>> snapshotIds();
  Future upsertSnapshotStats(SnapshotStats snapshotStats);
  Future<SnapshotStats> snapshotStatsById(String snapshotId);
}

class StatsRepositoryDriftImpl implements StatsRepository {
  final StatsDao _dao;
  StatsRepositoryDriftImpl({required StatsDao dao}) : _dao = dao;

  @override
  Future<void> insertLineStats(LineStats lineStats) async {
    await _dao.insertLineStats(
      LineStatsTableCompanion(
        time: Value(lineStats.time),
        snapshotId: Value(lineStats.snapshotId),
        status: Value(lineStats.status),
        statusText: Value(lineStats.statusText),
        connectionType: Value(lineStats.connectionType),
        upAttainableRate: Value(lineStats.upAttainableRate),
        downAttainableRate: Value(lineStats.downAttainableRate),
        upRate: Value(lineStats.upRate),
        downRate: Value(lineStats.downRate),
        upMargin: Value(lineStats.upMargin),
        downMargin: Value(lineStats.downMargin),
        upAttenuation: Value(lineStats.upAttenuation),
        downAttenuation: Value(lineStats.downAttenuation),
        upCRC: Value(lineStats.upCRC),
        downCRC: Value(lineStats.downCRC),
        upFEC: Value(lineStats.upFEC),
        downFEC: Value(lineStats.downFEC),
      ),
    );
  }

  @override
  Future<List<LineStats>> lineStatsBySnapshot(String snapshotId) async {
    final models = await _dao.lineStatsBySnapshot(snapshotId);
    return models.map((e) => LineStats.fromMap(e.toJson())).toList();
  }

  @override
  Future<List<String>> snapshotIds() {
    return _dao.snapshotIds();
  }

  @override
  Future upsertSnapshotStats(SnapshotStats snapshotStats) async {
    await _dao.upsertSnapshotStats(DriftSnapshotStats.fromJson(snapshotStats.toMap()));
  }

  @override
  Future<SnapshotStats> snapshotStatsById(String snapshotId) async {
    final model = await _dao.snapshotStatsById(snapshotId);
    return SnapshotStats.fromMap(model.toJson());
  }
}
