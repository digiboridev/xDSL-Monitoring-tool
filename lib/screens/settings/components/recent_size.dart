import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/screens/settings/vm.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/core/text_styles.dart';

class RecentSize extends StatelessWidget {
  const RecentSize({super.key});

  SettingsScreenViewModel _getVm(BuildContext context) => context.read<SettingsScreenViewModel>();
  int _watchRecentSize(BuildContext context) => context.select<SettingsScreenViewModel, int>((v) => v.recentSize);

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
                'Recent size ${_watchRecentSize(context)} (samples)',
                style: TextStyles.f16w6.blueGrey900,
              ),
              const Spacer(),
              const Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                decoration: BoxDecoration(color: AppColors.blueGrey800, borderRadius: BorderRadius.all(Radius.circular(4))),
                padding: EdgeInsets.all(8),
                showDuration: Duration(seconds: 6),
                message: 'Limit the number of recent samples that uses on monitoring screen.\n',
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
              value: _watchRecentSize(context).toDouble(),
              min: 100,
              max: 5000,
              divisions: 49,
              label: _watchRecentSize(context).toString(),
              onChanged: (double value) => _getVm(context).setRecentSize = value.toInt(),
            ),
          ),
        ],
      ),
    );
  }
}
