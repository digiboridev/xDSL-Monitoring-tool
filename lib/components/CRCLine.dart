import 'dart:async';
import 'dart:isolate';

import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';

import 'MyLineMarker.dart';
import 'XDateFormatter.dart';

class CRCLine extends StatefulWidget {
  List<LineStatsCollection> collection;
  Duration showPeriod;

  CRCLine({this.collection, this.showPeriod});

  @override
  _SNRMState createState() => _SNRMState();
}

class _SNRMState extends State<CRCLine> {
  LineChartController _controller;
  Isolate _isolateInstance;
  SendPort _mainToIsolateStream;
  ReceivePort _isolateToMainStream = ReceivePort();
  bool isSpawned = false;

  void initState() {
    _initController();
    _initIsolate();
  }

  @override
  void dispose() {
    //kill isolate
    killingIsolate();
    //stop listening
    _isolateToMainStream.close();
    super.dispose();
  }

  //Spawns isolate and listen msgs
  void _initIsolate() async {
    _isolateToMainStream.listen((data) {
      if (data is SendPort) {
        _mainToIsolateStream = data;
      } else if (data == 'imspawned') {
        setState(() {
          isSpawned = true;
        });
      } else if (data is LineData) {
        _mountLineData(data);
      }
    });

    _isolateInstance = await Isolate.spawn(
        LineDataComputingIsolate, _isolateToMainStream.sendPort);
  }

  //Kill isolate immediately if is spawned or retry after 1 second
  void killingIsolate() {
    if (_isolateInstance == null) {
      print('Chart Isolate kill tick');
      Timer(Duration(milliseconds: 100), killingIsolate);
    } else {
      _isolateInstance.kill();
    }
  }

  //Isolate for computing line data
  //Receives msg with List<LineStatsCollection>
  //Sends LineData for mount
  static void LineDataComputingIsolate(SendPort isolateToMainStream) {
    ReceivePort mainToIsolateStream = ReceivePort();
    isolateToMainStream.send(mainToIsolateStream.sendPort);

    mainToIsolateStream.listen((data) {
      if (data is List<LineStatsCollection>) {
        // Calc positive difference beetween last and current value

        List<Map> diff = [];
        for (var i = 1; i < data.length; i++) {
          if (data[i - 1].isErrored) {
            continue;
          }
          DateTime time = data[i].dateTime;

          int upCurr = data[i].upCRC ?? 0;
          int downCurr = data[i].downCRC ?? 0;
          int upPrev = data[i - 1].upCRC ?? 0;
          int downPrev = data[i - 1].downCRC ?? 0;

          int up = upCurr - upPrev;
          int down = downCurr - downPrev;

          diff.add({
            'dateTime': time,
            'downCRC': (down <= 0) ? 0 : down,
            'upCRC': (up <= 0) ? 0 : up
          });
        }

        // Prepare download CRC set

        List<Entry> downCRCValues = List();

        diff.forEach((element) {
          downCRCValues.add(new Entry(
              x: element['dateTime'].millisecondsSinceEpoch.toDouble(),
              y: element['downCRC'].toDouble()));
        });

        // Create a dataset
        LineDataSet downCRCSet = new LineDataSet(downCRCValues, "CRC Down");

        // Apply setiings
        downCRCSet
          // ..setLineWidth(1)
          ..setColor1(Colors.blueGrey[600])
          ..setMode(Mode.STEPPED)
          ..setDrawValues(false)
          ..setDrawFilled(true)
          ..setFillAlpha(200)
          ..setLineWidth(0)
          ..setGradientColor(Colors.blueGrey[600], Colors.blueGrey[200])
          ..setDrawCircles(false);

        // Prepare upload CRC set

        List<Entry> upCRCValues = List();

        diff.forEach((element) {
          upCRCValues.add(new Entry(
              x: element['dateTime'].millisecondsSinceEpoch.toDouble(),
              y: element['upCRC'].toDouble()));
        });

        // Create a dataset
        LineDataSet upCRCSet = new LineDataSet(upCRCValues, "CRC Up");

        // Apply settings
        upCRCSet
          // ..setLineWidth(1)
          ..setColor1(Colors.yellow[600])
          ..setMode(Mode.STEPPED)
          ..setDrawValues(false)
          ..setDrawFilled(true)
          ..setLineWidth(0)
          ..setFillAlpha(200)
          ..setGradientColor(Colors.yellow[600], Colors.yellow[200])
          ..setDrawCircles(false);

        // Add sets to line data and return
        LineData lineData =
            LineData.fromList(List()..add(downCRCSet)..add(upCRCSet));
        isolateToMainStream.send(lineData);
      } else {
        print('[mainToIsolateStream] $data');
      }
    });

    isolateToMainStream.send('imspawned');
  }

  // Initialize controller
  void _initController() {
    _controller = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..drawGridLines = true
            ..gridColor = Colors.blueGrey[50]
            ..drawAxisLine = false
            ..setAxisMinValue(0)
            // ..setAxisMaxValue(22)
            ..spacePercentTop = 40
            ..drawGridLinesBehindData = true;
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight
            ..enabled = true
            ..drawGridLines = false
            ..setAxisMinValue(0)
            // ..setAxisMaxValue(22)
            ..spacePercentTop = 40
            ..drawAxisLine = false;
        },
        legendSettingFunction: (legend, controller) {
          legend.enabled = true;
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..drawGridLines = true
            ..gridColor = Colors.blueGrey[50]
            ..drawAxisLine = false
            ..position = XAxisPosition.BOTTOM
            ..setAxisMaxValue(widget
                .collection.last.dateTime.millisecondsSinceEpoch
                .toDouble())
            ..setAxisMinValue(widget
                .collection.first.dateTime.millisecondsSinceEpoch
                .toDouble())
            ..setValueFormatter(XDateFormater());
          if (widget.showPeriod != null) {
            xAxis.setAxisMinValue(widget
                    .collection.last.dateTime.millisecondsSinceEpoch
                    .toDouble() -
                widget.showPeriod.inMilliseconds);
          }
        },
        drawGridBackground: false,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: false,
        pinchZoomEnabled: false,
        highLightPerTapEnabled: true,
        drawBorders: false,
        noDataText: 'loading',
        marker:
            MyLineMarker(textColor: Colors.white, backColor: Colors.blueGrey),
        highlightPerDragEnabled: true);
  }

  //Mount data in controller and update render by setstate
  void _mountLineData(LineData lineData) {
    _controller.data = lineData;
    _controller.state?.setStateIfNotDispose();
  }

  // Render
  @override
  Widget build(BuildContext context) {
    //Check for computing isolate spawn
    //After spawn sends is collection for computing

    if (!isSpawned) {
      return Container(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      print('render viewer');
      _mainToIsolateStream.send(widget.collection);
      return Container(
          color: Colors.white,
          height: 260,
          child: OverflowBox(
            alignment: Alignment.topCenter,
            maxHeight: 260,
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 16),
                    height: 200,
                    child: LineChart(_controller)),
                Transform.translate(
                  offset: const Offset(0, -208),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cyclic redundancy error',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
