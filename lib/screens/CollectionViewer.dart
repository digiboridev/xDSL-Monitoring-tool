import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CollectionViewer extends StatelessWidget {
  int index;
  String cKey;
  List<LineStatsCollection> collection;

  CollectionViewer({this.index, this.cKey, this.collection});

  Widget SNRM(BuildContext context) {
    return SfCartesianChart(

        //Enables trackball
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipSettings: InteractiveTooltip(
              enable: true,
              color: Colors.yellow,
              textStyle: TextStyle(color: Colors.brown[800])),
        ),

        //Enables zoom by time
        zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true, enablePanning: true, zoomMode: ZoomMode.x),

        //Axis setup
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(minimum: 0, maximum: 30),

        //Chart title
        title: ChartTitle(text: 'SNR Margin'),

        //Chart legend
        legend: Legend(isVisible: true, position: LegendPosition.bottom),

        //Series
        series: <ChartSeries<LineStatsCollection, DateTime>>[
          FastLineSeries<LineStatsCollection, DateTime>(
              color: Colors.blueGrey[500],
              name: 'Download SNRM',
              dataSource: collection,
              xValueMapper: (LineStatsCollection sales, _) => sales.dateTime,
              yValueMapper: (LineStatsCollection sales, _) => sales.downMargin,
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: false)),
          FastLineSeries<LineStatsCollection, DateTime>(
              color: Colors.yellow[400],
              name: 'Upload SNRM',
              dataSource: collection,
              xValueMapper: (LineStatsCollection sales, _) => sales.dateTime,
              yValueMapper: (LineStatsCollection sales, _) => sales.upMargin,
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: false)),
        ]);
  }

  Widget FEC(BuildContext context) {
    List calcdif() {
      List<List> calcdif = [];
      for (var i = 1; i < collection.length; i++) {
        DateTime timeCurr = collection[i].dateTime;

        int dFecCurr = collection[i].downFEC ?? 0;
        int dFecPrev = collection[i - 1].downFEC ?? 0;
        int dFecDiff = (dFecCurr - dFecPrev).abs();

        int uFecCurr = collection[i].upFEC ?? 0;
        int uFecPrev = collection[i - 1].upFEC ?? 0;
        int uFecDiff = (uFecCurr - uFecPrev).abs();

        calcdif.add([timeCurr, uFecDiff, dFecDiff]);
      }
      return calcdif;
    }

    return SfCartesianChart(

        //Enables trackball
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipSettings: InteractiveTooltip(
              enable: true,
              color: Colors.yellow,
              textStyle: TextStyle(color: Colors.brown[800])),
        ),

        //Enables zoom by time
        zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true, enablePanning: true, zoomMode: ZoomMode.x),

        //Axis setup
        primaryXAxis: DateTimeAxis(),

        //Chart title
        title: ChartTitle(text: 'Forward error correction / RS Corr'),

        //Chart legend
        legend: Legend(isVisible: true, position: LegendPosition.bottom),

        //Series
        series: <ChartSeries<List, DateTime>>[
          FastLineSeries<List, DateTime>(
              color: Colors.blueGrey[400],
              name: 'Download FEC',
              dataSource: calcdif(),
              xValueMapper: (List sales, _) => sales[0],
              yValueMapper: (List sales, _) => sales[2],
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: false)),
          FastLineSeries<List, DateTime>(
              color: Colors.yellow[400],
              name: 'Upload FEC',
              dataSource: calcdif(),
              xValueMapper: (List sales, _) => sales[0],
              yValueMapper: (List sales, _) => sales[1],
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: false)),
        ]);
  }

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
            child: SNRM(context),
          ),
          Container(
            height: 200,
            child: FEC(context),
          ),
        ],
      ),
    );
  }
}
