import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/DataProvider.dart';

class CollectDataInterval extends StatefulWidget {
  CollectDataInterval({Key key}) : super(key: key);

  @override
  _CollectDataIntervalState createState() => _CollectDataIntervalState();
}

class _CollectDataIntervalState extends State<CollectDataInterval> {
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
            value: _currentSliderValue,
            min: 10,
            max: 60,
            divisions: 5,
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
