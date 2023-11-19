import 'package:flutter/material.dart';
import 'package:xdslmt/screens/snapshots/components/chart/path_factory.dart';
import 'package:xdslmt/core/colors.dart';

@Deprecated('alternative implementation')
class RSCPainter extends CustomPainter {
  final Iterable<TimeValue> data;
  final double scale;
  final double offset;
  final double scaledOffset;
  final int startStamp;
  final int endStamp;
  final int tDiff;
  final double widthInTime;
  RSCPainter({
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
    if (data.isEmpty) return;

    final paintTime = DateTime.now();

    final paint = Paint()
      ..color = AppColors.cyan100.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double halfHeight = size.height / 2;
    final lineStart = Offset(offset * scale, halfHeight);
    final lineEnd = Offset(offset * scale + size.width * scale, halfHeight);
    canvas.drawLine(lineStart, lineEnd, paint);

    int maxH = 1000;
    for (int i = 0; i < data.length - 1; i++) {
      final val = data.elementAt(i);

      if (val.v == null) continue;

      final double x = (val.t - startStamp) * widthInTime + scaledOffset;
      final double y = (val.v! / maxH).clamp(0, 1) * size.height;

      // skip offscreen points render
      if (x < 0) continue;
      if (x > size.width) continue;

      // draw line
      canvas.drawLine(Offset(x, halfHeight + y / 2), Offset(x, halfHeight - y / 2), paint);
    }

    debugPrint('RSCPainter: ${DateTime.now().difference(paintTime).inMicroseconds}us');
  }
}
