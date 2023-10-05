import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:xdsl_mt/data/models/line_stats.dart';
import 'package:xdsl_mt/data/services/stats_sampling_service.dart';

class CurrentSpeedBar extends StatefulWidget {
  const CurrentSpeedBar({super.key});

  @override
  State<CurrentSpeedBar> createState() => _CurrentSpeedBarState();
}

class _CurrentSpeedBarState extends State<CurrentSpeedBar> with TickerProviderStateMixin {
  // Values
  double currDown = 0;
  double currUp = 0;
  double attainableDown = 0;
  double attainableUp = 0;

  //Animation vars
  late final AnimationController controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
  late final curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn, reverseCurve: Curves.easeOut);
  late final curvedAnimationAlt = CurvedAnimation(parent: controller, curve: Curves.bounceInOut, reverseCurve: Curves.easeOut);

  late final Tween<double> currDownTween = Tween(begin: 0, end: 0);
  late final Tween<double> currUpTween = Tween(begin: 0, end: 0);
  late final Tween<double> attainableDownTween = Tween(begin: 0, end: 0);
  late final Tween<double> attainableUpTween = Tween(begin: 0, end: 0);

  late final Animation<double> currDownAnimation = currDownTween.animate(curvedAnimation);
  late final Animation<double> currUpAnimation = currUpTween.animate(curvedAnimation);
  late final Animation<double> attainableDownAnimation = attainableDownTween.animate(curvedAnimationAlt);
  late final Animation<double> attainableUpAnimation = attainableUpTween.animate(curvedAnimationAlt);

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));

    updateData();

    context.read<StatsSamplingService>().addListener(() {
      if (mounted) updateData();
    });
  }

  updateData() {
    // Save prev values
    var currDownold = currDown;
    var currUpold = currUp;
    var attainableDownold = attainableDown;
    var attainableUpold = attainableUp;

    // Get new values
    LineStats? stats = context.read<StatsSamplingService>().lastSample;
    currDown = stats?.downRate?.toDouble() ?? 0;
    currUp = stats?.upRate?.toDouble() ?? 0;
    attainableDown = stats?.downMaxRate?.toDouble() ?? 0;
    attainableUp = stats?.upMaxRate?.toDouble() ?? 0;

    // Start animation from old to new values if changed
    if (currDown != currDownold || currUp != currUpold || attainableDown != attainableDownold || attainableUp != attainableUpold) {
      currDownTween.begin = currDownold;
      currDownTween.end = currDown;
      currUpTween.begin = currUpold;
      currUpTween.end = currUp;
      attainableDownTween.begin = attainableDownold;
      attainableDownTween.end = attainableDown;
      attainableUpTween.begin = attainableUpold;
      attainableUpTween.end = attainableUp;
      controller.reset();
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(16),
          child: Text(
            'Current speed rates',
            style: TextStyle(color: Colors.blueGrey.shade900, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: CustomPaint(
                  painter: SpdPainter(curr: currDownAnimation.value, attainable: attainableDownAnimation.value, max: 24000),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Down', style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade900, fontWeight: FontWeight.w300)),
                      Text(
                        '${currDownAnimation.value.toInt()}/${attainableDownAnimation.value.toInt()}',
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade900, fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'Kbps',
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade900, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                width: 120,
                child: CustomPaint(
                  painter: SpdPainter(curr: currUpAnimation.value, attainable: attainableUpAnimation.value, max: 3000),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Up', style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade900, fontWeight: FontWeight.w300)),
                      Text(
                        '${currUpAnimation.value.toInt()}/${attainableUpAnimation.value.toInt()}',
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey.shade900, fontWeight: FontWeight.w300),
                      ),
                      Text('Kbps', style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade900, fontWeight: FontWeight.w300)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//Current speed animater circles paiter
class SpdPainter extends CustomPainter {
  double curr;
  double attainable;
  double max;
  SpdPainter({required this.curr, required this.attainable, required this.max});

  double percentageCurr() {
    return curr > max ? 5.4 : 5.4 * curr / max;
  }

  double percentageAtta() {
    return attainable > max ? 5.4 : 5.4 * attainable / max;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & Size(size.width, size.height);
    canvas.drawArc(
      rect,
      2,
      5.4,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..color = Colors.blueGrey.shade200,
    );
    canvas.drawArc(
      rect,
      2,
      percentageAtta(),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..color = Colors.yellow.shade400,
    );
    canvas.drawArc(
      rect,
      2,
      percentageCurr(),
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..color = Colors.blueGrey.shade800,
    );
  }

  @override
  bool shouldRepaint(SpdPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(SpdPainter oldDelegate) => false;
}
