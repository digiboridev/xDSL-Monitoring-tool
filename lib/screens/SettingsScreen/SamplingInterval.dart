import 'package:dslstats/models/SettingsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SamplingInterval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sampling every ${context.watch<SettingsModel>().getSamplingInterval.toDouble()} (s)',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey[800]),
          ),
          SliderTheme(
            data: SliderThemeData(
                trackHeight: 2,
                thumbColor: Colors.blueGrey[900],
                thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 8, pressedElevation: 10)),
            child: Slider(
              value:
                  context.watch<SettingsModel>().getSamplingInterval.toDouble(),
              min: 1,
              max: 15,
              divisions: 3,
              label:
                  context.watch<SettingsModel>().getSamplingInterval.toString(),
              onChanged: (double value) {
                context.read<SettingsModel>().setSamplingInterval =
                    value.floor();
              },
            ),
          )
        ],
      ),
    );
  }
}
