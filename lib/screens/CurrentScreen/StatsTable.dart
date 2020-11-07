import 'dart:ui';

import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:provider/provider.dart';
import 'package:dslstats/models/DataProvider.dart';
import 'package:flutter/material.dart';

import 'StatusBar.dart';
import 'CurrentSpeedBar.dart';
import 'CurrentSNRBar.dart';
import 'RsCounters.dart';

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
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
            Colors.cyan[100],
            Colors.cyan[50],
            // Colors.white,
            Colors.white
          ])),
      // color: Colors.blueGrey[300],
      child: Column(
        children: [
          StatusBar(isMapEmpty()),
          CurrentSpeedBar(isMapEmpty()),
          CurrentSNRBar(isMapEmpty()),
          RsCounters()
        ],
      ),
    );
  }
}
