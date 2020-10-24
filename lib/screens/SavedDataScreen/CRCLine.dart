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

class CRCLine extends StatefulWidget {
  List<LineStatsCollection> collection;

  CRCLine({this.collection});

  @override
  _SNRMState createState() => _SNRMState();
}

class _SNRMState extends State<CRCLine> {
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
            // ..setAxisMinValue(0)
            // ..setAxisMaxValue(22)
            ..spacePercentTop = 40
            ..drawGridLinesBehindData = true;
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight
            ..enabled = true
            ..drawGridLines = false
            // ..setAxisMinValue(0)
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
    // Calc positive difference beetween last and current value

    List<Map> diff = [];
    for (var i = 1; i < collection.length; i++) {
      if (collection[i - 1].isErrored) {
        continue;
      }
      DateTime time = collection[i].dateTime;

      int upCurr = collection[i].upCRC ?? 0;
      int downCurr = collection[i].downCRC ?? 0;
      int upPrev = collection[i - 1].upCRC ?? 0;
      int downPrev = collection[i - 1].downCRC ?? 0;

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
      ..setDrawCircles(false);

    // Add sets to line data and return
    LineData lineData =
        LineData.fromList(List()..add(downCRCSet)..add(upCRCSet));
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
          child: Text('Cyclic redundancy check / RS Corr'),
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
