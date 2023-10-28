import 'package:flutter/material.dart';
import 'package:xdslmt/core/colors.dart';

class WaveFormTimelessPainter extends CustomPainter {
  final List<int> increasedData;
  final int max;
  WaveFormTimelessPainter({required this.increasedData, required this.max});

  static final _barPaint = Paint()
    ..color = AppColors.blueGrey900.withOpacity(0.5)
    ..strokeWidth = 1;
  static final _meshPaint = Paint()
    ..color = AppColors.blueGrey100
    ..strokeWidth = 0.5;
  static final _linePaint = Paint()
    ..color = AppColors.blueGrey600
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw mesh
    final double hmstep = size.width / 10;
    for (int i = 0; i < 11; i++) {
      final double x = i * hmstep;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), _meshPaint);
    }
    final double vmstep = size.height / 10;
    for (int i = 0; i < 11; i++) {
      final double y = i * vmstep;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), _meshPaint);
    }

    // Draw center line
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), _linePaint);
    if (increasedData.length < 100) increasedData.insertAll(0, List.filled(100 - increasedData.length, 0));
    final double step = size.width / increasedData.length;

    // Draw bars
    for (int i = 0; i < increasedData.length; i++) {
      final val = increasedData[i];
      final double scale = (val / max).clamp(0, 1);
      final double x = i * step;
      final double y = scale * size.height;
      canvas.drawLine(Offset(x, size.height / 2 + y / 2), Offset(x, size.height / 2 - y / 2), _barPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
