import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/components/crc_line.dart';
import 'package:xdslmt/components/fec_line.dart';
import 'package:xdslmt/components/snrm.dart';
import 'package:xdslmt/components/speed_line.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/repositories/line_stats_repo.dart';
import 'package:xdslmt/widgets/text_styles.dart';

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
    lineStatsRepository.getBySnapshot(widget.snapshotId).then((data) {
      if (mounted) setState(() => statsList = data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
            color: Colors.cyan.shade100,
          ),
        ],
        title: Text(
          'Snapshot: ${widget.snapshotId}',
          style: TextStyles.f18w6.cyan100,
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                color: Colors.blueGrey.shade50,
                child: SpeedLineExpandable(
                  statsList: statsList,
                ),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: SNRMExpandable(collection: statsList),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: FECLineExpandable(collection: statsList),
              ),
              Container(
                color: Colors.blueGrey.shade50,
                child: CRCLineExpandable(collection: statsList),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
