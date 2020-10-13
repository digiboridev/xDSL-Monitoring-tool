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
      margin: EdgeInsets.all(10),
      child: ListView.builder(
          itemBuilder: (context, index) {
            return CollectionTile(
                cKey: context.watch<DataProvider>().getCollectionsKeys[index]);
          },
          itemCount: context.watch<DataProvider>().collectionsCount),
    );
  }
}
