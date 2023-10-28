import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/core/colors.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    StatsSamplingService samplingService = context.watch<StatsSamplingService>();
    LineStats? lastSample = samplingService.lastSamples.lastOrNull;

    bool sampling = samplingService.samplingActive;
    bool netUnitConnected = lastSample is LineStats && lastSample.status != SampleStatus.samplingError;
    bool connectionUp = lastSample is LineStats && lastSample.status == SampleStatus.connectionUp;

    return Column(
      children: [
        Container(
          color: AppColors.blueGrey800,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(fit: FlexFit.loose, child: indicators(sampling, netUnitConnected, connectionUp)),
                const SizedBox(width: 8),
                Flexible(fit: FlexFit.tight, child: statusText(sampling, lastSample)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_left_sharp, color: AppColors.cyan50, size: 16),
              ],
            ),
          ),
        ),
        const ProgressLine(),
      ],
    );
  }

  Widget statusText(bool sampling, LineStats? lastSample) {
    String statusText = '';
    if (sampling) {
      if (lastSample is LineStats) {
        statusText = lastSample.statusText;
      } else {
        statusText = 'Connecting...';
      }
    } else {
      statusText = 'Idle';
    }

    return Tooltip(
      message: 'Current execution status or error messages',
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.elasticOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.1, 0), end: const Offset(0, 0)).animate(animation),
            child: FadeTransition(
              opacity: Tween<double>(begin: -1, end: 1).animate(animation),
              child: child,
            ),
          );
        },
        child: Align(
          key: Key(statusText),
          alignment: Alignment.centerRight,
          child: Text(
            statusText,
            style: const TextStyle(color: AppColors.cyan50, fontSize: 14, fontWeight: FontWeight.w300),
            overflow: TextOverflow.ellipsis,
            // key: Key(statusText),
            // key: UniqueKey(),
          ),
        ),
      ),
    );
  }

  Widget indicators(bool sampling, bool netUnitConnected, bool connectionUp) {
    return Tooltip(
      message: 'Sampling active / Connected to network unit / DSL connection up',
      child: Row(
        children: [
          const Text(
            'S/C/DSL',
            style: TextStyle(color: AppColors.cyan50, fontWeight: FontWeight.w300),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutBack,
            width: 10,
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: sampling ? Colors.yellow : Colors.black,
                width: 5,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutBack,
            width: 10,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: netUnitConnected ? Colors.yellow : Colors.black,
                width: 5,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutBack,
            width: 10,
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              border: Border.all(
                color: connectionUp ? Colors.yellow : Colors.black,
                width: 5,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}

// Draws animated line when sampling is running
class ProgressLine extends StatefulWidget {
  const ProgressLine({super.key});

  @override
  State<ProgressLine> createState() => _ProgressLineState();
}

class _ProgressLineState extends State<ProgressLine> with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  late final curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.ease, reverseCurve: Curves.ease);
  late final Tween<double> animTween = Tween(begin: 0, end: 0);
  late final Animation<double> animation = animTween.animate(curvedAnimation);

  @override
  void initState() {
    super.initState();

    controller.addListener(() => setState(() {}));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) controller.reset();
      if (status == AnimationStatus.dismissed) controller.reset();
    });

    StatsSamplingService samplingService = context.read<StatsSamplingService>();

    samplingService.addListener(() {
      {
        if (!mounted) return;
        animTween.begin = 0;
        animTween.end = 1;
        controller.reset();
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Row(
        children: [
          Container(
            color: Colors.yellow[700],
            height: 2,
            width: MediaQuery.of(context).size.width * animation.value,
          ),
        ],
      ),
    );
  }
}
