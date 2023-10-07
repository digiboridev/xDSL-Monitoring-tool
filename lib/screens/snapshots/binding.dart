import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/data/repositories/line_stats_repo.dart';
import 'package:xdsl_mt/screens/snapshots/vm.dart';

class SnapshotsScreenBinding extends StatelessWidget {
  final Widget child;
  const SnapshotsScreenBinding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<SnapshotsScreenViewModel>(
      create: (_) => SnapshotsScreenViewModel(context.read<LineStatsRepository>()),

      // VM loading guard
      builder: (context, child) {
        bool vmReady = context.select<SnapshotsScreenViewModel, bool>((v) => v.vmReady);
        if (vmReady == false) return const Center(child: CircularProgressIndicator());
        return child!;
      },
      child: child,
    );
  }
}
