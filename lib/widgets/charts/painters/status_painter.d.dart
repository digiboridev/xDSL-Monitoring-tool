import 'package:flutter/material.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/screens/snapshots/components/snapshot_viewer.dart';

@deprecated
class StatusPainter extends CustomPainter {
  final Iterable<TimeStatus> data;
  final double scale;
  final double offset;
  final double scaledOffset;
  final int startStamp;
  final int endStamp;
  final int tDiff;
  final double widthInTime;
  StatusPainter({
    required this.data,
    required this.scale,
    required this.offset,
    required this.scaledOffset,
    required this.startStamp,
    required this.endStamp,
    required this.tDiff,
    required this.widthInTime,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final paintTime = DateTime.now();

    for (int i = 0; i < data.length - 1; i++) {
      final val = data.elementAt(i);
      final next = data.elementAt(i + 1);
      final double halfHeight = size.height / 2;
      final double x = (val.t - startStamp) * widthInTime + scaledOffset;
      final double x2 = (next.t - startStamp) * widthInTime + scaledOffset;

      // skip offscreen points render
      if (x < 0) continue;
      if (x > size.width) continue;

      final paint = Paint()
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke;

      final status = val.s;
      if (status == SampleStatus.samplingError) {
        canvas.drawLine(Offset(x, halfHeight), Offset(x2, halfHeight), paint..color = Colors.red);
      } else if (status == SampleStatus.connectionDown) {
        canvas.drawLine(Offset(x, halfHeight), Offset(x2, halfHeight), paint..color = Colors.black);
      } else {
        canvas.drawLine(Offset(x, halfHeight), Offset(x2, halfHeight), paint..color = Colors.cyan.shade100);
      }
    }

    debugPrint('StatusPainter: ${DateTime.now().difference(paintTime).inMicroseconds}us');
  }
}
