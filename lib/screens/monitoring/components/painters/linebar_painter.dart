import 'package:flutter/material.dart';
import 'package:xdslmt/core/colors.dart';

class LineBarPainter extends CustomPainter {
  final double fill;
  LineBarPainter({required this.fill});

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint()
      ..color = AppColors.blueGrey100
      ..style = PaintingStyle.fill;
    Paint pfill = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        colors: [Colors.black, Colors.yellow],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ).createShader(
        Rect.fromLTRB(
          0,
          0,
          size.width,
          size.height,
        ),
      );

    canvas.drawRRect(RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(3)), p);
    canvas.drawRRect(RRect.fromLTRBR(0, size.height - (size.height * fill), size.width, size.height, const Radius.circular(3)), pfill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
