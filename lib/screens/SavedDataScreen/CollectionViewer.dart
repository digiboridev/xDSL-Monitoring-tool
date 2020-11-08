import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import '../../components/SNRM.dart';
import '../../components/SpeedLine.dart';
import '../../components/FECLine.dart';
import '../../components/CRCLine.dart';

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
            child: SpeedLineExpandable(
              isEmpty: false,
              collection: collection,
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: SNRMExpandable(
              isEmpty: false,
              collection: collection,
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: FECLineExpandable(
              isEmpty: false,
              collection: collection,
            ),
          ),
          Container(
            color: Colors.blueGrey[50],
            child: CRCLineExpandable(
              isEmpty: false,
              collection: collection,
            ),
          ),
        ],
      ),
    );
  }
}
