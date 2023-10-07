import 'package:flutter/material.dart';
import 'package:xdsl_mt/screens/snapshots/components/snapshot_viewer.dart';

class SnaplistTile extends StatelessWidget {
  const SnaplistTile({super.key, required this.snapshot});
  final String snapshot;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SnapshotViewer(snapshot)));
      },
      title: Text(snapshot),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // context.read<SnapshotsScreenViewModel>().deleteSnapshot(snapshots[index]);
        },
      ),
    );
  }
}
