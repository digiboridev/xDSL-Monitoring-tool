import 'package:drift/drift.dart';
import 'package:xdsl_mt/data/drift/db.dart';
import 'package:xdsl_mt/data/drift/line_stats.dart';
import 'package:xdsl_mt/data/models/line_stats.dart';

abstract class LineStatsRepository {
  Future<void> insert(LineStats sample);
  Future<LineStats?> getLast();
  Future<List<LineStats>> getAll();
  Future<List<LineStats>> getBySession(String session);
  Future<List<String>> getSessions();
  Future<void> deleteAll();
}

class LineStatsRepositoryDriftImpl implements LineStatsRepository {
  final LineStatsDao _dao;
  LineStatsRepositoryDriftImpl({required LineStatsDao dao}) : _dao = dao;

  @override
  Future<void> insert(LineStats sample) async {
    await _dao.insert(
      LineStatsTableCompanion(
        time: Value(sample.time),
        session: Value(sample.session),
        status: Value(sample.status),
        statusText: Value(sample.statusText),
        connectionType: Value(sample.connectionType),
        upAttainableRate: Value(sample.upAttainableRate),
        downAttainableRate: Value(sample.downAttainableRate),
        upRate: Value(sample.upRate),
        downRate: Value(sample.downRate),
        upMargin: Value(sample.upMargin),
        downMargin: Value(sample.downMargin),
        upAttenuation: Value(sample.upAttenuation),
        downAttenuation: Value(sample.downAttenuation),
        upCRC: Value(sample.upCRC),
        downCRC: Value(sample.downCRC),
        upFEC: Value(sample.upFEC),
        downFEC: Value(sample.downFEC),
      ),
    );
  }

  @override
  Future<LineStats?> getLast() async {
    final model = await _dao.getLast();
    if (model == null) return null;
    return LineStats.fromMap(model.toJson());
  }

  @override
  Future<List<LineStats>> getAll() async {
    final models = await _dao.getAll();
    return models.map((e) => LineStats.fromMap(e.toJson())).toList();
  }

  @override
  Future<List<LineStats>> getBySession(String session) async {
    final models = await _dao.getBySession(session);
    return models.map((e) => LineStats.fromMap(e.toJson())).toList();
  }

  @override
  Future<List<String>> getSessions() {
    return _dao.getSessions();
  }

  @override
  Future<void> deleteAll() async {
    await _dao.deleteAll();
  }
}
