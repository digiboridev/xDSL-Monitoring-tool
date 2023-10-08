import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/screens/snapshots/components/snapshot_viewer.dart';
import 'package:xdslmt/screens/snapshots/vm.dart';
import 'package:xdslmt/utils/formatters.dart';

class SnaplistTile extends StatefulWidget {
  const SnaplistTile({super.key, required this.snapshotId});
  final String snapshotId;

  @override
  State<SnaplistTile> createState() => _SnaplistTileState();
}

class _SnaplistTileState extends State<SnaplistTile> {
  late StatsRepository statsRepository = context.read<StatsRepository>();
  late StreamSubscription updSub;
  SnapshotStats? snapshotStats;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsRepository>().snapshotStatsById(widget.snapshotId).then((value) {
        if (mounted) setState(() => snapshotStats = value);
      });
    });
    updSub = statsRepository.snapshotStatsStreamById(widget.snapshotId).listen((event) {
      if (mounted) setState(() => snapshotStats = event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    updSub.cancel();
  }

  onTap() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SnapshotViewer(widget.snapshotId)));
  }

  onDelete() async {
    final bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete snapshot?'),
        content: Text('This will delete all data associated with this snapshot.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      await statsRepository.deleteStats(widget.snapshotId);
      context.read<SnapshotsScreenViewModel>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: onTap,
      title: Text('Snapshot: ' + widget.snapshotId),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (snapshotStats != null) ...[
            Text(snapshotStats!.startTime.ymdhms),
            Text('T: ' + snapshotStats!.samplingDuration.hms + '  ' + 'UP: ' + snapshotStats!.uplinkDuration.hms)
          ],
        ],
      ),
      leading: SizedBox(
        width: 50,
        child: Column(
          children: [
            Icon(Icons.bar_chart),
            if (snapshotStats != null) ...[
              Text('S:' + snapshotStats!.samples.toString()),
              Text('D:' + snapshotStats!.samplingErrors.toString()),
            ]
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.playlist_remove_sharp),
        onPressed: onDelete,
      ),
    );
  }
}
