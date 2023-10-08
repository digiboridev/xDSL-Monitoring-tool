import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/data/repositories/settings_repo.dart';
import 'package:xdsl_mt/screens/settings/vm.dart';

class SettingsScreenBinding extends StatelessWidget {
  final Widget child;
  const SettingsScreenBinding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<SettingsScreenViewModel>(
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