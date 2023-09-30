import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
