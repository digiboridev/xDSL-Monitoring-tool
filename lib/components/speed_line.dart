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
import 'package:xdslmt/data/models/line_stats.dart';

class SpeedLine extends StatefulWidget {
  final List<LineStats> statsList;
  final Duration? showPeriod;

  const SpeedLine({super.key, required this.statsList, this.showPeriod});

  @override
  State<SpeedLine> createState() => _SNRMState();
}

class _SNRMState extends State<SpeedLine> {
  late LineChartController _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  // Initialize controller
  void _initController() {
    // Prepare download rate set

    List<Entry> downRateValues = [];

    for (var element in widget.statsList) {
      downRateValues.add(
        Entry(
          x: element.time.millisecondsSinceEpoch.toDouble(),
          y: element.downRate?.toDouble() ?? 0,
        ),
      );
    }

    // Create a dataset
    LineDataSet downRateSet = LineDataSet(downRateValues, 'Down');

    // Apply setiings
    downRateSet
      // ..setLineWidth(1)
      ..setColor1(Colors.blueGrey.shade600)
      ..setMode(Mode.stepped)
      ..setDrawValues(false)
      ..setDrawCircles(false);

    // Prepare upload rate set

    List<Entry> upRateValues = [];

    for (var element in widget.statsList) {
      upRateValues.add(
        Entry(
          x: element.time.millisecondsSinceEpoch.toDouble(),
          y: element.upRate?.toDouble() ?? 0,
        ),
      );
    }

    // Create a dataset
    LineDataSet upRateSet = LineDataSet(upRateValues, 'Up');

    // Apply settings
    upRateSet
      // ..setLineWidth(1)
      ..setColor1(Colors.yellow.shade600)
      ..setMode(Mode.stepped)
      ..setDrawValues(false)
      ..setDrawCircles(false);

// Prepare download max rate set

    List<Entry> downMaxRateValues = [];

    for (var element in widget.statsList) {
      downMaxRateValues.add(
        Entry(
          x: element.time.millisecondsSinceEpoch.toDouble(),
          y: element.downAttainableRate?.toDouble() ?? 0,
        ),
      );
    }

    // Create a dataset
    LineDataSet downMaxRateSet = LineDataSet(downMaxRateValues, 'Max down');

    // Apply setiings
    downMaxRateSet
      // ..setLineWidth(1)
      ..setColor1(Colors.blueGrey.shade900)
      ..setMode(Mode.stepped)
      ..setDrawValues(false)
      ..setDrawCircles(false);

    // Prepare upload max rate set

    List<Entry> upMaxRateValues = [];

    for (var element in widget.statsList) {
      upMaxRateValues.add(
        Entry(
          x: element.time.millisecondsSinceEpoch.toDouble(),
          y: element.upAttainableRate?.toDouble() ?? 0,
        ),
      );
    }

    // Create a dataset
    LineDataSet upMaxRateSet = LineDataSet(upMaxRateValues, 'Max up');

    // Apply settings
    upMaxRateSet
      // ..setLineWidth(1)
      ..setColor1(Colors.yellow.shade900)
      ..setMode(Mode.stepped)
      ..setDrawValues(false)
      ..setDrawCircles(false);
    // Prepare errors set
    List<Entry> connectionErrValues = [];

    for (var element in widget.statsList) {
      connectionErrValues.add(
        Entry(
          x: element.time.millisecondsSinceEpoch.toDouble(),
          y: element.status == SampleStatus.samplingError ? 24000 : 0,
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
    LineData lineData = LineData.fromList([
      downRateSet,
      upRateSet,
      downMaxRateSet,
      upMaxRateSet,
      connectionErrSet,
    ]);

    _controller = LineChartController(
      customViewPortEnabled: true,
      axisLeftSettingFunction: (axisLeft, controller) {
        axisLeft
          ..drawGridLines = true
          ..gridColor = Colors.blueGrey.shade50
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
          ..gridColor = Colors.blueGrey.shade50
          ..drawAxisLine = false
          ..position = XAxisPosition.bottom
          ..setAxisMaxValue(widget.statsList.last.time.millisecondsSinceEpoch.toDouble())
          ..setAxisMinValue(widget.statsList.first.time.millisecondsSinceEpoch.toDouble())
          ..setValueFormatter(XDateFormater());

        if (widget.showPeriod != null) {
          xAxis.setAxisMinValue(
            widget.statsList.last.time.millisecondsSinceEpoch.toDouble() - widget.showPeriod!.inMilliseconds,
          );
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

    _controller.data = lineData;
  }

  // Render
  @override
  Widget build(BuildContext context) {
    return LineChart(_controller);
  }
}

class SpeedLineExpandable extends StatefulWidget {
  final List<LineStats> statsList;
  final Duration? showPeriod;

  const SpeedLineExpandable({super.key, required this.statsList, this.showPeriod});

  @override
  State<SpeedLineExpandable> createState() => _SpeedLineExpandableState();
}

class _SpeedLineExpandableState extends State<SpeedLineExpandable> {
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
                      'Speed rates line ',
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
        if (_show) ...[
          if (widget.statsList.isEmpty)
            Container(height: 200, color: Colors.white, child: Center(child: Text('No data')))
          else
            Container(
              height: 200,
              color: Colors.white,
              padding: const EdgeInsets.all(32),
              child: SpeedLine(statsList: widget.statsList, showPeriod: widget.showPeriod),
            ),
        ],
      ],
    );
  }
}
