import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:xdslmt/data/drift/stats.dart';
import 'package:xdslmt/data/models/line_stats.dart';

part 'db.g.dart';

@DriftDatabase(tables: [LineStatsTable, SnapshotStatsTable], daos: [StatsDao])
class DB extends _$DB {
  DB({QueryExecutor? e}) : super(e ?? _executor);

  /// Default connection executor
  static get _executor => LazyDatabase(() async {
        final dbDir = await getApplicationDocumentsDirectory();
        final fullPath = path.join(dbDir.path, 'db.sqlite');
        return NativeDatabase.createInBackground(File(fullPath));
      });

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) => migrator.createAll(),
      onUpgrade: (migrator, from, to) async {
        debugPrint('onUpgrade: $from -> $to');
        if (from < 4) {
          await migrator.drop(lineStatsTable);
          await migrator.createTable(lineStatsTable);
        }
      },
    );
  }
}
