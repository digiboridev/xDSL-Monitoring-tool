import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/adsl_data_model.dart';

class CollectDataInterval extends StatelessWidget {
  const CollectDataInterval({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Split snapshots every ${context.watch<ADSLDataModel>().getCollectInterval.toString()} (min)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbColor: Colors.blueGrey.shade900,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8, pressedElevation: 10),
            ),
            child: Slider(
              value: context.watch<ADSLDataModel>().getCollectInterval.toDouble(),
              min: 10,
              max: 60,
              divisions: 5,
              label: context.watch<ADSLDataModel>().getCollectInterval.toString(),
              onChanged: (double value) {
                context.read<ADSLDataModel>().setCollectInterval = value.floor();
              },
            ),
          ),
        ],
      ),
    );
  }
}
