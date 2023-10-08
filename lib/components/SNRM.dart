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
import 'package:xdslmt/components/my_line_marker.dart';
import 'package:xdslmt/components/x_date_formatter.dart';
import 'package:xdslmt/bak/modemClients/line_stats_collection.dart';

class SNRM extends StatefulWidget {
  final List<LineStatsCollection> collection;
  final Duration? showPeriod;

  const SNRM({super.key, required this.collection, this.showPeriod});

  @override
  State<SNRM> createState() => _SNRMState();
}

class _SNRMState extends State<SNRM> {
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
        // Prepare download margin set

        List<Entry> downMarginValues = [];

        for (var element in data) {
          downMarginValues.add(
            Entry(
              x: element.dateTime.millisecondsSinceEpoch.toDouble(),
              y: element.downMargin,
            ),
          );
        }

        // Create a dataset
        LineDataSet downMarginSet = LineDataSet(downMarginValues, 'SNRM Down');

        // Apply setiings
        downMarginSet
          // ..setLineWidth(1)
          ..setColor1(Colors.blueGrey.shade600)
          ..setMode(Mode.stepped)
          ..setDrawValues(false)
          ..setDrawCircles(false);

        // Prepare upload margin set

        List<Entry> upMarginValues = [];

        for (var element in data) {
          upMarginValues.add(
            Entry(
              x: element.dateTime.millisecondsSinceEpoch.toDouble(),
              y: element.upMargin,
            ),
          );
        }

        // Create a dataset
        LineDataSet upMarginSet = LineDataSet(upMarginValues, 'SNRM Up');

        // Apply settings
        upMarginSet
          // ..setLineWidth(1)
          ..setColor1(Colors.yellow.shade600)
          ..setMode(Mode.stepped)
          ..setDrawValues(false)
          ..setDrawCircles(false);

        // Prepare errors set
        List<Entry> connectionErrValues = [];

        for (var element in data) {
          connectionErrValues.add(
            Entry(
              x: element.dateTime.millisecondsSinceEpoch.toDouble(),
              y: element.isErrored ? 32 : 0,
            ),
          );
        }

        // Create a dataset
        LineDataSet connectionErrSet = LineDataSet(connectionErrValues, 'Data error');

        // Apply settings
        connectionErrSet
          ..setColor1(Colors.red.shade200)
          ..setLineWidth(0)
          ..setDrawFilled(true)
          ..setFillAlpha(255)
          ..setHighlightEnabled(false)
          ..setFillColor(Colors.red.shade200)
          ..setDrawValues(false)
          ..setDrawCircles(false)
          ..setMode(Mode.stepped);

        // Add sets to line data and return
        LineData lineData = LineData.fromList([downMarginSet, upMarginSet, connectionErrSet]);
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
          ..setAxisMaxValue(32)
          // ..spacePercentTop = 40
          ..drawGridLinesBehindData = true;
      },
      axisRightSettingFunction: (axisRight, controller) {
        axisRight
          ..enabled = true
          ..drawGridLines = false
          ..setAxisMinValue(0)
          ..setAxisMaxValue(32)
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

class SNRMExpandable extends StatefulWidget {
  final List<LineStatsCollection> collection;
  final Duration? showPeriod;
  final bool isEmpty;

  const SNRMExpandable({super.key, required this.isEmpty, required this.collection, this.showPeriod});

  @override
  State<SNRMExpandable> createState() => _SNRMExpandableState();
}

class _SNRMExpandableState extends State<SNRMExpandable> {
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
                      'Signal to noise margin',
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
                  ? SNRM(collection: widget.collection, showPeriod: widget.showPeriod)
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
