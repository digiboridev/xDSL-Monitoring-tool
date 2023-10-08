import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/screens/settings/vm.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class SplitInterval extends StatelessWidget {
  const SplitInterval({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  Duration _watchSplitInterval(BuildContext context) => context.select<SettingsScreenViewModel, Duration>((v) => v.splitInterval);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Split snapshots every ${_watchSplitInterval(context).inMinutes} (m)',
            style: TextStyles.f16w6.blueGrey800,
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbColor: Colors.blueGrey.shade900,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8, pressedElevation: 10),
            ),
            child: Slider(
              value: _watchSplitInterval(context).inMinutes.toDouble(),
              min: 10,
              max: 60,
              divisions: 5,
              label: _watchSplitInterval(context).inMinutes.toString(),
              onChanged: (double value) => _getVm(context).setSplitInterval = Duration(minutes: value.toInt()),
            ),
          ),
        ],
      ),
    );
  }
}
