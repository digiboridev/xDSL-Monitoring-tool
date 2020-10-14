import 'package:dslstats/models/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'CollectionTile.dart';

class SavedDataScreen extends StatelessWidget {
  String _name = 'Collected data';
  get name {
    return _name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return CollectionTile(
              cKey: context
                  .watch<DataProvider>()
                  .getCollectionsKeys
                  .elementAt(index),
              index: index,
            );
          },
          itemCount: context.watch<DataProvider>().collectionsCount),
    );
  }
}
