import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/screens/settings/vm.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/core/text_styles.dart';

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
          Row(
            children: [
              Text(
                'Sampling every ${_watchSamplingInterval(context).inSeconds} (s)',
                style: TextStyles.f16w6.blueGrey900,
              ),
              const Spacer(),
              const Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                decoration: BoxDecoration(color: AppColors.blueGrey800, borderRadius: BorderRadius.all(Radius.circular(4))),
                padding: EdgeInsets.all(8),
                showDuration: Duration(seconds: 6),
                message: 'Sampling interval is the time between each data fetch.',
                child: Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
          SliderTheme(
            data: const SliderThemeData(
              trackHeight: 2,
              thumbColor: AppColors.blueGrey900,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8, pressedElevation: 10),
            ),
            child: Slider(
              value: _watchSamplingInterval(context).inSeconds.toDouble(),
              min: 1,
              max: 60,
              divisions: 24,
              label: _watchSamplingInterval(context).inSeconds.toString(),
              onChanged: (double value) => _getVm(context).setSamplingInterval = Duration(seconds: value.toInt()),
            ),
          ),
        ],
      ),
    );
  }
}
