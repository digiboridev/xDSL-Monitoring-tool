import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/repositories/current_sampling_repo.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/screens/snapshots/components/snapshot_viewer.dart';
import 'package:xdslmt/screens/snapshots/vm.dart';
import 'package:xdslmt/core/formatters.dart';
import 'package:xdslmt/core/text_styles.dart';

class SnaplistTile extends StatefulWidget {
  const SnaplistTile({super.key, required this.snapshotId});
  final String snapshotId;

  @override
  State<SnaplistTile> createState() => _SnaplistTileState();
}

class _SnaplistTileState extends State<SnaplistTile> {
  SnapshotStats? snapshotStats;
  bool isActiveSnapshot = false;

  @override
  void initState() {
    super.initState();

    final currentSamplingRepository = context.read<CurrentSamplingRepository>();
    bool hasLastSnapshot = currentSamplingRepository.lastSnapshotStats?.snapshotId == widget.snapshotId;
    bool isSamplingActive = currentSamplingRepository.samplingActive;

    // If the last sampling snapshot is the one we are displaying, we can use it directly
    // Otherwise (else) we need to fetch the snapshot from the database
    if (hasLastSnapshot) {
      // Assign local data
      snapshotStats = currentSamplingRepository.lastSnapshotStats;
      isActiveSnapshot = hasLastSnapshot && isSamplingActive;

      // Listen for updates while snapshot is processing
      if (isActiveSnapshot) {
        Future.doWhile(() async {
          // Wait for update
          await currentSamplingRepository.eventBus.first;
          hasLastSnapshot = currentSamplingRepository.lastSnapshotStats?.snapshotId == widget.snapshotId;
          isSamplingActive = currentSamplingRepository.samplingActive;

          // Update local data
          if (hasLastSnapshot) snapshotStats = snapshotStats = currentSamplingRepository.lastSnapshotStats;
          isActiveSnapshot = hasLastSnapshot && isSamplingActive;
          if (mounted) setState(() {});

          // Continue listening if snapshot still displayed and processing
          return isActiveSnapshot && mounted;
        });
      }
    } else {
      final statsRepository = context.read<StatsRepository>();
      statsRepository.snapshotStatsById(widget.snapshotId).then((value) {
        if (mounted) setState(() => snapshotStats = value);
      });
    }
  }

  onTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SnapshotViewer(widget.snapshotId),
        settings: const RouteSettings(name: 'SnapshotViewer'),
      ),
    );
  }

  onDelete() async {
    final statsRepository = context.read<StatsRepository>();
    final snapshotsScreenViewModel = context.read<SnapshotsScreenViewModel>();

    final bool? result = await showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: AlertDialog(
          title: const Text('Delete snapshot?'),
          content: const Text('This will delete all data associated with this snapshot.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      await statsRepository.deleteStats(widget.snapshotId);
      snapshotsScreenViewModel.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: onTap,
      title: Hero(
        tag: widget.snapshotId,
        child: Material(
          key: Key(widget.snapshotId),
          color: Colors.transparent,
          child: Text(
            'Snapshot: ${widget.snapshotId}',
            style: TextStyles.f16w6.blueGrey900,
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (snapshotStats != null) ...[
            Text(snapshotStats!.startTime.ymdhms),
            Text('T: ${snapshotStats!.samplingDuration.hms}  UP: ${snapshotStats!.uplinkDuration.hms}'),
          ],
        ],
      ),
      leading: SizedBox(
        width: 50,
        child: Column(
          children: [
            const Icon(Icons.bar_chart),
            if (snapshotStats != null) ...[
              Text('S:${snapshotStats!.samples}'),
              Text('D:${snapshotStats!.samplingErrors}'),
            ],
          ],
        ),
      ),
      trailing: isActiveSnapshot
          ? null
          : IconButton(
              icon: const Icon(Icons.playlist_remove_sharp),
              onPressed: onDelete,
            ),
    );
  }
}
