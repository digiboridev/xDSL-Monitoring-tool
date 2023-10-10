import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/widgets/bandwidth_painter.dart';
import 'package:xdslmt/widgets/text_styles.dart';

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

  //Animation vars
  late final AnimationController controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
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
    context.read<StatsSamplingService>().addListener(() {
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
    SnapshotStats? stats = context.read<StatsSamplingService>().snapshotStats;
    currDown = stats?.downRateLast ?? 0;
    currUp = stats?.upRateLast ?? 0;
    attainableDown = stats?.downAttainableRateLast ?? 0;
    attainableUp = stats?.upAttainableRateLast ?? 0;

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
            painter: BandwPainter(curr: currDownAnimation.value, attainable: attainableDownAnimation.value, max: 24000),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Down', style: TextStyles.f12.blueGrey600),
                Text('${currDownAnimation.value}/${attainableDownAnimation.value}', style: TextStyles.f14w3.blueGrey900),
                Text('Kbps', style: TextStyles.f12.blueGrey600),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 150,
          width: 150,
          child: CustomPaint(
            painter: BandwPainter(curr: currUpAnimation.value, attainable: attainableUpAnimation.value, max: 3000),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Up', style: TextStyles.f12.blueGrey600),
                Text('${currUpAnimation.value}/${attainableUpAnimation.value}', style: TextStyles.f14w3.blueGrey900),
                Text('Kbps', style: TextStyles.f12.blueGrey600),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
