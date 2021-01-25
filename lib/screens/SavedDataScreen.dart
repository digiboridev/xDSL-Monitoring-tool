import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:xDSL_Monitoring_tool/models/ADSLDataModel.dart';
import 'SavedDataScreen/CollectionTile.dart';

class SavedDataScreen extends StatelessWidget {
  String _name = 'Recorded snapshots';
  get name {
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    print('Render saved screen');
    var count = context.select((ADSLDataModel c) => c.collectionsCount);

    if (count == 0) {
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.data_usage),
          Text(' No data'),
        ],
      ));
    }
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [Colors.cyan[50], Colors.white, Colors.white])),
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return CollectionTile(
            cKey: context
                .watch<ADSLDataModel>()
                .getCollectionsKeys
                .elementAt(index),
            index: index,
          );
        },
        itemCount: count,
        // itemCount: context.read<ADSLDataModel>().collectionsCount),
      ),
    );
  }
}
