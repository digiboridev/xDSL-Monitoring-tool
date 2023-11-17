// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                  final vs = context.select<MonitoringScreenViewModel, Iterable<int>>((s) => s.rsDownFec);
                  final max = context.select<MonitoringScreenViewModel, int>((s) => s.rsMax);
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
                  final vs = context.select<MonitoringScreenViewModel, Iterable<int>>((s) => s.rsDownCrc);
                  final max = context.select<MonitoringScreenViewModel, int>((s) => s.rsMax);
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
                  final vs = context.select<MonitoringScreenViewModel, Iterable<int>>((s) => s.rsUpFec);
                  final max = context.select<MonitoringScreenViewModel, int>((s) => s.rsMax);
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
                  final vs = context.select<MonitoringScreenViewModel, Iterable<int>>((s) => s.rsUpCrc);
                  final max = context.select<MonitoringScreenViewModel, int>((s) => s.rsMax);
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('FEC D', style: TextStyles.f12w6),
                    const Text('Total', style: TextStyles.f10),
                    Text(downFecTotalExp ?? 'n/a', style: TextStyles.f12w3),
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('CRC D', style: TextStyles.f12w6),
                    const Text('Total', style: TextStyles.f10),
                    Text(downCrcTotalExp ?? 'n/a', style: TextStyles.f12w3),
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('FEC U', style: TextStyles.f12w6),
                    const Text('Total', style: TextStyles.f10),
                    Text(upFecTotalExp ?? 'n/a', style: TextStyles.f12w3),
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('CRC U', style: TextStyles.f12w6),
                    const Text('Total', style: TextStyles.f10),
                    Text(upCrcTotalExp ?? 'n/a', style: TextStyles.f12w3),
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
