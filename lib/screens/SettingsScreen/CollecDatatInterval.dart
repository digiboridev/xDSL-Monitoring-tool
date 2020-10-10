import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/DataProvider.dart';

class CollectDataInterval extends StatelessWidget {
  double _currentSliderValue = 60;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Collect data interval (min)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Slider(
            value: context.watch<DataProvider>().getCollectInterval.toDouble(),
            min: 10,
            max: 60,
            divisions: 5,
            label: context.watch<DataProvider>().getCollectInterval.toString(),
            onChanged: (double value) {
              context.read<DataProvider>().setCollectInterval = value.floor();
            },
          ),
        ],
      ),
    );
  }
}
