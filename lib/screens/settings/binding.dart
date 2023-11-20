import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/screens/settings/vm.dart';

class SettingsScreenBinding extends StatelessWidget {
  final Widget child;
  const SettingsScreenBinding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsScreenViewModel>(
      create: (_) => SettingsScreenViewModel(context.read<SettingsRepository>()),

      // VM loading guard
      builder: (context, child) {
        bool vmReady = context.select<SettingsScreenViewModel, bool>((v) => v.vmReady);
        if (vmReady == false) return const Center(child: CircularProgressIndicator());
        return child!;
      },
      child: child,
    );
  }
}
