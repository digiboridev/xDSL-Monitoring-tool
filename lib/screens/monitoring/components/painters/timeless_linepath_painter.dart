import 'package:flutter/material.dart';
import 'package:xdslmt/core/colors.dart';

class TimelessLinePathPainter extends CustomPainter {
  TimelessLinePathPainter(this.data, this.min, this.max, this.invert);

  final Iterable<int?> data;
  final int min;
  final int max;
  final bool invert;

  static final _linePaint = Paint()
    ..color = AppColors.blueGrey800
    ..strokeWidth = 1;
  static final _meshPaint = Paint()
    ..color = AppColors.blueGrey100
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
    final double step = size.width / data.length;

    for (int i = 0; i < data.length - 1; i++) {
      final val1 = data.elementAt(i);
      final val2 = data.elementAt(i + 1);
      if (val1 == null) continue;
      if (val2 == null) continue;

      final double x1 = i * step;
      final double scale1 = _calcScale(min, max, val1);
      final double y1 = invert ? scale1 * size.height : size.height - scale1 * size.height;

      final double x2 = (i + 1) * step;
      final double scale2 = _calcScale(min, max, val2);
      final double y2 = invert ? scale2 * size.height : size.height - scale2 * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), _linePaint);
    }
  }

  double _calcScale(num min, num max, num value) => ((value - min) / (max - min)).clamp(0, 1);

  @override
  bool shouldRepaint(TimelessLinePathPainter oldDelegate) => true;
}
