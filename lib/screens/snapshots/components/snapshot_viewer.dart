import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/screens/snapshots/components/chart/interactive_chart.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class SnapshotViewer extends StatefulWidget {
  final String snapshotId;
  const SnapshotViewer(this.snapshotId, {super.key});

  @override
  State<SnapshotViewer> createState() => _SnapshotViewerState();
}

class _SnapshotViewerState extends State<SnapshotViewer> {
  late final statsRepository = context.read<StatsRepository>();
  List<LineStats> statsList = [];
  SnapshotStats? snapshotStats;

  @override
  void initState() {
    super.initState();
    statsRepository.lineStatsBySnapshot(widget.snapshotId).then((data) {
      if (mounted) setState(() => statsList = data);
    });
    statsRepository.snapshotStatsById(widget.snapshotId).then((data) {
      if (mounted) setState(() => snapshotStats = data);
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
        title: Hero(
          child: Material(
            key: Key(widget.snapshotId),
            color: Colors.transparent,
            child: Text(
              'Snapshot: ${widget.snapshotId}',
              style: TextStyles.f18w6.cyan100,
            ),
          ),
          tag: widget.snapshotId,
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: SizedBox.expand(
        child: body(),
      ),
    );
  }

  Widget body() {
    if (snapshotStats == null) return Center(child: CircularProgressIndicator());
    if (statsList.isEmpty) return Center(child: CircularProgressIndicator());

    return Container(
      color: Colors.blueGrey.shade900,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: InteractiveChart(statsList: statsList, snapshotStats: snapshotStats!),
      ),
    );
  }
}
