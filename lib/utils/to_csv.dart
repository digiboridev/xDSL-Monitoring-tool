import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

toCSV(String name, List<String> headerRow, List<List<String>> listOfListOfStrings, {bool sharing = false}) async {
  debugPrint('toCSV');
  List<List<String>> headerAndDataList = [];
  headerAndDataList.add(headerRow);

  for (var dataRow in listOfListOfStrings) {
    headerAndDataList.add(dataRow);
  }

  final csv = const ListToCsvConverter().convert(headerAndDataList);
  final bytes = utf8.encode(csv);

  final p = await Permission.storage.request();
  if (p.isGranted) {
    String filename = '/storage/emulated/0/Download/xdslmt_$name.csv';
    final File file = File(filename);
    await file.writeAsBytes(bytes, flush: true);
    debugPrint('csv saved: $filename');
    launchUrl(Uri.parse('content://$filename'));
  } else {
    throw Exception('Permission not granted');
  }
}
