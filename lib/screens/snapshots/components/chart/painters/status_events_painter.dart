import 'package:flutter/material.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/screens/snapshots/components/chart/path_factory.dart';

class StatusEventsPainter extends CustomPainter {
  final Iterable<({int t, SampleStatus s})> data;
  final double scale;
  final double offset;
  final String key;
  StatusEventsPainter({required this.data, required this.scale, required this.offset, required this.key});

  static final Paint pu = Paint()
    ..colorFilter = ColorFilter.mode(Colors.cyan.shade100, BlendMode.srcOver)
    ..style = PaintingStyle.stroke;
  static final Paint pd = Paint()
    ..colorFilter = ColorFilter.mode(Colors.black, BlendMode.srcOver)
    ..style = PaintingStyle.stroke;
  static final Paint pe = Paint()
    ..colorFilter = ColorFilter.mode(Colors.red, BlendMode.srcOver)
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    // final paintStart = DateTime.now();

    // Create data path
    final dataPath = PathFactory.makeStatusLinePath(data, size, '$key ${size.width}');

    // Draw data
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset, 0.0);
    canvas.transform(displayMatrix.storage);
    canvas.drawPath(dataPath.u, pu);
    canvas.drawPath(dataPath.d, pd);
    canvas.drawPath(dataPath.e, pe);

    // Debug
    // final paintEnd = DateTime.now();
    // debugPrint('StatusEventsPainter: ${paintEnd.difference(paintStart).inMicroseconds}us');
  }

  @override
  bool shouldRepaint(StatusEventsPainter oldDelegate) {
    bool sameData = data.length == oldDelegate.data.length;
    bool sameScale = scale == oldDelegate.scale;
    bool sameOffset = offset == oldDelegate.offset;
    bool sameKey = key == oldDelegate.key;
    return !(sameData && sameScale && sameOffset && sameKey);
  }
}
