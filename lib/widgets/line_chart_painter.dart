import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LineChartPainter extends CustomPainter {
  final Color lineColor;
  final double lineWidth;
  final int absMargin;
  final List<int?> data;
  LineChartPainter(this.data, {this.lineColor = Colors.blueGrey, this.lineWidth = 1, this.absMargin = 1});

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
    final List<int> nonNulls = data.nonNulls.toList();
    if (nonNulls.isEmpty) return;
    final int dataMaxHeight = nonNulls.reduce((value, element) => value > element ? value : element);
    final int dataMinHeight = nonNulls.reduce((value, element) => value < element ? value : element);
    final int maxHeight = dataMaxHeight + absMargin;
    final int minHeight = dataMinHeight - absMargin;

    for (int i = 0; i < data.length - 1; i++) {
      final bool hasValues = data[i] != null && data[i + 1] != null;
      if (!hasValues) continue;
      final bool positiveValues = data[i]! >= 0 && data[i + 1]! >= 0;
      if (!positiveValues) continue;

      final double x1 = i * step;
      final double y1 = _calcFill(minHeight, maxHeight, data[i]!) * size.height;
      final double x2 = (i + 1) * step;
      final double y2 = _calcFill(minHeight, maxHeight, data[i + 1]!) * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _linePaint);
    }
  }

  double _calcFill(num min, num max, num value) => ((value - min) / (max - min)).clamp(0, 1);

  Paint get _linePaint => Paint()
    ..color = lineColor
    ..strokeWidth = lineWidth;
}
