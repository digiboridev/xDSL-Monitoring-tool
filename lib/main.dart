import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xdsl_mt/data/drift/db.dart';
import 'package:xdsl_mt/data/drift/line_stats.dart';
import 'package:xdsl_mt/data/repository/line_stats_repo.dart';
// import 'package:xDSL_Monitoring_tool/models/misc/ModemTypes.dart';
import 'screens_wrapper.dart';
// import 'models/modemClients/LineStatsCollection.dart';

void main() async {
  // Hive.registerAdapter(LineStatsCollectionAdapter());
  // Hive.registerAdapter(ModemTypesAdapter());

  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('collectionMap');

  runApp(const ScreensWrapper());
}

final class SL {
  SL._();
  static final SL _instance = SL._();
  factory SL() => _instance;

  late final _drift = DB();
  late final LineStatsRepository lineStatsRepository = LineStatsRepositoryDriftImpl(dao: LineStatsDao(_drift));
}
