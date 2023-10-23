import 'package:flutter/material.dart';
import 'package:xdslmt/screens/snapshots/components/chart/path_factory.dart';
import 'package:xdslmt/widgets/app_colors.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class WaveFormPainter extends CustomPainter {
  final Iterable<({int t, int v})> data;
  final double scale;
  final double offset;
  final String key;
  WaveFormPainter({required this.data, required this.scale, required this.offset, required this.key});

  static final Paint p = Paint()
    ..colorFilter = const ColorFilter.mode(AppColors.cyan100, BlendMode.srcOver)
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Debug
    // final paintStart = DateTime.now();

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create data path
    final cp = PathFactory.makeWaveFormPath(data, size, '$key ${size.width}');
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
    const int meshSteps = 3;
    final double meshStep = size.height / meshSteps;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()..color = AppColors.cyan200.withOpacity(0.25),
    );
    for (int i = 0; i < meshSteps; i++) {
      final double y = meshStep * i;
      final double x = size.width;
      final text = TextPainter(
        text: TextSpan(text: (vMax / meshSteps * (meshSteps - i)).toStringAsFixed(1), style: TextStyles.f6meshV),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      text.layout();
      text.paint(canvas, Offset(x - text.width, y / 2 - text.height / 2));
      canvas.drawLine(
        Offset(0, y / 2),
        Offset(x - text.width - 4, y / 2),
        Paint()..color = AppColors.cyan200.withOpacity(0.25),
      );
      canvas.drawLine(
        Offset(0, size.height - y / 2),
        Offset(x, size.height - y / 2),
        Paint()..color = AppColors.cyan200.withOpacity(0.25),
      );
    }

    // Debug
    // final paintEnd = DateTime.now();
    // debugPrint('WaveFormPainter: ${paintEnd.difference(paintStart).inMicroseconds}us');
  }

  @override
  bool shouldRepaint(WaveFormPainter oldDelegate) {
    bool sameData = data.length == oldDelegate.data.length;
    bool sameScale = scale == oldDelegate.scale;
    bool sameOffset = offset == oldDelegate.offset;
    bool sameKey = key == oldDelegate.key;
    return !(sameData && sameScale && sameOffset && sameKey);
  }
}
