// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/recent_counters.dart';
import 'package:xdslmt/screens/monitoring/components/painters/timeless_waveform_painter.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/core/text_styles.dart';
import 'package:xdslmt/screens/monitoring/vm.dart';

class RSCBar extends StatelessWidget {
  const RSCBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        counts(),
        bars(),
      ],
    );
  }

  Widget bars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 75,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blueGrey100),
              borderRadius: BorderRadius.circular(3),
            ),
            child: RepaintBoundary(
              child: Builder(
                builder: (context) {
                  final recentCounters = context.select<MonitoringScreenViewModel, RecentCounters?>((s) => s.recentCounters);
                  final vs = recentCounters?.downFECRecent ?? [];
                  final max = recentCounters?.rsMax ?? 0;
                  return CustomPaint(painter: WaveFormTimelessPainter(max: max, increasedData: vs));
                },
              ),
            ),
          ),
        ),
        Container(
          width: 75,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blueGrey100),
              borderRadius: BorderRadius.circular(3),
            ),
            child: RepaintBoundary(
              child: Builder(
                builder: (context) {
                  final recentCounters = context.select<MonitoringScreenViewModel, RecentCounters?>((s) => s.recentCounters);
                  final vs = recentCounters?.downCRCRecent ?? [];
                  final max = recentCounters?.rsMax ?? 0;
                  return CustomPaint(painter: WaveFormTimelessPainter(max: max, increasedData: vs));
                },
              ),
            ),
          ),
        ),
        Container(
          width: 75,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blueGrey100),
              borderRadius: BorderRadius.circular(3),
            ),
            child: RepaintBoundary(
              child: Builder(
                builder: (context) {
                  final recentCounters = context.select<MonitoringScreenViewModel, RecentCounters?>((s) => s.recentCounters);
                  final vs = recentCounters?.upFECRecent ?? [];
                  final max = recentCounters?.rsMax ?? 0;
                  return CustomPaint(painter: WaveFormTimelessPainter(max: max, increasedData: vs));
                },
              ),
            ),
          ),
        ),
        Container(
          width: 75,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blueGrey100),
              borderRadius: BorderRadius.circular(3),
            ),
            child: RepaintBoundary(
              child: Builder(
                builder: (context) {
                  final recentCounters = context.select<MonitoringScreenViewModel, RecentCounters?>((s) => s.recentCounters);
                  final vs = recentCounters?.upCRCRecent ?? [];
                  final max = recentCounters?.rsMax ?? 0;
                  return CustomPaint(painter: WaveFormTimelessPainter(max: max, increasedData: vs));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget counts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 75,
          child: RepaintBoundary(
            child: Builder(
              builder: (context) {
                final downFecLast = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.downFecLast);
                final downFecTotal = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.downFecTotal);
                final downFecTotalExp = downFecTotal?.toStringAsPrecision(3);

                final showRecent = context.select<MonitoringScreenViewModel, bool>((s) => s.recentCounters?.maxCountReached ?? false);
                final downFecTotalRecent = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.downFECTotal);
                final downFecTotalRecentExp = downFecTotalRecent?.toStringAsPrecision(3);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('FEC D', style: TextStyles.f12w6),
                    const Text('Total', style: TextStyles.f10),
                    Text(downFecTotalExp ?? 'n/a', style: TextStyles.f12w3),
                    if (showRecent) const Text('Recent', style: TextStyles.f10),
                    if (showRecent) Text(downFecTotalRecentExp ?? 'n/a', style: TextStyles.f12w3),
                    const Text('Impulse', style: TextStyles.f10),
                    Text('${downFecLast ?? 'n/a'}', style: TextStyles.f12w3),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 75,
          child: RepaintBoundary(
            child: Builder(
              builder: (context) {
                final downCrcLast = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.downCrcLast);
                final downCrcTotal = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.downCrcTotal);
                final downCrcTotalExp = downCrcTotal?.toStringAsPrecision(3);

                final showRecent = context.select<MonitoringScreenViewModel, bool>((s) => s.recentCounters?.maxCountReached ?? false);
                final downCrcTotalRecent = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.downCRCTotal);
                final downCrcTotalExpRecent = downCrcTotalRecent?.toStringAsPrecision(3);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('CRC D', style: TextStyles.f12w6),
                    const Text('Total', style: TextStyles.f10),
                    Text(downCrcTotalExp ?? 'n/a', style: TextStyles.f12w3),
                    if (showRecent) const Text('Recent', style: TextStyles.f10),
                    if (showRecent) Text(downCrcTotalExpRecent ?? 'n/a', style: TextStyles.f12w3),
                    const Text('Impulse', style: TextStyles.f10),
                    Text('${downCrcLast ?? 'n/a'}', style: TextStyles.f12w3),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 75,
          child: RepaintBoundary(
            child: Builder(
              builder: (context) {
                final upFecLast = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.upFecLast);
                final upFecTotal = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.upFecTotal);
                final upFecTotalExp = upFecTotal?.toStringAsPrecision(3);

                final showRecent = context.select<MonitoringScreenViewModel, bool>((s) => s.recentCounters?.maxCountReached ?? false);
                final upFecTotalRecent = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.upFECTotal);
                final upFecTotalExpRecent = upFecTotalRecent?.toStringAsPrecision(3);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('FEC U', style: TextStyles.f12w6),
                    const Text('Total', style: TextStyles.f10),
                    Text(upFecTotalExp ?? 'n/a', style: TextStyles.f12w3),
                    if (showRecent) const Text('Recent', style: TextStyles.f10),
                    if (showRecent) Text(upFecTotalExpRecent ?? 'n/a', style: TextStyles.f12w3),
                    const Text('Impulse', style: TextStyles.f10),
                    Text('${upFecLast ?? 'n/a'}', style: TextStyles.f12w3),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 75,
          child: RepaintBoundary(
            child: Builder(
              builder: (context) {
                final upCrcLast = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.upCrcLast);
                final upCrcTotal = context.select<MonitoringScreenViewModel, int?>((s) => s.lastSnapshotStats?.upCrcTotal);
                final upCrcTotalExp = upCrcTotal?.toStringAsPrecision(3);

                final showRecent = context.select<MonitoringScreenViewModel, bool>((s) => s.recentCounters?.maxCountReached ?? false);
                final upCrcTotalRecent = context.select<MonitoringScreenViewModel, int?>((s) => s.recentCounters?.upCRCTotal);
                final upCrcTotalExpRecent = upCrcTotalRecent?.toStringAsPrecision(3);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('CRC U', style: TextStyles.f12w6),
                    const Text('Total', style: TextStyles.f10),
                    Text(upCrcTotalExp ?? 'n/a', style: TextStyles.f12w3),
                    if (showRecent) const Text('Recent', style: TextStyles.f10),
                    if (showRecent) Text(upCrcTotalExpRecent ?? 'n/a', style: TextStyles.f12w3),
                    const Text('Impulse', style: TextStyles.f10),
                    Text('${upCrcLast ?? 'n/a'}', style: TextStyles.f12w3),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
