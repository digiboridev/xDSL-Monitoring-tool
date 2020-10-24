import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/axis/axis_base.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';

class SpeedLine extends StatefulWidget {
  List<LineStatsCollection> collection;

  SpeedLine({this.collection});

  @override
  _SNRMState createState() => _SNRMState();
}

class _SNRMState extends State<SpeedLine> {
  LineChartController _controller;

  void initState() {
    _initController();
    _initLineData(widget.collection);
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
            ..setAxisMaxValue(24000)
            // ..spacePercentTop = 40
            ..drawGridLinesBehindData = true;
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight
            ..enabled = true
            ..drawGridLines = false
            ..setAxisMinValue(0)
            ..setAxisMaxValue(24000)
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
            ..setValueFormatter(Formater());
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
        highlightPerDragEnabled: true);
  }

  // Precompute datasets in Isolate
  static LineData _computeData(List<LineStatsCollection> collection) {
    // Prepare download rate set

    List<Entry> downRateValues = List();

    collection.forEach((element) {
      downRateValues.add(new Entry(
          x: element.dateTime.millisecondsSinceEpoch.toDouble(),
          y: element.downRate?.toDouble() ?? 0));
    });

    // Create a dataset
    LineDataSet downRateSet = new LineDataSet(downRateValues, "Down");

    // Apply setiings
    downRateSet
      // ..setLineWidth(1)
      ..setColor1(Colors.blueGrey[600])
      ..setMode(Mode.STEPPED)
      ..setDrawValues(false)
      ..setDrawCircles(false);

    // Prepare upload rate set

    List<Entry> upRateValues = List();

    collection.forEach((element) {
      upRateValues.add(new Entry(
          x: element.dateTime.millisecondsSinceEpoch.toDouble(),
          y: element.upRate?.toDouble() ?? 0));
    });

    // Create a dataset
    LineDataSet upRateSet = new LineDataSet(upRateValues, "Up");

    // Apply settings
    upRateSet
      // ..setLineWidth(1)
      ..setColor1(Colors.yellow[600])
      ..setMode(Mode.STEPPED)
      ..setDrawValues(false)
      ..setDrawCircles(false);

// Prepare download max rate set

    List<Entry> downMaxRateValues = List();

    collection.forEach((element) {
      downMaxRateValues.add(new Entry(
          x: element.dateTime.millisecondsSinceEpoch.toDouble(),
          y: element.downMaxRate?.toDouble() ?? 0));
    });

    // Create a dataset
    LineDataSet downMaxRateSet = new LineDataSet(downMaxRateValues, "Max down");

    // Apply setiings
    downMaxRateSet
      // ..setLineWidth(1)
      ..setColor1(Colors.blueGrey[200])
      ..setMode(Mode.STEPPED)
      ..setDrawValues(false)
      ..setDrawCircles(false);

    // Prepare upload max rate set

    List<Entry> upMaxRateValues = List();

    collection.forEach((element) {
      upMaxRateValues.add(new Entry(
          x: element.dateTime.millisecondsSinceEpoch.toDouble(),
          y: element.upMaxRate?.toDouble() ?? 0));
    });

    // Create a dataset
    LineDataSet upMaxRateSet = new LineDataSet(upMaxRateValues, "Max up");

    // Apply settings
    upMaxRateSet
      // ..setLineWidth(1)
      ..setColor1(Colors.yellow[200])
      ..setMode(Mode.STEPPED)
      ..setDrawValues(false)
      ..setDrawCircles(false);
    // Prepare errors set
    List<Entry> connectionErrValues = List();

    collection.forEach((element) {
      connectionErrValues.add(new Entry(
          x: element.dateTime.millisecondsSinceEpoch.toDouble(),
          y: element.isErrored ? 24000 : 0));
    });

    // Create a dataset
    LineDataSet connectionErrSet =
        new LineDataSet(connectionErrValues, "Data error");

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
    LineData lineData = LineData.fromList(List()
      ..add(downRateSet)
      ..add(upRateSet)
      ..add(downMaxRateSet)
      ..add(upMaxRateSet)
      ..add(connectionErrSet));
    return lineData;
  }

  // Initialize linedata
  void _initLineData(List<LineStatsCollection> collection) async {
    LineData lineData = await compute(_computeData, collection);
    _controller.data = lineData;
    _controller.state?.setStateIfNotDispose();
  }

  // Render
  @override
  Widget build(BuildContext context) {
    print('render viewer');
    return Column(
      children: [
        Container(
            color: Colors.amber, height: 200, child: LineChart(_controller)),
        Transform.translate(
          offset: const Offset(0, -190),
          child: Text('Speed rates'),
        ),
      ],
    );
  }
}

class Formater extends ValueFormatter {
  final intl.DateFormat mFormat = intl.DateFormat("HH:mm");

  @override
  String getFormattedValue1(double value) {
    return mFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
  }
}
