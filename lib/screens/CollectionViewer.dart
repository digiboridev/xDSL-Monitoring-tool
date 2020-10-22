import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';
import 'package:mp_chart/mp_chart.dart';

class CollectionViewer extends StatelessWidget {
  int index;
  String cKey;
  List<LineStatsCollection> collection;

  CollectionViewer({this.index, this.cKey, this.collection});

  @override
  Widget build(BuildContext context) {
    print('render');

    return Scaffold(
      appBar: AppBar(
        title: Text('Charts ' + cKey),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: ListView(
        children: [
          Container(
            height: 200,
            child: MPchart(
              collection: collection,
            ),
          ),
        ],
      ),
    );
  }
}

class MPchart extends StatefulWidget {
  List<LineStatsCollection> collection;

  MPchart({this.collection});

  @override
  _MPchartState createState() => _MPchartState();
}

class _MPchartState extends State<MPchart> {
  LineChartController _controller;

  void initState() {
    _initController();
    _initLineData(widget.collection);
  }

  void _initController() {
    var desc = Description()..enabled = false;
    _controller = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft.drawGridLines = (false);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = (false);
        },
        legendSettingFunction: (legend, controller) {
          legend.enabled = (false);
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..drawGridLines = (true)
            ..drawAxisLine = (false)
            ..setValueFormatter(Formater());
        },
        drawGridBackground: true,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        pinchZoomEnabled: false,
        description: desc);
  }

  static LineDataSet prepareDownMargin(List<LineStatsCollection> collection) {
    List<Entry> values = List();

    collection.forEach((element) {
      values.add(new Entry(
          x: element.dateTime.millisecondsSinceEpoch.toDouble(),
          y: element.downMargin ?? 0));
    });

    // create a dataset and give it a type
    LineDataSet set = new LineDataSet(values, "DataSet 1");
    return set;
  }

  static LineDataSet prepareUpMargin(List<LineStatsCollection> collection) {
    List<Entry> values = List();

    collection.forEach((element) {
      values.add(new Entry(
          x: element.dateTime.millisecondsSinceEpoch.toDouble(),
          y: element.upMargin ?? 0));
    });

    // create a dataset and give it a type
    LineDataSet set = new LineDataSet(values, "DataSet 1");
    return set;
  }

  void _initLineData(List<LineStatsCollection> collection) {
    Future<LineDataSet> downMarginSet = compute(prepareDownMargin, collection);
    Future<LineDataSet> upMarginSet = compute(prepareUpMargin, collection);

    downMarginSet.then((downMarginSet) => {
          downMarginSet
            ..setColor1(Colors.blueGrey[600])
            ..setLineWidth(1)
            ..setDrawValues(false)
            ..setDrawCircles(false)
            ..setMode(Mode.LINEAR),
          _controller.data == null
              ? _controller.data = LineData.fromList(List()..add(downMarginSet))
              : _controller.data.addDataSet(downMarginSet),
          _controller.state?.setStateIfNotDispose()
        });

    upMarginSet.then((upMarginSet) => {
          upMarginSet
            ..setColor1(Colors.yellow[600])
            ..setLineWidth(1)
            ..setDrawValues(false)
            ..setDrawCircles(false)
            ..setMode(Mode.LINEAR),
          _controller.data == null
              ? _controller.data = LineData.fromList(List()..add(upMarginSet))
              : _controller.data.addDataSet(upMarginSet),
          _controller.state?.setStateIfNotDispose()
        });
  }

  @override
  Widget build(BuildContext context) {
    print('render viewer');
    return Container(
      child: LineChart(_controller),
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
