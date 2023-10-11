import 'package:flutter/material.dart';

class LineBar extends StatefulWidget {
  final num value;
  final num min;
  final num max;
  const LineBar({
    super.key,
    required this.value,
    required this.min,
    required this.max,
  });

  @override
  State<LineBar> createState() => _LineBarState();
}

class _LineBarState extends State<LineBar> with TickerProviderStateMixin {
  late final controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
  late final curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOutCubicEmphasized);
  late final tween = Tween(begin: 0.0, end: 1.0);
  late final anim = tween.animate(curvedAnimation);
  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      tween.end = _calcFill(widget.min, widget.max, widget.value);
      controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant LineBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    tween.begin = _calcFill(oldWidget.min, oldWidget.max, oldWidget.value);
    tween.end = _calcFill(widget.min, widget.max, widget.value);
    controller.reset();
    controller.forward();
  }

  double _calcFill(num min, num max, num value) => ((value - min) / (max - min)).clamp(0, 1);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: LineBarPainter(fill: anim.value));
  }
}

class LineBarPainter extends CustomPainter {
  final double fill;
  LineBarPainter({required this.fill});

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint()
      ..color = Colors.blueGrey.shade100
      ..style = PaintingStyle.fill;
    Paint pfill = Paint()
      // ..color = Colors.blueGrey
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
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

    canvas.drawRRect(RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(3)), p);
    canvas.drawRRect(RRect.fromLTRBR(0, size.height - (size.height * fill), size.width, size.height, Radius.circular(3)), pfill);
  }
}