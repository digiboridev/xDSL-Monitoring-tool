import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/DataProvider.dart';

class CollectDataInterval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Start new collection after ${context.watch<DataProvider>().getCollectInterval.toString()} (min)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SliderTheme(
            data: SliderThemeData(
                trackHeight: 2,
                thumbColor: Colors.blueGrey[900],
                thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 8, pressedElevation: 10)),
            child: Slider(
              value:
                  context.watch<DataProvider>().getCollectInterval.toDouble(),
              min: 10,
              max: 60,
              divisions: 5,
              label:
                  context.watch<DataProvider>().getCollectInterval.toString(),
              onChanged: (double value) {
                context.read<DataProvider>().setCollectInterval = value.floor();
              },
            ),
          )
        ],
      ),
    );
  }
}
