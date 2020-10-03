import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/DataProvider.dart';

class SamplingInterval extends StatefulWidget {
  SamplingInterval({Key key}) : super(key: key);

  @override
  _SamplingIntervalState createState() => _SamplingIntervalState();
}

class _SamplingIntervalState extends State<SamplingInterval> {
  double _currentSliderValue = 1;

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
            value: _currentSliderValue,
            min: 1,
            max: 15,
            divisions: 3,
            label: _currentSliderValue.floor().toString(),
            onChanged: (double value) {
              double asd = value.floor().toDouble();
              setState(() {
                _currentSliderValue = asd;
              });
            },
          ),
        ],
      ),
    );
  }
}
