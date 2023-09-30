import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/adsl_data_model.dart';
import 'package:xdsl_mt/screens/SavedDataScreen/collection_tile.dart';

class SavedDataScreen extends StatelessWidget {
  // final String _name = 'Recorded snapshots';

  const SavedDataScreen({super.key});

  // get name {
  //   return _name;
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint('Render saved screen');
    var count = context.select((ADSLDataModel c) => c.collectionsCount);

    if (count == 0) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.data_usage),
            Text(' No data'),
          ],
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
          colors: [
            Colors.cyan.shade50,
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return CollectionTile(
            cKey: context.watch<ADSLDataModel>().getCollectionsKeys.elementAt(index),
            index: index,
          );
        },
        itemCount: count,
        // itemCount: context.read<ADSLDataModel>().collectionsCount),
      ),
    );
  }
}
