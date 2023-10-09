import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  final Color lineColor;
  final double lineWidth;
  final double absMargin;
  final List<double?> data;
  LineChartPainter(this.data, {this.lineColor = Colors.blueGrey, this.lineWidth = 1, this.absMargin = 0.1});

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return !listEquals(data, oldDelegate.data);
  }

  @override
  bool shouldRebuildSemantics(LineChartPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final double step = size.width / data.length;
    final List<double> nonNulls = data.nonNulls.toList();
    if (nonNulls.isEmpty) return;
    final double dataMaxHeight = nonNulls.reduce((value, element) => value > element ? value : element);
    final double dataMinHeight = nonNulls.reduce((value, element) => value < element ? value : element);
    final double maxHeight = dataMaxHeight + absMargin;
    final double minHeight = dataMinHeight - absMargin;

    for (int i = 0; i < data.length - 1; i++) {
      final bool hasValues = data[i] != null && data[i + 1] != null;
      if (!hasValues) continue;
      final bool positiveValues = data[i]! >= 0 && data[i + 1]! >= 0;
      if (!positiveValues) continue;

      final double x1 = i * step;
      final double y1 = size.height - ((data[i]! - minHeight) / (maxHeight - minHeight)) * size.height;
      final double x2 = (i + 1) * step;
      final double y2 = size.height - ((data[i + 1]! - minHeight) / (maxHeight - minHeight)) * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _linePaint);
    }
  }

  Paint get _linePaint => Paint()
    ..color = lineColor
    ..strokeWidth = lineWidth;
}
