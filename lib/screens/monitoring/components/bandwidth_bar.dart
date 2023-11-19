import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/screens/monitoring/components/painters/bandwidth_painter.dart';
import 'package:xdslmt/core/text_styles.dart';
import 'package:xdslmt/screens/monitoring/vm.dart';

class BandwidthBar extends StatefulWidget {
  const BandwidthBar({super.key});

  @override
  State<BandwidthBar> createState() => _BandwidthBarState();
}

class _BandwidthBarState extends State<BandwidthBar> with TickerProviderStateMixin {
  // Values
  int currDown = 0;
  int currUp = 0;
  int attainableDown = 0;
  int attainableUp = 0;
  int maxDown = 300000;
  int maxUp = 100000;

  //Animation vars
  late final AnimationController controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  late final curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn, reverseCurve: Curves.easeOut);
  late final curvedAnimationAlt = CurvedAnimation(parent: controller, curve: Curves.bounceInOut, reverseCurve: Curves.easeOut);

  late final Tween<int> currDownTween = IntTween(begin: 0, end: 0);
  late final Tween<int> currUpTween = IntTween(begin: 0, end: 0);
  late final Tween<int> attainableDownTween = IntTween(begin: 0, end: 0);
  late final Tween<int> attainableUpTween = IntTween(begin: 0, end: 0);

  late final Animation<int> currDownAnimation = currDownTween.animate(curvedAnimation);
  late final Animation<int> currUpAnimation = currUpTween.animate(curvedAnimation);
  late final Animation<int> attainableDownAnimation = attainableDownTween.animate(curvedAnimationAlt);
  late final Animation<int> attainableUpAnimation = attainableUpTween.animate(curvedAnimationAlt);

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
    updateData();
    context.read<MonitoringScreenViewModel>().addListener(() {
      if (mounted) updateData();
    });
  }

  updateData() {
    // Save prev values
    int currDownold = currDown;
    int currUpold = currUp;
    int attainableDownold = attainableDown;
    int attainableUpold = attainableUp;

    // Get new values
    SnapshotStats? stats = context.read<MonitoringScreenViewModel>().lastSnapshotStats;

    currDown = stats?.downRateLast ?? 0;
    currUp = stats?.upRateLast ?? 0;
    attainableDown = stats?.downAttainableRateLast ?? 0;
    attainableUp = stats?.upAttainableRateLast ?? 0;

    // Adjust max values based on current values
    if (currDown > 0) {
      maxDown = 24000; // adsl
      if (currDown > 24000) maxDown = 68000; // vdsl 8/12mhz
      if (currDown > 68000) maxDown = 150000; // vdsl 17mhz
      if (currDown > 150000) maxDown = 230000; // vdsl 30mhz
      if (currDown > 230000) maxDown = 300000; // vdsl 35mhz
    }
    if (currUp > 0) {
      maxUp = 3000; // adsl
      if (currUp > 3000) maxUp = 20000; // vdsl 8/12mhz
      if (currUp > 20000) maxUp = 50000; // vdsl 17mhz
      if (currUp > 50000) maxUp = 100000; // vdsl 30/35mhz
    }

    setState(() {});

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: CustomPaint(
            painter: BandwPainter(curr: currDownAnimation.value, attainable: attainableDownAnimation.value, max: maxDown),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('DOWNSTREAM', style: TextStyles.f10w6.blueGrey600),
                Text('CUR/ATT', style: TextStyles.f10.blueGrey600),
                Text('${currDownAnimation.value}/${attainableDownAnimation.value}', style: TextStyles.f14w3.blueGrey800),
                Text('Kbps', style: TextStyles.f10.blueGrey600),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 150,
          width: 150,
          child: CustomPaint(
            painter: BandwPainter(curr: currUpAnimation.value, attainable: attainableUpAnimation.value, max: maxUp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('UPSTEAM', style: TextStyles.f10w6.blueGrey600),
                Text('CUR/ATT', style: TextStyles.f10.blueGrey600),
                Text('${currUpAnimation.value}/${attainableUpAnimation.value}', style: TextStyles.f14w3.blueGrey800),
                Text('Kbps', style: TextStyles.f10.blueGrey600),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
