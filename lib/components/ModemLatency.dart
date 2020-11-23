import 'dart:async';
import 'dart:isolate';

import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_android/android_os.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';

import 'MyLineMarker.dart';
import 'XDateFormatter.dart';

class ModemLatency extends StatefulWidget {
  List<LineStatsCollection> collection;
  Duration showPeriod;

  ModemLatency({this.collection, this.showPeriod});

  @override
  _ModemLatencyState createState() => _ModemLatencyState();
}

class _ModemLatencyState extends State<ModemLatency> {
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
        // Prepare latency dataset

        List<Entry> ModenLatency = List();

        data.forEach((element) {
          ModenLatency.add(new Entry(
              x: element.dateTime.millisecondsSinceEpoch.toDouble(),
              y: element.latencyToModem ?? 0));
        });

        // Create a dataset
        LineDataSet ModenLatencySet =
            new LineDataSet(ModenLatency, "Latency ms");

        // Apply settings
        ModenLatencySet
          // ..setLineWidth(1)
          ..setColor1(Colors.blueGrey[800])
          ..setMode(Mode.STEPPED)
          ..setDrawValues(false)
          ..setDrawCircles(false);

        // Prepare errors set
        List<Entry> connectionErrValues = List();

        data.forEach((element) {
          connectionErrValues.add(new Entry(
              x: element.dateTime.millisecondsSinceEpoch.toDouble(),
              y: element.latencyToModem == 0 ? 1000 : 0));
        });

        // Create a dataset
        LineDataSet connectionErrSet =
            new LineDataSet(connectionErrValues, "Packet loss");

        // Apply settings
        connectionErrSet
          ..setColor1(Colors.red[200])
          ..setLineWidth(0)
          ..setDrawFilled(true)
          ..setFillAlpha(255)
          ..setHighlightEnabled(false)
          ..setFillColor(Colors.red[200])
          ..setDrawValues(false)
          ..setDrawCircles(false)
          ..setMode(Mode.STEPPED);

        // Add sets to line data and return
        LineData lineData = LineData.fromList(
            List()..add(ModenLatencySet)..add(connectionErrSet));
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
            ..setAxisMaxValue(1000)
            // ..spacePercentTop = 40
            ..drawGridLinesBehindData = true;
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight
            ..enabled = true
            ..drawGridLines = false
            ..setAxisMinValue(0)
            ..setAxisMaxValue(1000)
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
        color: Colors.white,
        height: 200,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      print('render modem latency');
      _mainToIsolateStream.send(widget.collection);
      return Container(height: 200, child: LineChart(_controller));
    }
  }
}

class ModemLatencyExpandable extends StatefulWidget {
  List<LineStatsCollection> collection;
  Duration showPeriod;
  bool isEmpty;

  ModemLatencyExpandable({this.isEmpty, this.collection, this.showPeriod});

  @override
  _ModemLatencyExpandable createState() => _ModemLatencyExpandable();
}

class _ModemLatencyExpandable extends State<ModemLatencyExpandable> {
  bool _show = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _show = !_show;
            });
          },
          child: Container(
            // color: Colors.white,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.blueGrey[50], width: 1)),
              color: Colors.white,
            ),
            padding:
                const EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color:
                          _show ? Colors.blueGrey[900] : Colors.blueGrey[800],
                    ),
                    Container(
                      width: 16,
                    ),
                    Text('Modem ping ',
                        style: TextStyle(
                            // color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                _show
                    ? Icon(
                        Icons.arrow_drop_up,
                        color: Colors.blueGrey[600],
                      )
                    : Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blueGrey[600],
                      )
              ],
            ),
          ),
        ),

        //First check for show bool
        //Then check for empty data
        Container(
          child: !_show
              ? null
              : !widget.isEmpty
                  ? ModemLatency(
                      collection: widget.collection,
                      showPeriod: widget.showPeriod)
                  : Container(
                      height: 200,
                      color: Colors.white,
                      child: Center(child: CircularProgressIndicator()),
                    ),
        ),
      ],
    );
  }
}
