import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/repositories/current_sampling_repo.dart';
import 'package:xdslmt/screens/monitoring/vm.dart';

class MonitoringScreenBinding extends StatelessWidget {
  final Widget child;
  const MonitoringScreenBinding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MonitoringScreenViewModel>(
      create: (_) => MonitoringScreenViewModel(context.read<CurrentSamplingRepository>()),
      child: child,
    );
  }
}
