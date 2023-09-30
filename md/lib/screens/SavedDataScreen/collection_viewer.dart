import 'package:flutter/material.dart';
import 'package:xdsl_mt/components/average_stats.dart';
import 'package:xdsl_mt/components/crc_line.dart';
import 'package:xdsl_mt/components/external_latency.dart';
import 'package:xdsl_mt/components/fec_line.dart';
import 'package:xdsl_mt/components/modem_latency.dart';
import 'package:xdsl_mt/components/snrm.dart';
import 'package:xdsl_mt/components/speed_line.dart';
import 'package:xdsl_mt/models/modemClients/line_stats_collection.dart';

class CollectionViewer extends StatelessWidget {
  final int index;
  final String cKey;
  // final bool isMapEmpty = false;
  final List<LineStatsCollection> collection;

  const CollectionViewer({super.key, required this.index, required this.cKey, required this.collection});

  get isMapEmpty => collection.length < 2;

  @override
  Widget build(BuildContext context) {
    debugPrint('render');

    // if (collection.length < 2) {
    //   isMapEmpty = true;
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text('Snapshot $cKey'),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                color: Colors.blueGrey.shade50,
                child: AverageStats(
                  // isEmpty: isMapEmpty,
                  collection: collection,
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: SpeedLineExpandable(
                  isEmpty: isMapEmpty,
                  collection: collection,
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: SNRMExpandable(
                  isEmpty: isMapEmpty,
                  collection: collection,
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: FECLineExpandable(
                  isEmpty: isMapEmpty,
                  collection: collection,
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: CRCLineExpandable(
                  isEmpty: isMapEmpty,
                  collection: collection,
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: ModemLatencyExpandable(
                  isEmpty: isMapEmpty,
                  collection: collection,
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: ExternalLatencyExpandable(
                  isEmpty: isMapEmpty,
                  collection: collection,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
