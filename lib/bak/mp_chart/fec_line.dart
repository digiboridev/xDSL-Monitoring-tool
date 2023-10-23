// import 'package:flutter/material.dart';
// import 'package:mp_chart_x/mp/chart/line_chart.dart';
// import 'package:mp_chart_x/mp/controller/line_chart_controller.dart';
// import 'package:mp_chart_x/mp/core/data/line_data.dart';
// import 'package:mp_chart_x/mp/core/data_set/line_data_set.dart';
// import 'package:mp_chart_x/mp/core/entry/entry.dart';
// import 'package:mp_chart_x/mp/core/enums/mode.dart';
// import 'package:mp_chart_x/mp/core/enums/x_axis_position.dart';
// import 'package:xdslmt/components/my_line_marker.dart';
// import 'package:xdslmt/components/x_date_formatter.dart';
// import 'package:xdslmt/data/models/line_stats.dart';

// class FECLine extends StatefulWidget {
//   final List<LineStats> collection;
//   final Duration? showPeriod;

//   const FECLine({super.key, required this.collection, this.showPeriod});

//   @override
//   State<FECLine> createState() => _FECLineState();
// }

// class _FECLineState extends State<FECLine> {
//   late LineChartController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _initController();
//   }

//   // Initialize controller
//   void _initController() {
//     final data = widget.collection;

//     List<(DateTime, double, double)> rdiff = [];

//     for (var i = 1; i < data.length; i++) {
//       DateTime time = data[i].time;

//       int upCurr = data[i].upFEC ?? 0;
//       int downCurr = data[i].downFEC ?? 0;
//       int upPrev = data[i - 1].upFEC ?? 0;
//       int downPrev = data[i - 1].downFEC ?? 0;

//       int up = upCurr - upPrev;
//       int down = downCurr - downPrev;

//       rdiff.add((time, (down <= 0) ? 0 : down.toDouble(), (up <= 0) ? 0 : up.toDouble()));
//     }

//     // Prepare download FEC set

//     List<Entry> downFECValues = [];

//     for (final element in rdiff) {
//       downFECValues.add(
//         Entry(
//           x: element.$1.millisecondsSinceEpoch.toDouble(),
//           y: element.$2,
//         ),
//       );
//     }

//     // Create a dataset
//     LineDataSet downFECSet = LineDataSet(downFECValues, 'FEC Down');

//     // Apply setiings
//     downFECSet
//       // ..setLineWidth(1)
//       ..setColor1(AppColors.blueGrey600)
//       ..setMode(Mode.stepped)
//       ..setDrawValues(false)
//       ..setDrawFilled(true)
//       ..setFillAlpha(200)
//       ..setLineWidth(0)
//       ..setGradientColor(AppColors.blueGrey600, AppColors.blueGrey200)
//       ..setDrawCircles(false);

//     // Prepare upload FEC set

//     List<Entry> upFECValues = [];

//     for (final element in rdiff) {
//       upFECValues.add(
//         Entry(
//           x: element.$1.millisecondsSinceEpoch.toDouble(),
//           y: element.$3,
//         ),
//       );
//     }

//     // Create a dataset
//     LineDataSet upFECSet = LineDataSet(upFECValues, 'FEC Up');

//     // Apply settings
//     upFECSet
//       // ..setLineWidth(1)
//       ..setColor1(Colors.yellow.shade600)
//       ..setMode(Mode.stepped)
//       ..setDrawValues(false)
//       ..setDrawFilled(true)
//       ..setLineWidth(0)
//       ..setFillAlpha(200)
//       ..setGradientColor(Colors.yellow.shade600, Colors.yellow.shade200)
//       ..setDrawCircles(false);

//     // Add sets to line data and return
//     LineData lineData = LineData.fromList([downFECSet, upFECSet]);
//     _controller = LineChartController(
//       axisLeftSettingFunction: (axisLeft, controller) {
//         axisLeft
//           ..drawGridLines = true
//           ..gridColor = Colors.blueGrey.shade50
//           ..drawAxisLine = false
//           ..setAxisMinValue(0)
//           // ..setAxisMaxValue(22)
//           ..spacePercentTop = 40
//           ..drawGridLinesBehindData = true;
//       },
//       axisRightSettingFunction: (axisRight, controller) {
//         axisRight
//           ..enabled = true
//           ..drawGridLines = false
//           ..setAxisMinValue(0)
//           // ..setAxisMaxValue(22)
//           ..spacePercentTop = 40
//           ..drawAxisLine = false;
//       },
//       legendSettingFunction: (legend, controller) {
//         legend.enabled = true;
//       },
//       xAxisSettingFunction: (xAxis, controller) {
//         xAxis
//           ..drawGridLines = true
//           ..gridColor = Colors.blueGrey.shade50
//           ..drawAxisLine = false
//           ..position = XAxisPosition.bottom
//           ..setAxisMaxValue(widget.collection.last.time.millisecondsSinceEpoch.toDouble())
//           ..setAxisMinValue(widget.collection.first.time.millisecondsSinceEpoch.toDouble())
//           ..setValueFormatter(XDateFormater());
//         if (widget.showPeriod != null) {
//           xAxis.setAxisMinValue(widget.collection.last.time.millisecondsSinceEpoch.toDouble() - widget.showPeriod!.inMilliseconds);
//         }
//       },
//       drawGridBackground: false,
//       dragXEnabled: true,
//       dragYEnabled: true,
//       scaleXEnabled: true,
//       scaleYEnabled: false,
//       pinchZoomEnabled: false,
//       highLightPerTapEnabled: true,
//       drawBorders: false,
//       noDataText: 'loading',
//       marker: MyLineMarker(textColor: AppColors.cyan50, backColor: Colors.blueGrey, fontSize: 12),
//       highlightPerDragEnabled: true,
//     );
//     _controller.data = lineData;
//   }

//   // Render
//   @override
//   Widget build(BuildContext context) {
//     return LineChart(_controller);
//   }
// }

// class FECLineExpandable extends StatefulWidget {
//   final List<LineStats> collection;
//   final Duration? showPeriod;

//   const FECLineExpandable({super.key, required this.collection, this.showPeriod});

//   @override
//   State<FECLineExpandable> createState() => _FECLineExpandableState();
// }

// class _FECLineExpandableState extends State<FECLineExpandable> {
//   bool _show = false;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               _show = !_show;
//             });
//           },
//           child: Container(
//             // color: AppColors.cyan50,
//             decoration: BoxDecoration(
//               border: Border(bottom: BorderSide(color: Colors.blueGrey.shade50, width: 1)),
//               color: AppColors.cyan50,
//             ),
//             padding: const EdgeInsets.only(left: 32, top: 16, right: 32, bottom: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.bar_chart,
//                       color: _show ? AppColors.blueGrey900 : AppColors.blueGrey800,
//                     ),
//                     Container(
//                       width: 16,
//                     ),
//                     Text(
//                       'RSCorr/FEC',
//                       style: TextStyle(
//                         // color: AppColors.cyan50,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ],
//                 ),
//                 _show
//                     ? Icon(
//                         Icons.arrow_drop_up,
//                         color: AppColors.blueGrey600,
//                       )
//                     : Icon(
//                         Icons.arrow_drop_down,
//                         color: AppColors.blueGrey600,
//                       ),
//               ],
//             ),
//           ),
//         ),
//         if (_show) ...[
//           if (widget.collection.isEmpty)
//             Container(height: 200, color: AppColors.cyan50, child: Center(child: Text('No data')))
//           else
//             Container(
//               height: 200,
//               color: AppColors.cyan50,
//               padding: const EdgeInsets.all(32),
//               child: FECLine(collection: widget.collection, showPeriod: widget.showPeriod),
//             ),
//         ],
//       ],
//     );
//   }
// }
