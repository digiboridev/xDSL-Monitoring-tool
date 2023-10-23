import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/screens/snapshots/components/chart/interactive_chart.dart';
import 'package:xdslmt/widgets/app_colors.dart';
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
      backgroundColor: AppColors.blueGrey900,
      appBar: AppBar(
        leading: const SizedBox(),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            color: AppColors.cyan100,
          ),
        ],
        title: Hero(
          tag: widget.snapshotId,
          child: Material(
            key: Key(widget.snapshotId),
            color: Colors.transparent,
            child: Text(
              'Snapshot: ${widget.snapshotId}',
              style: TextStyles.f18w6.cyan100,
            ),
          ),
        ),
        backgroundColor: AppColors.blueGrey900,
      ),
      body: SizedBox.expand(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: body(),
        ),
      ),
    );
  }

  Widget body() {
    if (snapshotStats == null) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator());
    if (statsList.isEmpty) return const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      child: InteractiveChart(statsList: statsList, snapshotStats: snapshotStats!),
    );
  }
}
