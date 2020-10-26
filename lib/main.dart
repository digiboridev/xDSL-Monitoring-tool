import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ScreensWrapper.dart';
import 'models/modemClients/LineStatsCollection.dart';
import 'models/ModemTypes.dart';

void main() async {
  Hive.registerAdapter(LineStatsCollectionAdapter());
  Hive.registerAdapter(ModemTypesAdapter());
  await Hive.initFlutter();

  runApp(ScreensWrapper());
}
