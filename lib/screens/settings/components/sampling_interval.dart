import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/screens/settings/vm.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class SamplingInterval extends StatelessWidget {
  const SamplingInterval({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  Duration _watchSamplingInterval(BuildContext context) => context.select<SettingsScreenViewModel, Duration>((v) => v.samplingInterval);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sampling every ${_watchSamplingInterval(context).inSeconds} (s)',
            style: TextStyles.f16w6.blueGrey800,
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbColor: Colors.blueGrey.shade900,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8, pressedElevation: 10),
            ),
            child: Slider(
              value: _watchSamplingInterval(context).inSeconds.toDouble(),
              min: 1,
              max: 60,
              divisions: 12,
              label: _watchSamplingInterval(context).inSeconds.toString(),
              onChanged: (double value) => _getVm(context).setSamplingInterval = Duration(seconds: value.toInt()),
            ),
          ),
        ],
      ),
    );
  }
}
