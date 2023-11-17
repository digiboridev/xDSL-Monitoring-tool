import 'dart:async';
import 'dart:isolate';
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
  Stream<SnapshotStats> snapshotStatsStreamById(String snapshotId);
  Future deleteStats(String snapshotId);
}

class StatsRepositoryDriftImpl implements StatsRepository {
  final StatsDao _dao;
  final _statsBus = StreamController<dynamic>.broadcast();
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
        upCRCIncr: Value(lineStats.upCRCIncr),
        downCRCIncr: Value(lineStats.downCRCIncr),
        upFECIncr: Value(lineStats.upFECIncr),
        downFECIncr: Value(lineStats.downFECIncr),
      ),
    );

    _statsBus.add(lineStats);
  }

  @override
  Future<List<LineStats>> lineStatsBySnapshot(String snapshotId) async {
    final models = await _dao.lineStatsBySnapshot(snapshotId);
    List<LineStats> entities = await Isolate.run(() => models.map((e) => LineStats.fromMap(e.toJson())).toList());
    // TODO metrics
    return entities;
  }

  @override
  Future<List<String>> snapshotIds() {
    return _dao.snapshotIds();
  }

  @override
  Future upsertSnapshotStats(SnapshotStats snapshotStats) async {
    await _dao.upsertSnapshotStats(DriftSnapshotStats.fromJson(snapshotStats.toMap()));
    _statsBus.add(snapshotStats);
  }

  @override
  Future<SnapshotStats> snapshotStatsById(String snapshotId) async {
    final model = await _dao.snapshotStatsById(snapshotId);
    SnapshotStats entity = SnapshotStats.fromMap(model.toJson());
    return entity;
  }

  @override
  Stream<SnapshotStats> snapshotStatsStreamById(String snapshotId) {
    return _statsBus.stream.where((e) => e is SnapshotStats && e.snapshotId == snapshotId).cast();
  }

  @override
  Future deleteStats(String snapshotId) async {
    await _dao.deleteStats(snapshotId);
  }
}
