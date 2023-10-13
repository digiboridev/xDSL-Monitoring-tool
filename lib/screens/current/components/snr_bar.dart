// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/widgets/line_chart_painter.dart';
import 'package:xdslmt/widgets/linebar.dart';
import 'package:xdslmt/widgets/text_styles.dart';

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
                    child: Builder(builder: (context) {
                      final v = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downSNRmLast);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SNRM Down: ${v?.oneFrStr ?? 'N/A'}', style: TextStyles.f12),
                          Text('dB', style: TextStyles.f10w3.blueGrey800),
                          SizedBox(width: 4),
                          SizedBox(width: 4, height: 16, child: LineBar(value: v ?? 0, min: 0, max: 160)),
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final v = context.watch<StatsSamplingService>().lastSamples;
                      final s = v.map((e) => e.downMargin).toList();
                      if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                      return LineChart(s: s, invert: false);
                    }),
                  ),
                  SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final min = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downSNRmMin);
                      final max = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downSNRmMax);
                      final avg = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downSNRmAvg);
                      return MinMaxAvgRow(min: min, max: max, avg: avg);
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final v = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upSNRmLast);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SNRM Up: ${v?.oneFrStr ?? 'N/A'}', style: TextStyles.f12),
                          Text('dB', style: TextStyles.f10w3.blueGrey800),
                          SizedBox(width: 4),
                          SizedBox(width: 4, height: 16, child: LineBar(value: v ?? 0, min: 0, max: 160)),
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final v = context.watch<StatsSamplingService>().lastSamples;
                      final s = v.map((e) => e.upMargin).toList();
                      if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                      return LineChart(s: s, invert: false);
                    }),
                  ),
                  SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final min = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upSNRmMin);
                      final max = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upSNRmMax);
                      final avg = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upSNRmAvg);
                      return MinMaxAvgRow(min: min, max: max, avg: avg);
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final v = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downAttenuationLast);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ATN Down:  ${v?.oneFrStr ?? 'N/A'}', style: TextStyles.f12),
                          Text('dB', style: TextStyles.f10w3.blueGrey800),
                          SizedBox(width: 4),
                          SizedBox(width: 4, height: 16, child: LineBar(value: 1000 - (v ?? 1000), min: 0, max: 1000)),
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final v = context.watch<StatsSamplingService>().lastSamples;
                      final s = v.map((e) => e.downAttenuation).toList();
                      if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                      return LineChart(s: s, invert: true);
                    }),
                  ),
                  SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final min = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downAttenuationMin);
                      final max = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downAttenuationMax);
                      final avg = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.downAttenuationAvg);
                      return MinMaxAvgRow(min: min, max: max, avg: avg);
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final v = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upAttenuationLast);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ATN Up:  ${v?.oneFrStr ?? 'N/A'}', style: TextStyles.f12),
                          Text('dB', style: TextStyles.f10w3.blueGrey800),
                          SizedBox(width: 4),
                          SizedBox(width: 4, height: 16, child: LineBar(value: 1000 - (v ?? 1000), min: 0, max: 1000)),
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final v = context.watch<StatsSamplingService>().lastSamples;
                      final s = v.map((e) => e.upAttenuation).toList();
                      if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                      return LineChart(s: s, invert: true);
                    }),
                  ),
                  SizedBox(height: 4),
                  RepaintBoundary(
                    child: Builder(builder: (context) {
                      final min = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upAttenuationMin);
                      final max = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upAttenuationMax);
                      final avg = context.select<StatsSamplingService, int?>((s) => s.snapshotStats?.upAttenuationAvg);
                      return MinMaxAvgRow(min: min, max: max, avg: avg);
                    }),
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
  const LineChart({super.key, required this.s, required this.invert});

  final List<int?> s;
  final bool invert;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: double.infinity,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan.shade100),
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: CustomPaint(painter: LineChartPainter(s, invert)),
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
        Text('${min?.oneFrStr ?? 'N/A'} MIN', style: TextStyles.f10.blueGrey600),
        SizedBox(width: 4),
        Text('${max?.oneFrStr ?? 'N/A'} MAX', style: TextStyles.f10.blueGrey600),
        SizedBox(width: 4),
        Text('${avg?.oneFrStr ?? 'N/A'} AVG', style: TextStyles.f10.blueGrey600),
      ],
    );
  }
}
