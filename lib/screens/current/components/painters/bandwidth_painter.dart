import 'dart:math';
import 'package:flutter/material.dart';

class BandwPainter extends CustomPainter {
  final int curr;
  final int attainable;
  final int max;
  BandwPainter({required this.curr, required this.attainable, required this.max});

  @override
  bool shouldRepaint(BandwPainter oldDelegate) {
    return oldDelegate.curr != curr || oldDelegate.attainable != attainable || oldDelegate.max != max;
  }

  static const double _startAngle = 5 * pi / 8;
  static const double _sweepAngle = 14 * pi / 8;

  Paint get _bgPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 12
    ..color = Colors.blueGrey.shade200;
  Paint get _attPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8
    ..color = Colors.yellow.shade400;
  Paint get _currPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8
    ..color = Colors.blueGrey.shade800;

  double get _pCurr => (curr / max).clamp(0, 1);
  double get _pAtt => (attainable / max).clamp(0, 1);

  double get _cAngle => _sweepAngle * _pCurr;
  double get _aAngle => _sweepAngle * _pAtt;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = const Offset(6, 6) & Size(size.width - 12, size.height - 12); // -12 to make room for the stroke
    canvas.drawArc(rect, _startAngle, _sweepAngle, false, _bgPaint);
    canvas.drawArc(rect, _startAngle, _aAngle, false, _attPaint);
    canvas.drawArc(rect, _startAngle, _cAngle, false, _currPaint);
  }
}
