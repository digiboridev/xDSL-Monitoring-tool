// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/widgets/bar_chart_painter.dart';
import 'package:xdslmt/widgets/text_styles.dart';

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
    return RepaintBoundary(
      child: Builder(builder: (context) {
        final v = context.watch<StatsSamplingService>().lastSamples;
        List<int> dfec = [];
        List<int> ufec = [];
        List<int> dcrc = [];
        List<int> ucrc = [];

        for (final s in v) {
          dfec.add(s.downFEC ?? 0);
          ufec.add(s.upFEC ?? 0);
          dcrc.add(s.downCRC ?? 0);
          ucrc.add(s.upCRC ?? 0);
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 75,
              height: 50,
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey.shade100),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: CustomPaint(painter: BarChartPainter(data: dfec)),
              ),
            ),
            Container(
              width: 75,
              height: 50,
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey.shade100),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: CustomPaint(painter: BarChartPainter(data: dcrc)),
              ),
            ),
            Container(
              width: 75,
              height: 50,
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey.shade100),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: CustomPaint(painter: BarChartPainter(data: ufec)),
              ),
            ),
            Container(
              width: 75,
              height: 50,
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey.shade100),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: CustomPaint(painter: BarChartPainter(data: ucrc)),
              ),
            ),
          ],
        );
      }),
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
                final downFecLast = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downFecLast);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('FEC D', style: TextStyles.f12),
                    Text('${downFecLast ?? 'n/a'}', style: TextStyles.f14w3),
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
                final downCrcLast = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downCrcLast);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('CDC D', style: TextStyles.f12),
                    Text('${downCrcLast ?? 'n/a'}', style: TextStyles.f14w3),
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
                final upFecLast = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upFecLast);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('FEC U', style: TextStyles.f12),
                    Text('${upFecLast ?? 'n/a'}', style: TextStyles.f14w3),
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
                final upCrcLast = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upCrcLast);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('CRC U', style: TextStyles.f12),
                    Text('${upCrcLast ?? 'n/a'}', style: TextStyles.f14w3),
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
