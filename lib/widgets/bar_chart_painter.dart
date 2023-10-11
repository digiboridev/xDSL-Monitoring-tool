import 'package:flutter/material.dart';

class BarChartPainter extends CustomPainter {
  final List<int> data;
  BarChartPainter({required this.data});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

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

    // Draw data
    List<int> increasedData = [];
    int max = 1;
    int min = 0;

    for (int i = 0; i < data.length - 1; i++) {
      final curr = data[i];
      final next = data[i + 1];
      if (curr > next) {
        increasedData.add(0);
      } else {
        int incr = next - curr;
        increasedData.add(incr);
        max = max > incr ? max : incr;
      }
    }
    if (increasedData.length < 100) increasedData.insertAll(0, List.filled(100 - increasedData.length, 0));

    final double step = size.width / increasedData.length;

    for (int i = 0; i < increasedData.length; i++) {
      final val = increasedData[i];
      final double scale = ((val - min) / (max - min)).clamp(0, 1);
      final double x = i * step;
      final double y = scale * size.height;
      canvas.drawLine(Offset(x, size.height / 2 + y / 2), Offset(x, size.height / 2 - y / 2), _barPaint);
    }
  }

  Paint get _barPaint => Paint()
    ..color = Colors.blueGrey.shade800
    ..strokeWidth = 1;
  Paint get _meshPaint => Paint()..color = Colors.blueGrey.shade100;
  Paint get _linePaint => Paint()
    ..color = Colors.blueGrey.shade600
    ..strokeWidth = 1;
}
