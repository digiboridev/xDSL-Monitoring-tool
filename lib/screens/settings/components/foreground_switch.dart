import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/screens/settings/vm.dart';
import 'package:xdslmt/core/text_styles.dart';

class ForegroundSwitch extends StatelessWidget {
  const ForegroundSwitch({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  bool watchForeground(BuildContext context) => context.select<SettingsScreenViewModel, bool>((v) => v.foregroundService);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Row(
        children: [
          Text('Foreground service', style: TextStyles.f16w6.blueGrey900),
          const SizedBox(width: 8),
          SizedBox(
            height: 28,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Switch(
                value: watchForeground(context),
                onChanged: (v) => _getVm(context).setForegroundService = v,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
