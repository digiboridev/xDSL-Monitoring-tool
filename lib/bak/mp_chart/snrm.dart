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

// class SNRM extends StatefulWidget {
//   final List<LineStats> collection;
//   final Duration? showPeriod;

//   const SNRM({super.key, required this.collection, this.showPeriod});

//   @override
//   State<SNRM> createState() => _SNRMState();
// }

// class _SNRMState extends State<SNRM> {
//   late LineChartController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _initController();
//   }

//   // Initialize controller
//   void _initController() {
//     List<Entry> downMarginValues = [];

//     for (var element in widget.collection) {
//       downMarginValues.add(
//         Entry(
//           x: element.time.millisecondsSinceEpoch.toDouble(),
//           y: (element.downMargin ?? 0).toDouble(),
//         ),
//       );
//     }

//     // Create a dataset
//     LineDataSet downMarginSet = LineDataSet(downMarginValues, 'SNRM Down');

//     // Apply setiings
//     downMarginSet
//       // ..setLineWidth(1)
//       ..setColor1(AppColors.blueGrey600)
//       ..setMode(Mode.stepped)
//       ..setDrawValues(false)
//       ..setDrawCircles(false);

//     // Prepare upload margin set

//     List<Entry> upMarginValues = [];

//     for (var element in widget.collection) {
//       upMarginValues.add(
//         Entry(
//           x: element.time.millisecondsSinceEpoch.toDouble(),
//           y: (element.upMargin ?? 0).toDouble(),
//         ),
//       );
//     }

//     // Create a dataset
//     LineDataSet upMarginSet = LineDataSet(upMarginValues, 'SNRM Up');

//     // Apply settings
//     upMarginSet
//       // ..setLineWidth(1)
//       ..setColor1(Colors.yellow.shade600)
//       ..setMode(Mode.stepped)
//       ..setDrawValues(false)
//       ..setDrawCircles(false);

//     // Prepare errors set
//     List<Entry> connectionErrValues = [];

//     for (var element in widget.collection) {
//       connectionErrValues.add(
//         Entry(
//           x: element.time.millisecondsSinceEpoch.toDouble(),
//           y: element.status == SampleStatus.samplingError ? 32 : 0,
//         ),
//       );
//     }

//     // Create a dataset
//     LineDataSet connectionErrSet = LineDataSet(connectionErrValues, 'Data error');

//     // Apply settings
//     connectionErrSet
//       ..setColor1(Colors.red.shade200)
//       ..setLineWidth(0)
//       ..setDrawFilled(true)
//       ..setFillAlpha(255)
//       ..setHighlightEnabled(false)
//       ..setFillColor(Colors.red.shade200)
//       ..setDrawValues(false)
//       ..setDrawCircles(false)
//       ..setMode(Mode.stepped);

//     // Add sets to line data and return
//     LineData lineData = LineData.fromList([downMarginSet, upMarginSet, connectionErrSet]);

//     _controller = LineChartController(
//       axisLeftSettingFunction: (axisLeft, controller) {
//         axisLeft
//           ..drawGridLines = true
//           ..gridColor = Colors.blueGrey.shade50
//           ..drawAxisLine = false
//           ..setAxisMinValue(0)
//           ..setAxisMaxValue(32)
//           // ..spacePercentTop = 40
//           ..drawGridLinesBehindData = true;
//       },
//       axisRightSettingFunction: (axisRight, controller) {
//         axisRight
//           ..enabled = true
//           ..drawGridLines = false
//           ..setAxisMinValue(0)
//           ..setAxisMaxValue(32)
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
//       marker: MyLineMarker(textColor: AppColors.cyan50, backColor: Colors.blueGrey),
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

// class SNRMExpandable extends StatefulWidget {
//   final List<LineStats> collection;
//   final Duration? showPeriod;

//   const SNRMExpandable({super.key, required this.collection, this.showPeriod});

//   @override
//   State<SNRMExpandable> createState() => _SNRMExpandableState();
// }

// class _SNRMExpandableState extends State<SNRMExpandable> {
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
//                       'Signal to noise margin',
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
//               child: SNRM(collection: widget.collection, showPeriod: widget.showPeriod),
//             ),
//         ],
//       ],
//     );
//   }
// }
