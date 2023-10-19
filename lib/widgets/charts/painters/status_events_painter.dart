import 'package:flutter/material.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/widgets/charts/path_factory.dart';

class StatusEventsPainter extends CustomPainter {
  final Iterable<({int t, SampleStatus s})> data;
  final double scale;
  final double offset;
  final String key;
  StatusEventsPainter({required this.data, required this.scale, required this.offset, required this.key});

  Paint get p => Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    final paintStart = DateTime.now();

    // Create data path
    final dataPath = PathFactory.makeStatusLinePath(data, key);

    // Draw data
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(size.width, size.height);
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset / size.width, 0.0);
    canvas.clipPath(Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.transform(displayMatrix.storage);
    canvas.drawPath(dataPath.u, p..color = Colors.cyan.shade100);
    canvas.drawPath(dataPath.d, p..color = Colors.black);
    canvas.drawPath(dataPath.e, p..color = Colors.red);

    // Debug
    final paintEnd = DateTime.now();
    debugPrint('StatusEventsPainter: ${paintEnd.difference(paintStart).inMicroseconds}us');
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
