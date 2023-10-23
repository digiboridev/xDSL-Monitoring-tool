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
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.transparent, Colors.transparent, Colors.white],
              stops: [0.0, 0.025, 0.950, 1.0],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: Builder(
            builder: (context) {
              final snapshots = context.select<SnapshotsScreenViewModel, List<String>>((vm) => vm.snapshots);
              if (snapshots.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  itemBuilder: (context, index) {
                    final snapshotId = snapshots[index];
                    return SnaplistTile(snapshotId: snapshotId, key: ValueKey(snapshotId));
                  },
                  itemCount: snapshots.length,
                );
              }
              return const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.data_array), SizedBox(width: 8), Text('Nothing captured yet...')],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
