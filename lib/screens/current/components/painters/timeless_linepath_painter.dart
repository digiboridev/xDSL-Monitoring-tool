import 'package:flutter/material.dart';

class TimelessLinePathPainter extends CustomPainter {
  final List<int?> data;
  final bool invert;
  TimelessLinePathPainter(this.data, this.invert);

  Paint get _linePaint => Paint()
    ..color = Colors.blueGrey.shade800
    ..strokeWidth = 1;
  Paint get _meshPaint => Paint()
    ..color = Colors.blueGrey.shade100
    ..strokeWidth = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw mesh
    final double hmstep = size.width / 7;
    for (int i = 0; i < 6; i++) {
      final double x = i * hmstep + hmstep;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _meshPaint);
    }
    final double vmstep = size.height / 3;
    for (int i = 0; i < 4; i++) {
      final double y = i * vmstep;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), _meshPaint);
    }

    // Draw data
    final List<int> nonNulls = data.nonNulls.toList();
    if (nonNulls.isEmpty) return;
    final double step = size.width / data.length;
    final int max = nonNulls.reduce((value, element) => value > element ? value : element);
    final int min = nonNulls.reduce((value, element) => value < element ? value : element);

    for (int i = 0; i < data.length - 1; i++) {
      final val1 = data[i];
      final val2 = data[i + 1];
      final bool validPair = _validPair(val1, val2);
      if (!validPair) continue;

      final double x1 = i * step;
      final double scale1 = _calcScale(min, max, val1!);
      final double y1 = invert ? scale1 * size.height : size.height - scale1 * size.height;

      final double x2 = (i + 1) * step;
      final double scale2 = _calcScale(min, max, val2!);
      final double y2 = invert ? scale2 * size.height : size.height - scale2 * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _linePaint);
    }
  }

  bool _validPair(int? a, int? b) => a != null && b != null && a >= 0 && b >= 0;
  double _calcScale(num min, num max, num value) => ((value - min) / (max - min)).clamp(0, 1);

  @override
  bool shouldRepaint(TimelessLinePathPainter oldDelegate) => true;
}
