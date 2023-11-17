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

    final type = stats?.lastConnectionType;

    // TODO extract util
    if (type != null) {
      bool isVDSL2 = type.toLowerCase().contains('vdsl2') || type.toLowerCase().contains('993.2') || type.toLowerCase().contains('993.5');
      bool isVDSL = type.toLowerCase().contains('vdsl') || type.toLowerCase().contains('993.1');
      bool isAdsl = type.toLowerCase().contains('adsl') || type.toLowerCase().contains('992');

      if (isVDSL2) {
        maxDown = 200000;
        maxUp = 100000;
      } else if (isVDSL) {
        maxDown = 60000;
        maxUp = 5000;
      } else if (isAdsl) {
        maxDown = 24000;
        maxUp = 3500;
      } else {
        maxDown = 300000;
        maxUp = 100000;
      }
    }

    currDown = stats?.downRateLast ?? 0;
    currUp = stats?.upRateLast ?? 0;
    attainableDown = stats?.downAttainableRateLast ?? 0;
    attainableUp = stats?.upAttainableRateLast ?? 0;
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
