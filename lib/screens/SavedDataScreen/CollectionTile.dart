import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dslstats/models/DataProvider.dart';
import 'package:provider/provider.dart';
import 'CollectionViewer.dart';

class CollectionTile extends StatelessWidget {
  final String cKey;
  final int index;
  const CollectionTile({this.cKey, this.index});

  Widget trail(BuildContext context) {
    if (index == 0) {
      return null;
    }
    return GestureDetector(
      onTap: () => context.read<DataProvider>().deleteCollection(cKey),
      child: Container(
        width: 40,
        height: 40,
        color: Colors.transparent,
        child: Icon(Icons.delete_forever),
      ),
    );
  }

  void pushCollectionViewer(BuildContext context) {
    var collection = context.read<DataProvider>().getCollectionByKey(cKey);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CollectionViewer(
        cKey: cKey,
        index: index,
        collection: collection,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    String length() {
      return context
          .watch<DataProvider>()
          .getCollections[cKey]
          .length
          .toString();
    }

    return Container(
      child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.show_chart)],
          ),
          title: Text(
            cKey,
            style: TextStyle(fontSize: 14),
          ),
          subtitle: Text(length() + ' samples'),
          trailing: trail(context),
          onTap: () => pushCollectionViewer(context)),
    );
  }
}
