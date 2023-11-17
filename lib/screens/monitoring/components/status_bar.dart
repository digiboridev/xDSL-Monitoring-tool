import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/repositories/current_sampling_repo.dart';
import 'package:xdslmt/screens/monitoring/vm.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.blueGrey800,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(fit: FlexFit.loose, child: StatusIndicators()),
                SizedBox(width: 8),
                Flexible(fit: FlexFit.tight, child: StatusText()),
                SizedBox(width: 4),
                Icon(Icons.chevron_left_sharp, color: AppColors.cyan50, size: 16),
              ],
            ),
          ),
        ),
        const ProgressLine(),
      ],
    );
  }
}

// Draws sampling status indicators (yellow/black circles)
// S - sampling active
// C - connected to network unit
// DSL - DSL connection up

class StatusIndicators extends StatelessWidget {
  const StatusIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Sampling active / Connected to network unit / DSL connection up',
      child: Builder(
        builder: (context) {
          final sampling = context.select<MonitoringScreenViewModel, bool>((vm) => vm.samplingActive);
          final lastSnapshotStats = context.select<MonitoringScreenViewModel, SnapshotStats?>((vm) => vm.lastSnapshotStats);
          final netUnitConnected = sampling && lastSnapshotStats?.lastSampleStatus != SampleStatus.samplingError;
          final connectionUp = sampling && lastSnapshotStats?.lastSampleStatus == SampleStatus.connectionUp;

          return Row(
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
          );
        },
      ),
    );
  }
}

// Draws sampling status text
class StatusText extends StatelessWidget {
  const StatusText({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Current execution status or error messages',
      child: Builder(
        builder: (context) {
          final sampling = context.select<MonitoringScreenViewModel, bool>((vm) => vm.samplingActive);
          final lastSample = context.select<MonitoringScreenViewModel, LineStats?>((vm) => vm.lastLineStats.lastOrNull);

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

          return AnimatedSwitcher(
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
          );
        },
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
  late final controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();

    controller.addListener(() => setState(() {}));

    final currentSamplingRepository = context.read<CurrentSamplingRepository>();
    Future.doWhile(() async {
      final event = await currentSamplingRepository.updatesStream.first;
      if (!mounted) return false;

      Duration lastDuration = currentSamplingRepository.lastSamplingDuration;
      if (lastDuration == Duration.zero) lastDuration = const Duration(milliseconds: 300);

      if (event == UpdateType.fetchAttempt) {
        controller.animateTo(0, duration: Duration.zero);
        controller.animateTo(0.5, duration: Duration(milliseconds: lastDuration.inMilliseconds ~/ 2), curve: Curves.ease);
      }

      if (event == UpdateType.statsUpdated) {
        controller
            .animateTo(1, duration: Duration(milliseconds: lastDuration.inMilliseconds ~/ 2), curve: Curves.ease)
            .whenComplete(() => controller.animateTo(0, duration: Duration.zero));
      }

      return true;
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
      height: 2,
      child: Row(
        children: [
          if (context.select<MonitoringScreenViewModel, bool>((vm) => vm.samplingActive))
            Container(
              color: Colors.yellow[700],
              height: 2,
              width: MediaQuery.of(context).size.width * controller.value,
            ),
        ],
      ),
    );
  }
}
