import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dslstats/models/DataProvider.dart';

import '../components/SNRM.dart';
import '../components/SpeedLine.dart';
import '../components/FECLine.dart';
import '../components/CRCLine.dart';
import '../components/ModemLatency.dart';
import '../components/ExternalLatency.dart';

import 'CurrentScreen/StatusBar.dart';
import 'CurrentScreen/CurrentSpeedBar.dart';
import 'CurrentScreen/CurrentSNRBar.dart';
import 'CurrentScreen/RsCounters.dart';

class CurrentScreen extends StatelessWidget {
  //Name of screen
  String _name = 'Current stats monitoring';
  //Returns name of screen
  get name {
    return _name;
  }

  bool isMapEmpty = true;

  List<LineStatsCollection> collection;

  @override
  Widget build(BuildContext context) {
    //Check collection for minimum two points in
    //Prevent red screen on mpcharts
    if (context.watch<DataProvider>().collectionsCount == 0) {
      isMapEmpty = true;
    } else if (context.watch<DataProvider>().getLastCollection.length < 2) {
      isMapEmpty = true;
    } else {
      isMapEmpty = false;
    }
    //Update collection
    if (!isMapEmpty) {
      collection = context.watch<DataProvider>().getLastCollection;
    }

    print('render current screen');

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [Colors.cyan[50], Colors.white, Colors.white])),
      child: ListView(
        children: [
          StatusBar(isMapEmpty),
          CurrentSpeedBar(isMapEmpty),
          CurrentSNRBar(isMapEmpty),
          RsCounters(isMapEmpty),
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(16),
                child: Text('Graph stats per time',
                    style: TextStyle(
                        color: Colors.blueGrey[900],
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
              SpeedLineExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              SNRMExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              FECLineExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              CRCLineExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              ModemLatencyExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
              ExternalLatencyExpandable(
                isEmpty: isMapEmpty,
                collection: collection,
                showPeriod: Duration(minutes: 5),
              ),
            ],
          )
        ],
      ),
    );
  }
}
