import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:mp_chart_x/mp/chart/line_chart.dart';
import 'package:mp_chart_x/mp/controller/line_chart_controller.dart';
import 'package:mp_chart_x/mp/core/data/line_data.dart';
import 'package:mp_chart_x/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart_x/mp/core/entry/entry.dart';
import 'package:mp_chart_x/mp/core/enums/mode.dart';
import 'package:mp_chart_x/mp/core/enums/x_axis_position.dart';
import 'package:xdsl_mt/components/my_line_marker.dart';
import 'package:xdsl_mt/components/x_date_formatter.dart';
import 'package:xdsl_mt/models/modemClients/line_stats_collection.dart';

class FECLine extends StatefulWidget {
  final List<LineStatsCollection> collection;
  final Duration? showPeriod;

  const FECLine({super.key, required this.collection, this.showPeriod});

  @override
  State<FECLine> createState() => _SNRMState();
}

class _SNRMState extends State<FECLine> {
  late LineChartController _controller;
  Isolate? _isolateInstance;
  late SendPort _mainToIsolateStream;
  final ReceivePort _isolateToMainStream = ReceivePort();
  bool isSpawned = false;

  @override
  void initState() {
    super.initState();
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

    _isolateInstance = await Isolate.spawn(lineDataComputingIsolate, _isolateToMainStream.sendPort);
  }

  //Kill isolate immediately if is spawned or retry after 1 second
  void killingIsolate() {
    if (_isolateInstance == null) {
      debugPrint('Chart Isolate kill tick');
      Timer(Duration(milliseconds: 100), killingIsolate);
    } else {
      _isolateInstance?.kill();
    }
  }

  //Isolate for computing line data
  //Receives msg with List<LineStatsCollection>
  //Sends LineData for mount
  static void lineDataComputingIsolate(SendPort isolateToMainStream) {
    ReceivePort mainToIsolateStream = ReceivePort();
    isolateToMainStream.send(mainToIsolateStream.sendPort);

    mainToIsolateStream.listen((data) {
      if (data is List<LineStatsCollection>) {
        //Calc diff beteen current and previous values
        List<Map> diff = [];
        for (var i = 1; i < data.length; i++) {
          if (data[i - 1].isErrored) {
            continue;
          }
          DateTime time = data[i].dateTime;

          int upCurr = data[i].upFEC;
          int downCurr = data[i].downFEC;
          int upPrev = data[i - 1].upFEC;
          int downPrev = data[i - 1].downFEC;

          int up = upCurr - upPrev;
          int down = downCurr - downPrev;

          diff.add({'dateTime': time, 'downFEC': (down <= 0) ? 0 : down, 'upFEC': (up <= 0) ? 0 : up});
        }

        // Prepare download FEC set

        List<Entry> downFECValues = [];

        for (var element in diff) {
          downFECValues.add(
            Entry(
              x: element['dateTime'].millisecondsSinceEpoch.toDouble(),
              y: element['downFEC'].toDouble(),
            ),
          );
        }

        // Create a dataset
        LineDataSet downFECSet = LineDataSet(downFECValues, 'FEC Down');

        // Apply setiings
        downFECSet
          // ..setLineWidth(1)
          ..setColor1(Colors.blueGrey.shade600)
          ..setMode(Mode.stepped)
          ..setDrawValues(false)
          ..setDrawFilled(true)
          ..setFillAlpha(200)
          ..setLineWidth(0)
          ..setGradientColor(Colors.blueGrey.shade600, Colors.blueGrey.shade200)
          ..setDrawCircles(false);

        // Prepare upload FEC set

        List<Entry> upFECValues = [];

        for (var element in diff) {
          upFECValues.add(
            Entry(
              x: element['dateTime'].millisecondsSinceEpoch.toDouble(),
              y: element['upFEC'].toDouble(),
            ),
          );
        }

        // Create a dataset
        LineDataSet upFECSet = LineDataSet(upFECValues, 'FEC Up');

        // Apply settings
        upFECSet
          // ..setLineWidth(1)
          ..setColor1(Colors.yellow.shade600)
          ..setMode(Mode.stepped)
          ..setDrawValues(false)
          ..setDrawFilled(true)
          ..setLineWidth(0)
          ..setFillAlpha(200)
          ..setGradientColor(Colors.yellow.shade600, Colors.yellow.shade200)
          ..setDrawCircles(false);

        // Add sets to line data and return
        LineData lineData = LineData.fromList([downFECSet, upFECSet]);
        isolateToMainStream.send(lineData);
      } else {
        debugPrint('[mainToIsolateStream] $data');
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
          ..gridColor = Colors.blueGrey.shade50
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
          ..gridColor = Colors.blueGrey.shade50
          ..drawAxisLine = false
          ..position = XAxisPosition.bottom
          ..setAxisMaxValue(widget.collection.last.dateTime.millisecondsSinceEpoch.toDouble())
          ..setAxisMinValue(widget.collection.first.dateTime.millisecondsSinceEpoch.toDouble())
          ..setValueFormatter(XDateFormater());
        if (widget.showPeriod != null) {
          xAxis.setAxisMinValue(widget.collection.last.dateTime.millisecondsSinceEpoch.toDouble() - widget.showPeriod!.inMilliseconds);
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
      marker: MyLineMarker(textColor: Colors.white, backColor: Colors.blueGrey),
      highlightPerDragEnabled: true,
    );
  }

  //Mount data in controller and update render by setstate
  void _mountLineData(LineData lineData) {
    _controller.data = lineData;
    _controller.state.setStateIfNotDispose();
  }

  // Render
  @override
  Widget build(BuildContext context) {
    //Check for computing isolate spawn
    //After spawn sends is collection for computing

    if (!isSpawned) {
      return Container(
        height: 200,
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      debugPrint('render viewer');
      _mainToIsolateStream.send(widget.collection);
      return SizedBox(
        height: 200,
        child: LineChart(_controller),
      );
    }
  }
}

class FECLineExpandable extends StatefulWidget {
  final List<LineStatsCollection> collection;
  final Duration? showPeriod;
  final bool isEmpty;

  const FECLineExpandable({super.key, required this.isEmpty, required this.collection, this.showPeriod});

  @override
  State<FECLineExpandable> createState() => _FECLineExpandableState();
}

class _FECLineExpandableState extends State<FECLineExpandable> {
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
              border: Border(bottom: BorderSide(color: Colors.blueGrey.shade50, width: 1)),
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color: _show ? Colors.blueGrey.shade900 : Colors.blueGrey.shade800,
                    ),
                    Container(
                      width: 16,
                    ),
                    Text(
                      'RSCorr/FEC',
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                _show
                    ? Icon(
                        Icons.arrow_drop_up,
                        color: Colors.blueGrey.shade600,
                      )
                    : Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blueGrey.shade600,
                      ),
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
                  ? FECLine(collection: widget.collection, showPeriod: widget.showPeriod)
                  : Container(
                      height: 200,
                      color: Colors.white,
                      child: Center(child: Text('No data')),
                    ),
        ),
      ],
    );
  }
}
