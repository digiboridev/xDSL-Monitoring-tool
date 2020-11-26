import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';

class AverageStats extends StatefulWidget {
  bool isEmpty;
  List<LineStatsCollection> collection;

  AverageStats({this.isEmpty, this.collection});

  @override
  _AverageStatsState createState() => _AverageStatsState();
}

class _AverageStatsState extends State<AverageStats> {
  Duration _time;
  int _samples;
  int _errSamples;
  int _disconnects;

  int _snrmdAvg;
  int _snrmdMin;
  int _snrmdMax;
  int _snrmuAvg;
  int _snmduMin;
  int _snrmuMax;

  int _fecd;
  int _fecu;
  int _crcd;
  int _crcu;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Summary info',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('Sampling time: '), Text('$_time')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('Total samples: '), Text('$_samples')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('Errored samples: '), Text('$_errSamples')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('Disconects: '), Text('$_disconnects')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('SNRM Down:')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('avg: 9 / min 7.2 / max 11.5 / diff 3.7')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('SNRM Up:')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('avg: 7 / min 4.2 / max 13.5 / diff 6.7')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('RsCorr/FEC:')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('down: 213123 / up: 2231')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('RsUnCorr/CRC:')],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Row(
              children: [Text('down: 9123 / up: 431')],
            ),
          ),
        ],
      ),
    );
  }
}
