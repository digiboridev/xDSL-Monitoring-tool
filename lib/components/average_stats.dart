import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xdsl_mt/models/modemClients/line_stats_collection.dart';

class AvgStatsData {
  final Duration time;
  final int samples;
  final int errSamples;
  final int disconnects;
  final double snrmdAvg;
  final double snrmdMin;
  final double snrmdMax;
  final double snrmuAvg;
  final double snrmuMin;
  final double snrmuMax;
  final int fecd;
  final int fecu;
  final int crcd;
  final int crcu;

  AvgStatsData({
    required this.time,
    required this.samples,
    required this.errSamples,
    required this.disconnects,
    required this.snrmdAvg,
    required this.snrmdMin,
    required this.snrmdMax,
    required this.snrmuAvg,
    required this.snrmuMin,
    required this.snrmuMax,
    required this.fecd,
    required this.fecu,
    required this.crcd,
    required this.crcu,
  });
}

class AverageStats extends StatefulWidget {
  // bool isEmpty;
  final List<LineStatsCollection> collection;

  const AverageStats({super.key, required this.collection});

  @override
  State<AverageStats> createState() => _AverageStatsState();
}

class _AverageStatsState extends State<AverageStats> {
  AvgStatsData? avgStatsData;

  @override
  void initState() {
    doCompute();
    super.initState();
  }

  //All data calculation function
  static AvgStatsData computeFunc(List<LineStatsCollection> collection) {
    //calc time beetween first and last sample
    Duration time() {
      if (collection.length > 1) {
        LineStatsCollection first = collection.first;
        LineStatsCollection last = collection.last;
        return last.dateTime.difference(first.dateTime);
      } else {
        return Duration(seconds: 0);
      }
    }

    //all samples
    int samples() {
      return collection.length;
    }

    //errored samples
    int errSamples() {
      int count = 0;
      for (var i = 0; i < collection.length; i++) {
        collection[i].isErrored == true ? count++ : {};
      }
      return count;
    }

    //Find how many time connection is drops
    int disconnects() {
      int count = 0;
      for (var i = 1; i < collection.length; i++) {
        if (collection[i - 1].isConnectionUp == true && collection[i].isConnectionUp == false) {
          count++;
        }
      }
      return count;
    }

    //Calc average snrmd
    double snrmdAvg() {
      double acc = 0;
      int counter = 0;
      for (var i = 0; i < collection.length; i++) {
        // if (collection[i].downMargin == null) {
        //   continue;
        // }
        if (collection[i].downMargin > 2) {
          counter++;
          acc += collection[i].downMargin;
        }
      }

      var result = acc / counter;
      return (result.isNaN) ? 0 : double.parse(result.toStringAsFixed(2));
    }

    //Calc average snrmu
    double snrmuAvg() {
      double acc = 0;
      int counter = 0;
      for (var i = 0; i < collection.length; i++) {
        // if (collection[i].upMargin == null) {
        //   continue;
        // }
        if (collection[i].upMargin > 2) {
          counter++;
          acc += collection[i].upMargin;
        }
      }

      var result = acc / counter;
      return (result.isNaN) ? 0 : double.parse(result.toStringAsFixed(2));
    }

    //Find min value of snrmd
    double snrmdMin() {
      List<double> acc = [];

      for (var i = 0; i < collection.length; i++) {
        if (collection[i].downMargin < 2) {
          continue;
        }
        acc.add(collection[i].downMargin);
      }

      if (acc.isEmpty) {
        return 0;
      }

      return acc.reduce((value, element) => value > element ? element : value);
    }

    //Find min value of snrmu
    double snrmuMin() {
      List<double> acc = [];

      for (var i = 0; i < collection.length; i++) {
        if (collection[i].upMargin < 2) {
          continue;
        }
        acc.add(collection[i].upMargin);
      }

      if (acc.isEmpty) {
        return 0;
      }

      return acc.reduce((value, element) => value > element ? element : value);
    }

    //Find max value of snrmd
    double snrmdMax() {
      List<double> acc = [];

      for (var i = 0; i < collection.length; i++) {
        if (collection[i].downMargin < 2) {
          continue;
        }
        acc.add(collection[i].downMargin);
      }

      if (acc.isEmpty) {
        return 0;
      }

      return acc.reduce((value, element) => value < element ? element : value);
    }

    //Find ma value of snrmu
    double snrmuMax() {
      List<double> acc = [];

      for (var i = 0; i < collection.length; i++) {
        if (collection[i].upMargin < 2) {
          continue;
        }
        acc.add(collection[i].upMargin);
      }

      if (acc.isEmpty) {
        return 0;
      }

      return acc.reduce((value, element) => value < element ? element : value);
    }

    //Calc totaly increased fecd
    int fecd() {
      int acc = 0;
      for (var i = 1; i < collection.length; i++) {
        if (collection[i - 1].isErrored) {
          continue;
        }

        int curr = collection[i].downFEC;
        int prev = collection[i - 1].downFEC;
        int diff = curr - prev;

        acc += diff;
      }
      return acc;
    }

    //Calc totaly increased fecu
    int fecu() {
      int acc = 0;
      for (var i = 1; i < collection.length; i++) {
        if (collection[i - 1].isErrored) {
          continue;
        }

        int curr = collection[i].upFEC;
        int prev = collection[i - 1].upFEC;
        int diff = curr - prev;

        acc += diff;
      }
      return acc;
    }

    //Calc totaly increased crcd
    int crcd() {
      int acc = 0;
      for (var i = 1; i < collection.length; i++) {
        if (collection[i - 1].isErrored) {
          continue;
        }

        int curr = collection[i].downCRC;
        int prev = collection[i - 1].downCRC;
        int diff = curr - prev;

        acc += diff;
      }
      return acc;
    }

    //Calc totaly increased crcu
    int crcu() {
      int acc = 0;
      for (var i = 1; i < collection.length; i++) {
        if (collection[i - 1].isErrored) {
          continue;
        }

        int curr = collection[i].upCRC;
        int prev = collection[i - 1].upCRC;
        int diff = curr - prev;

        acc += diff;
      }
      return acc;
    }

    //Create instance with calculated paremeters and return
    AvgStatsData avgStatsData = AvgStatsData(
      time: time(),
      samples: samples(),
      errSamples: errSamples(),
      disconnects: disconnects(),
      snrmdAvg: snrmdAvg(),
      snrmdMin: snrmdMin(),
      snrmdMax: snrmdMax(),
      snrmuAvg: snrmuAvg(),
      snrmuMin: snrmuMin(),
      snrmuMax: snrmuMax(),
      fecd: fecd(),
      fecu: fecu(),
      crcd: crcd(),
      crcu: crcu(),
    );

    return avgStatsData;
  }

  void doCompute() async {
    //Wait data from isolate
    AvgStatsData answer = await compute(computeFunc, widget.collection);

    //set data
    setState(() {
      avgStatsData = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Check for computing data
    if (avgStatsData == null) {
      return Container(
        color: Colors.white,
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
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
                children: [Text('Sampling time: '), Text(avgStatsData!.time.toString().substring(0, 7))],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [Text('Total samples: '), Text(avgStatsData!.samples.toString())],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [Text('Errored samples: '), Text(avgStatsData!.errSamples.toString())],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [Text('Disconects: '), Text(avgStatsData!.disconnects.toString())],
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
                children: [Text('avg: ${avgStatsData!.snrmdAvg} / min ${avgStatsData!.snrmdMin} / max ${avgStatsData!.snrmdMax}')],
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
                children: [Text('avg: ${avgStatsData!.snrmuAvg} / min ${avgStatsData!.snrmuMin} / max ${avgStatsData!.snrmuMax}')],
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
                children: [Text('down: ${avgStatsData!.fecd} / up: ${avgStatsData!.fecu}')],
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
                children: [Text('down: ${avgStatsData!.crcd} / up: ${avgStatsData!.crcu}')],
              ),
            ),
          ],
        ),
      );
    }

    //Render
  }
}
