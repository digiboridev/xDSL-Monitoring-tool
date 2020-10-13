import 'package:flutter/material.dart';
import 'package:dslstats/models/DataProvider.dart';
import 'package:provider/provider.dart';

class CollectionTile extends StatelessWidget {
  final String cKey;
  const CollectionTile({this.cKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(cKey),
          Text(context.watch<DataProvider>().getCollections[cKey].toString())
        ],
      ),
    );
  }
}
