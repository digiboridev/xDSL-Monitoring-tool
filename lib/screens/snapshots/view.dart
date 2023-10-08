import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/screens/snapshots/components/snaplist_tile.dart';
import 'package:xdslmt/screens/snapshots/vm.dart';

class SnapshotsScreenView extends StatelessWidget {
  const SnapshotsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Colors.cyan.shade100,
              Colors.white,
              Colors.cyan.shade100,
            ],
          ),
        ),
        child: Builder(
          builder: (context) {
            final snapshots = context.select<SnapshotsScreenViewModel, List<String>>((vm) => vm.snapshots);
            if (snapshots.isNotEmpty) {
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final snapshot = snapshots[index];
                  return SnaplistTile(snapshot: snapshot);
                },
                itemCount: snapshots.length,
              );
            }
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.data_array), SizedBox(width: 8), Text('Nothing captured yet...')],
              ),
            );
          },
        ),
      ),
    );
  }
}
