// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/recent_counters.dart';
import 'package:xdslmt/screens/monitoring/components/painters/timeless_linepath_painter.dart';
import 'package:xdslmt/screens/monitoring/components/painters/linebar_painter.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/core/text_styles.dart';
import 'package:xdslmt/screens/monitoring/vm.dart';

class SNRBar extends StatelessWidget {
  const SNRBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final v = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.downSNRmLast);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SNRM Down: ${v?.oneFrStr ?? 'N/A'}', style: TextStyles.f12),
                            Text('dB', style: TextStyles.f10w3.blueGrey800),
                            const SizedBox(width: 4),
                            SizedBox(width: 4, height: 16, child: LineBar(value: v ?? 0, min: 0, max: 160)),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final recentCounters = context.select<MonitoringScreenViewModel, RecentCounters?>((s) => s.recentCounters);
                        final s = recentCounters?.downSNRRecent ?? [];
                        final min = recentCounters?.snrMin ?? 0;
                        final max = recentCounters?.snrMax ?? 0;
                        return LineChart(s: s, min: min, max: max, invert: false);
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final min = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.downSNRMin);
                        final max = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.downSNRMax);
                        final avg = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.downSNRAvg);
                        return MinMaxAvgRow(min: min, max: max, avg: avg);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final v = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.upSNRmLast);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SNRM Up: ${v?.oneFrStr ?? 'N/A'}', style: TextStyles.f12),
                            Text('dB', style: TextStyles.f10w3.blueGrey800),
                            const SizedBox(width: 4),
                            SizedBox(width: 4, height: 16, child: LineBar(value: v ?? 0, min: 0, max: 160)),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final recentCounters = context.select<MonitoringScreenViewModel, RecentCounters?>((s) => s.recentCounters);
                        final s = recentCounters?.upSNRRecent ?? [];
                        final min = recentCounters?.snrMin ?? 0;
                        final max = recentCounters?.snrMax ?? 0;
                        return LineChart(s: s, min: min, max: max, invert: false);
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final min = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.upSNRMin);
                        final max = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.upSNRMax);
                        final avg = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.upSNRAvg);
                        return MinMaxAvgRow(min: min, max: max, avg: avg);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final v = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.downAttenuationLast);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ATN Down:  ${v?.oneFrStr ?? 'N/A'}', style: TextStyles.f12),
                            Text('dB', style: TextStyles.f10w3.blueGrey800),
                            const SizedBox(width: 4),
                            SizedBox(width: 4, height: 16, child: LineBar(value: 1000 - (v ?? 1000), min: 0, max: 1000)),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final recentCounters = context.select<MonitoringScreenViewModel, RecentCounters?>((s) => s.recentCounters);
                        final s = recentCounters?.downATTNRecent ?? [];
                        final min = recentCounters?.attnMin ?? 0;
                        final max = recentCounters?.attnMax ?? 0;
                        return LineChart(s: s, min: min, max: max, invert: true);
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final min = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.downATTNMin);
                        final max = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.downATTNMax);
                        final avg = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.downATTNAvg);
                        return MinMaxAvgRow(min: min, max: max, avg: avg);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final v = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.upAttenuationLast);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ATN Up:  ${v?.oneFrStr ?? 'N/A'}', style: TextStyles.f12),
                            Text('dB', style: TextStyles.f10w3.blueGrey800),
                            const SizedBox(width: 4),
                            SizedBox(width: 4, height: 16, child: LineBar(value: 1000 - (v ?? 1000), min: 0, max: 1000)),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final recentCounters = context.select<MonitoringScreenViewModel, RecentCounters?>((s) => s.recentCounters);
                        final s = recentCounters?.upATTNRecent ?? [];
                        final min = recentCounters?.attnMin ?? 0;
                        final max = recentCounters?.attnMax ?? 0;
                        return LineChart(s: s, min: min, max: max, invert: true);
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(
                      builder: (context) {
                        final min = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.upATTNMin);
                        final max = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.upATTNMax);
                        final avg = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.upATTNAvg);
                        return MinMaxAvgRow(min: min, max: max, avg: avg);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LineChart extends StatelessWidget {
  const LineChart({super.key, required this.s, required this.min, required this.max, required this.invert});

  final Iterable<int?> s;
  final int min;
  final int max;
  final bool invert;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: double.infinity,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cyan100),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      child: CustomPaint(painter: TimelessLinePathPainter(s, min, max, invert)),
    );
  }
}

class MinMaxAvgRow extends StatelessWidget {
  final int? min;
  final int? max;
  final int? avg;
  const MinMaxAvgRow({Key? key, this.min, this.max, this.avg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${min?.oneFrStr ?? '-'} MIN', style: TextStyles.f8.blueGrey800),
        const SizedBox(width: 4),
        Text('${max?.oneFrStr ?? '-'} MAX', style: TextStyles.f8.blueGrey800),
        const SizedBox(width: 4),
        Text('${avg?.oneFrStr ?? '-'} AVG', style: TextStyles.f8.blueGrey800),
      ],
    );
  }
}

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
  late final controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
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
