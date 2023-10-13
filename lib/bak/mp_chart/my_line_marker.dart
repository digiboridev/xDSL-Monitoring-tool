// import 'package:flutter/material.dart';
// import 'package:mp_chart_x/mp/core/entry/entry.dart';
// import 'package:mp_chart_x/mp/core/highlight/highlight.dart';
// import 'package:mp_chart_x/mp/core/marker/line_chart_marker.dart';
// import 'package:mp_chart_x/mp/core/pool/point.dart';
// import 'package:mp_chart_x/mp/core/utils/painter_utils.dart';
// import 'package:mp_chart_x/mp/core/value_formatter/default_value_formatter.dart';

// class MyLineMarker extends LineChartMarker {
//   Entry? _entry;

//   final double _dx = 20.0;
//   final double _dy = 0.0;

//   final DefaultValueFormatter _formatter = DefaultValueFormatter(0);
//   final Color textColor;
//   final Color backColor;
//   final double fontSize;

//   MyLineMarker({required this.textColor, required this.backColor, this.fontSize = 10});

//   @override
//   void draw(Canvas canvas, double posX, double posY) {
//     if (_entry == null) {
//       debugPrint('No entry provided.');
//       return;
//     }

//     TextPainter painter = PainterUtils.create(null, _formatter.getFormattedValue1(_entry!.y), textColor, fontSize);
//     Paint paint = Paint()
//       ..color = backColor
//       ..strokeWidth = 2
//       ..isAntiAlias = true
//       ..style = PaintingStyle.fill;

//     MPPointF offset = getOffsetForDrawingAtPoint(posX, posY);

//     canvas.save();
//     // translate to the correct position and draw
//     canvas.translate(offset.x, offset.y);
//     painter.layout();
//     Offset pos = calculatePos(posX + offset.x, posY + offset.y, painter.width, painter.height);
//     canvas.drawRRect(RRect.fromLTRBR(pos.dx - 5, pos.dy - 5, pos.dx + painter.width + 5, pos.dy + painter.height + 5, Radius.circular(5)), paint);
//     painter.paint(canvas, pos);
//     canvas.restore();
//   }

//   @override
//   Offset calculatePos(double posX, double posY, double textW, double textH) {
//     return Offset(posX - textW / 2, posY - textH / 2);
//   }

//   @override
//   MPPointF getOffset() {
//     return MPPointF.getInstance1(_dx, _dy);
//   }

//   @override
//   MPPointF getOffsetForDrawingAtPoint(double posX, double posY) {
//     return getOffset();
//   }

//   @override
//   void refreshContent(Entry e, Highlight highlight) {
//     _entry = e;
//     highlight = highlight;
//   }
// }
