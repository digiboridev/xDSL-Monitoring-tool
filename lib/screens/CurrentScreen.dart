import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dslstats/models/DataProvider.dart';

import '../components/SNRM.dart';
import '../components/SpeedLine.dart';
import '../components/FECLine.dart';
import '../components/CRCLine.dart';

import 'CurrentScreen/StatsTable.dart';

class CurrentScreen extends StatelessWidget {
  String _name = 'Current stats';
  get name {
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    print('render current screen');
    return ListView(
      children: [
        StatsTable(),
        // SpeedLineCurrWrapper(),
      ],
    );
  }
}

class SpeedLineCurrWrapper extends StatelessWidget {
  List<LineStatsCollection> getCollection(BuildContext context) {
    return context.watch<DataProvider>().getCollectionByKey(
        context.watch<DataProvider>().getCollectionsKeys.elementAt(0));
  }

  //Check collection for minimum two points in
  //Prevent red screen on mpcharts
  bool isMapEmpty(BuildContext context) {
    if (context.watch<DataProvider>().collectionsCount == 0) {
      return true;
    } else if (getCollection(context).length < 2) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isMapEmpty(context)) {
      return Center(child: Text('No Data'));
    } else {
      return Column(
        children: [
          SpeedLine(
            collection: getCollection(context),
            showPeriod: Duration(minutes: 5),
          ),
          SNRM(
            collection: getCollection(context),
            showPeriod: Duration(minutes: 5),
          ),
          FECLine(
            collection: getCollection(context),
            showPeriod: Duration(minutes: 5),
          ),
          CRCLine(
            collection: getCollection(context),
            showPeriod: Duration(minutes: 5),
          ),
        ],
      );
    }
    // Grand render
  }
}
