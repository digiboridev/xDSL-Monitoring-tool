import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/adsl_data_model.dart';
import 'package:xdsl_mt/models/modemClients/line_stats_collection.dart';
import 'package:xdsl_mt/screens/SavedDataScreen/collection_viewer.dart';

class CollectionTile extends StatelessWidget {
  final String cKey;
  final int index;
  const CollectionTile({super.key, required this.cKey, required this.index});

  Widget? trail(BuildContext context) {
    if (index == 0) {
      return null;
    }
    return GestureDetector(
      onTap: () => context.read<ADSLDataModel>().deleteCollection(cKey),
      child: Container(
        width: 40,
        height: 40,
        color: Colors.transparent,
        child: Icon(
          Icons.clear_rounded,
          color: Colors.blueGrey.shade800,
        ),
      ),
    );
  }

  void pushCollectionViewer(BuildContext context) {
    // TODO: cast remove;
    List<LineStatsCollection> collection = context.read<ADSLDataModel>().getCollectionByKey(cKey) as List<LineStatsCollection>;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CollectionViewer(
            cKey: cKey,
            index: index,
            collection: collection,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: cast remove;
    List<LineStatsCollection> collectionMap = context.watch<ADSLDataModel>().getCollectionByKey(cKey) as List<LineStatsCollection>;

    String length() {
      return collectionMap.length.toString();
    }

    String disconnects() {
      int count = 0;
      for (var i = 1; i < collectionMap.length; i++) {
        if (collectionMap[i - 1].isConnectionUp == true && collectionMap[i].isConnectionUp == false) {
          count++;
        }
      }
      return count.toString();
    }

    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_motion,
            color: Colors.blueGrey.shade800,
          )
        ],
      ),
      title: Text(
        cKey,
        style: TextStyle(fontSize: 14),
      ),
      subtitle: Text('${length()} samples  ${disconnects()} disconnects'),
      trailing: trail(context),
      onTap: () => pushCollectionViewer(context),
    );
  }
}
