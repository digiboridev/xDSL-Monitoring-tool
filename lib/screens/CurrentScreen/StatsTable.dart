import 'dart:ui';

import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:provider/provider.dart';
import 'package:dslstats/models/DataProvider.dart';
import 'package:flutter/material.dart';

import 'StatusBar.dart';
import 'CurrentSpeedBar.dart';

class StatsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isMapEmpty() {
      if (context.watch<DataProvider>().collectionsCount == 0) {
        return true;
      } else if (context.watch<DataProvider>().getLastCollection.length < 2) {
        return true;
      } else {
        return false;
      }
    }

    return Container(
      color: Colors.blueGrey[00],
      child: Column(
        children: [StatusBar(isMapEmpty()), CurrentSpeedBar(isMapEmpty())],
      ),
    );
  }
}
