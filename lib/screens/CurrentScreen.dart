import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dslstats/models/DataProvider.dart';

import '../components/SNRM.dart';
import '../components/SpeedLine.dart';
import '../components/FECLine.dart';
import '../components/CRCLine.dart';

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
        Container(
          height: 300,
          child: Center(
            child: Text('SOMESHIT'),
          ),
        ),
        SpeedLineCurrWrapper()
      ],
    );
  }
}

class SpeedLineCurrWrapper extends StatefulWidget {
  SpeedLineCurrWrapper({Key key}) : super(key: key);

  @override
  _SpeedLineCurrWrapperState createState() => _SpeedLineCurrWrapperState();
}

class _SpeedLineCurrWrapperState extends State<SpeedLineCurrWrapper> {
  int asd = 0;

  List<LineStatsCollection> getCollection(BuildContext context) {
    return context.watch<DataProvider>().getCollectionByKey(
        context.watch<DataProvider>().getCollectionsKeys.elementAt(0));
  }

  @override
  Widget build(BuildContext context) {
    //Check collection for minimum two points in
    //Prevent red screen on mpcharts
    bool isMapEmpty() {
      if (context.watch<DataProvider>().collectionsCount == 0) {
        return true;
      } else if (getCollection(context).length < 2) {
        return true;
      } else {
        return false;
      }
    }

    // Grand render
    return Column(
      children: [
        Container(
          height: 200,
          child: isMapEmpty()
              ? Center(child: Text('No Data'))
              : SpeedLine(
                  collection: getCollection(context),
                  showPeriod: Duration(minutes: 5),
                ),
        ),
        Container(
          height: 200,
          child: isMapEmpty()
              ? Center(child: Text('No Data'))
              : SNRM(
                  collection: getCollection(context),
                  showPeriod: Duration(minutes: 5),
                ),
        ),
        Container(
          height: 200,
          child: isMapEmpty()
              ? Center(child: Text('No Data'))
              : FECLine(
                  collection: getCollection(context),
                  showPeriod: Duration(minutes: 5),
                ),
        ),
        Container(
          height: 200,
          child: isMapEmpty()
              ? Center(child: Text('No Data'))
              : CRCLine(
                  collection: getCollection(context),
                  showPeriod: Duration(minutes: 5),
                ),
        )
      ],
    );
  }
}
