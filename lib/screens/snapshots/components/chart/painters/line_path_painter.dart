import 'package:flutter/material.dart';
import 'package:xdslmt/screens/snapshots/components/chart/path_factory.dart';

class LinePathPainter extends CustomPainter {
  final Iterable<({int t, int v})> data;
  final double scale;
  final double offset;
  final String key;
  final String Function(double d) scaleFormat;
  LinePathPainter({required this.data, required this.scale, required this.offset, required this.key, required this.scaleFormat});

  static final Paint p = Paint()
    ..colorFilter = ColorFilter.mode(Colors.cyan.shade100, BlendMode.srcOver)
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    // final paintStart = DateTime.now();

    // Create data path
    final cp = PathFactory.makeLinePath(data, size, '$key ${size.width}');
    final Path dataPath = cp.path;
    final PathMetadata metadata = cp.metadata;

    canvas.save(); // save canvas state before data clipping

    // Draw data
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset, 0.0);
    canvas.transform(displayMatrix.storage);
    canvas.drawPath(dataPath, p);

    canvas.restore(); // restore canvas state after clipping (so it doesn't affect other painters)

    // Draw vMax vertical mesh
    final int vMax = metadata.vMax;
    const int meshSteps = 5;
    final double meshStep = size.height / meshSteps;
    for (int i = 0; i < meshSteps; i++) {
      final double y = meshStep * i;
      final double x = size.width;
      final text = TextPainter(
        text: TextSpan(
          text: scaleFormat(vMax / meshSteps * (meshSteps - i)),
          style: TextStyle(
            color: Colors.cyan.shade50,
            fontSize: 6,
            shadows: [
              const Shadow(blurRadius: 2, color: Colors.black),
              Shadow(blurRadius: 8, color: Colors.blueGrey.shade800),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      text.layout();
      text.paint(canvas, Offset(x - text.width, y - text.height / 2));
      canvas.drawLine(
        Offset(0, y),
        Offset(x - text.width - 4, y),
        Paint()..color = Colors.cyan.shade200.withOpacity(0.25),
      );
    }

    // Debug
    // final paintEnd = DateTime.now();
    // debugPrint('WaveFormPainter: ${paintEnd.difference(paintStart).inMicroseconds}us');
  }

  @override
  bool shouldRepaint(LinePathPainter oldDelegate) {
    bool sameData = data.length == oldDelegate.data.length;
    bool sameScale = scale == oldDelegate.scale;
    bool sameOffset = offset == oldDelegate.offset;
    bool sameKey = key == oldDelegate.key;
    return !(sameData && sameScale && sameOffset && sameKey);
  }
}
