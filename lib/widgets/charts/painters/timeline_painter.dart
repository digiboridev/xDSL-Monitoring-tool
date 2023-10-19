import 'package:flutter/material.dart';
import 'package:xdslmt/utils/formatters.dart';

class TimelinePainter extends CustomPainter {
  final DateTime start;
  final DateTime end;
  final double scale;
  final double offset;
  TimelinePainter({required this.start, required this.end, required this.scale, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    // final paintTime = DateTime.now();

    final paint = Paint()
      ..color = Colors.cyan.shade100
      ..style = PaintingStyle.stroke;
    final int tDiff = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final double scaledOffset = offset * scale;
    final double widthInTime = size.width / tDiff * scale;
    final int startStamp = start.millisecondsSinceEpoch;

    final double baseLine = size.height / 2.5;
    int ceilScale = scale.floor();
    int scaleSteps = 100 * ceilScale;
    int timeSteps = 4 * ceilScale;
    double timeStep = tDiff / timeSteps;

    canvas.clipPath(Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)));

    // Scale steps
    for (int i = 0; i < scaleSteps; i++) {
      final double x = tDiff / scaleSteps * i * widthInTime + scaledOffset;
      final double y = size.height / 8;

      // skip offscreen points render
      if (x < 0 - 20) continue;
      if (x > size.width + 20) continue;

      // draw scale step line
      canvas.drawLine(Offset(x, baseLine + y / 2), Offset(x, baseLine - y / 2), paint);
    }

    // Time steps
    for (int i = 0; i <= timeSteps; i++) {
      final double curTimeStep = timeStep * i;
      final double x = curTimeStep * widthInTime + scaledOffset;
      final double y = size.height / 4;

      // skip offscreen points render
      // + 20px margin to prevent cutting time on the edges
      if (x < 0 - 20) continue;
      if (x > size.width + 20) continue;

      // draw accent scale step line
      canvas.drawLine(Offset(x, baseLine + y / 2), Offset(x, baseLine - y / 2), paint);

      // Make time painter
      final curTimeDate = DateTime.fromMillisecondsSinceEpoch((startStamp + curTimeStep).toInt());
      final timePainter = TextPainter(
        text: TextSpan(
          text: curTimeDate.numhms + '\n' + curTimeDate.numymd,
          style: TextStyle(color: Colors.cyan.shade100, fontSize: 8),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      timePainter.layout();

      // Draw first and last time inside scale bounds
      if (i == 0) {
        timePainter.paint(canvas, Offset(x, y / 2 + baseLine));
        continue;
      }
      if (i == timeSteps) {
        timePainter.paint(canvas, Offset(x - timePainter.width, y / 2 + baseLine));
        continue;
      }

      // Draw time in the middle of the step
      timePainter.paint(canvas, Offset(x - timePainter.width / 2, y / 2 + baseLine));
    }

    // debugPrint('TimelinePainter: ${DateTime.now().difference(paintTime).inMicroseconds}us');
  }

  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    bool sameStart = start == oldDelegate.start;
    bool sameEnd = end == oldDelegate.end;
    bool sameScale = scale == oldDelegate.scale;
    bool sameOffset = offset == oldDelegate.offset;
    return !(sameStart && sameEnd && sameScale && sameOffset);
  }
}
