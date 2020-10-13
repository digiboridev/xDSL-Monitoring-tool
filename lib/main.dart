import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'DslApp.dart';
import 'models/modemClients/Contact.dart';
import 'models/modemClients/LineStatsCollection.dart';

void main() async {
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(LineStatsCollectionAdapter());
  await Hive.initFlutter();

  runApp(DslApp());
}
