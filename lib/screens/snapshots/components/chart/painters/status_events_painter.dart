import 'package:flutter/material.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/screens/snapshots/components/chart/path_factory.dart';
import 'package:xdslmt/core/colors.dart';

class StatusEventsPainter extends CustomPainter {
  final Iterable<({int t, SampleStatus s})> data;
  final double scale;
  final double offset;
  final String key;
  StatusEventsPainter({required this.data, required this.scale, required this.offset, required this.key});

  static final Paint pu = Paint()
    ..colorFilter = const ColorFilter.mode(AppColors.cyan100, BlendMode.srcOver)
    ..style = PaintingStyle.stroke;
  static final Paint pd = Paint()
    ..colorFilter = const ColorFilter.mode(Colors.black, BlendMode.srcOver)
    ..style = PaintingStyle.stroke;
  static final Paint pe = Paint()
    ..colorFilter = const ColorFilter.mode(Colors.red, BlendMode.srcOver)
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    // final paintStart = DateTime.now();

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

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
    // final Duration paintDuration = paintEnd.difference(paintStart);
    // debugPrint('StatusEventsPainter: ${paintDuration.inMicroseconds}us');
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
