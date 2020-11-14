import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import '../../components/SNRM.dart';
import '../../components/SpeedLine.dart';
import '../../components/FECLine.dart';
import '../../components/CRCLine.dart';

class CollectionViewer extends StatelessWidget {
  int index;
  String cKey;
  bool isMapEmpty = false;

  List<LineStatsCollection> collection;

  CollectionViewer({this.index, this.cKey, this.collection});

  @override
  Widget build(BuildContext context) {
    print('render');

    if (collection.length < 2) {
      isMapEmpty = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Snapshot ' + cKey),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.blueGrey[50],
            child: SpeedLineExpandable(
              isEmpty: isMapEmpty,
              collection: collection,
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: SNRMExpandable(
              isEmpty: isMapEmpty,
              collection: collection,
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: FECLineExpandable(
              isEmpty: isMapEmpty,
              collection: collection,
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: CRCLineExpandable(
              isEmpty: isMapEmpty,
              collection: collection,
            ),
          ),
        ],
      ),
    );
  }
}
