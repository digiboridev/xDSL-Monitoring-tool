import 'package:flutter/material.dart';
import 'package:xdslmt/widgets/charts/path_factory.dart';

class LinePathPainter extends CustomPainter {
  final Iterable<({int t, int v})> data;
  final double scale;
  final double offset;
  final String key;
  final String Function(double d) scaleFormat;
  LinePathPainter({required this.data, required this.scale, required this.offset, required this.key, required this.scaleFormat});

  Paint get p => Paint()
    ..color = Colors.cyan.shade100
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    // final paintStart = DateTime.now();

    // Create data path
    final cp = PathFactory.makeLinePath(data, key);
    final Path dataPath = cp.path;
    final PathMetadata metadata = cp.metadata;

    canvas.save(); // save canvas state before data clipping

    // Draw data
    final Matrix4 displayMatrix = Matrix4.identity();
    displayMatrix.scale(size.width, size.height);
    displayMatrix.scale(scale, 1.0);
    displayMatrix.translate(offset / size.width, 0.0);
    canvas.clipPath(Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.transform(displayMatrix.storage);
    canvas.drawPath(dataPath, p);

    canvas.restore(); // restore canvas state after clipping (so it doesn't affect other painters)

    // Draw vMax vertical mesh
    final int vMax = metadata.vMax;
    final int meshSteps = 5;
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
              Shadow(blurRadius: 2, color: Colors.black),
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
