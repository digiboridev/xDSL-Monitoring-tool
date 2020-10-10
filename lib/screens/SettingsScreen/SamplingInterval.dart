import 'package:dslstats/DslApp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/DataProvider.dart';

class SamplingInterval extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sampling interval (s)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Slider(
            value: context.watch<DataProvider>().getSamplingInterval.toDouble(),
            min: 1,
            max: 15,
            divisions: 3,
            label: context.watch<DataProvider>().getSamplingInterval.toString(),
            onChanged: (double value) {
              context.read<DataProvider>().setSamplingInterval = value.floor();
            },
          ),
        ],
      ),
    );
  }
}
