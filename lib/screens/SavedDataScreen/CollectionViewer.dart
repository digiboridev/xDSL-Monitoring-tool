import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'SNRM.dart';
import 'SpeedLine.dart';
import 'FECLine.dart';
import 'CRCLine.dart';

class CollectionViewer extends StatelessWidget {
  int index;
  String cKey;
  List<LineStatsCollection> collection;

  CollectionViewer({this.index, this.cKey, this.collection});

  @override
  Widget build(BuildContext context) {
    print('render');

    return Scaffold(
      appBar: AppBar(
        title: Text('Charts ' + cKey),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.blueGrey[50],
            child: SpeedLine(
              collection: collection,
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: SNRM(
              collection: collection,
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: FECLine(
              collection: collection,
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: CRCLine(
              collection: collection,
            ),
          ),
        ],
      ),
    );
  }
}
