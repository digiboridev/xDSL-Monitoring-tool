import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/data_sampling_service.dart';

class SamplingInterval extends StatelessWidget {
  const SamplingInterval({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sampling every ${context.watch<DataSamplingService>().getSamplingInterval.toDouble()} (s)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.shade800,
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbColor: Colors.blueGrey.shade900,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 8,
                pressedElevation: 10,
              ),
            ),
            child: Slider(
              value: context.watch<DataSamplingService>().getSamplingInterval.toDouble(),
              min: 1,
              max: 15,
              divisions: 3,
              label: context.watch<DataSamplingService>().getSamplingInterval.toString(),
              onChanged: (double value) {
                context.read<DataSamplingService>().setSamplingInterval = value.floor();
              },
            ),
          ),
        ],
      ),
    );
  }
}
