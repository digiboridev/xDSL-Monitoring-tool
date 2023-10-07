import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/components/average_stats.dart';
import 'package:xdsl_mt/components/crc_line.dart';
import 'package:xdsl_mt/components/external_latency.dart';
import 'package:xdsl_mt/components/fec_line.dart';
import 'package:xdsl_mt/components/modem_latency.dart';
import 'package:xdsl_mt/components/snrm.dart';
import 'package:xdsl_mt/components/speed_line.dart';
import 'package:xdsl_mt/data/models/line_stats.dart';
import 'package:xdsl_mt/data/repositories/line_stats_repo.dart';

class SnapshotViewer extends StatefulWidget {
  final String snapshotId;
  const SnapshotViewer(this.snapshotId, {super.key});

  @override
  State<SnapshotViewer> createState() => _SnapshotViewerState();
}

class _SnapshotViewerState extends State<SnapshotViewer> {
  late final lineStatsRepository = context.read<LineStatsRepository>();
  List<LineStats> statsList = [];

  @override
  void initState() {
    super.initState();
    lineStatsRepository.getBySession(widget.snapshotId).then((data) {
      if (mounted) setState(() => statsList = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snapshot ${widget.snapshotId}'),
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
                  collection: [],
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: SpeedLineExpandable(
                  statsList: statsList,
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: SNRMExpandable(
                  isEmpty: false,
                  collection: [],
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: FECLineExpandable(
                  isEmpty: false,
                  collection: [],
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: CRCLineExpandable(
                  isEmpty: false,
                  collection: [],
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: ModemLatencyExpandable(
                  isEmpty: false,
                  collection: [],
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: ExternalLatencyExpandable(
                  isEmpty: false,
                  collection: [],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
