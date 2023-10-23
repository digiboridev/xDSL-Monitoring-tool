// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/screens/current/components/painters/timeless_waveform_painter.dart';
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
      child: Builder(
        builder: (context) {
          final v = context.watch<StatsSamplingService>().lastSamples;
          List<int> dfec = [];
          List<int> ufec = [];
          List<int> dcrc = [];
          List<int> ucrc = [];

          for (final s in v) {
            dfec.add(s.downFECIncr ?? 0);
            ufec.add(s.upFECIncr ?? 0);
            dcrc.add(s.downCRCIncr ?? 0);
            ucrc.add(s.upCRCIncr ?? 0);
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
                  child: CustomPaint(painter: WaveFormTimelessPainter(max: 1000, increasedData: dfec)),
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
                  child: CustomPaint(
                    painter: WaveFormTimelessPainter(
                      max: 1000,
                      increasedData: dcrc,
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
                    border: Border.all(color: Colors.blueGrey.shade100),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: CustomPaint(painter: WaveFormTimelessPainter(max: 1000, increasedData: ufec)),
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
                  child: CustomPaint(painter: WaveFormTimelessPainter(max: 1000, increasedData: ucrc)),
                ),
              ),
            ],
          );
        },
      ),
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
                final downFecTotal = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downFecTotal);
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
                final downCrcLast = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downCrcLast);
                final downCrcTotal = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downCrcTotal);
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
                final upFecLast = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upFecLast);
                final upFecTotal = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upFecTotal);
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
                final upCrcLast = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upCrcLast);
                final upCrcTotal = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upCrcTotal);
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
