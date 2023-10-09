// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  Builder(builder: (context) {
                    final v = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.downSNRmLast);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SNR Down: ${v?.toStringAsFixed(1) ?? 'N/A'}', style: TextStyles.f14w3.blueGrey800),
                        SizedBox(width: 4),
                        SizedBox(width: 4, height: 14, child: LineBar(value: v ?? 0, min: 0, max: 20)),
                      ],
                    );
                  }),
                  Builder(builder: (context) {
                    final v = context.watch<StatsSamplingService>().lastSamples;
                    final s = v.map((e) => e.downMargin).toList();
                    if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                    return Container(
                      height: 20,
                      width: double.infinity,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan.shade100),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: CustomPaint(painter: LineChartPainter(s)),
                    );
                  }),
                  Builder(builder: (context) {
                    final min = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.downSNRmMin);
                    final max = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.downSNRmMax);
                    final avg = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.downSNRmAvg);
                    return MinMaxAvgRow(min: min, max: max, avg: avg);
                  }),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  Builder(builder: (context) {
                    final v = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.upSNRmLast);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SNR Up: ${v?.toStringAsFixed(1) ?? 'N/A'}', style: TextStyles.f14w3.blueGrey800),
                        SizedBox(width: 4),
                        SizedBox(width: 4, height: 14, child: LineBar(value: v ?? 0, min: 0, max: 20)),
                      ],
                    );
                  }),
                  Builder(builder: (context) {
                    final v = context.watch<StatsSamplingService>().lastSamples;
                    final s = v.map((e) => e.upMargin).toList();
                    if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                    return Container(
                      height: 20,
                      width: double.infinity,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan.shade100),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: CustomPaint(painter: LineChartPainter(s)),
                    );
                  }),
                  Builder(builder: (context) {
                    final min = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.upSNRmMin);
                    final max = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.upSNRmMax);
                    final avg = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.upSNRmAvg);
                    return MinMaxAvgRow(min: min, max: max, avg: avg);
                  }),
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
                  Builder(builder: (context) {
                    final v = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.downAttenuationLast);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Att Down: ${v?.toStringAsFixed(1) ?? 'N/A'}', style: TextStyles.f14w3.blueGrey800),
                        SizedBox(width: 4),
                        SizedBox(width: 4, height: 14, child: LineBar(value: 100 - (v ?? 100), min: 0, max: 100)),
                      ],
                    );
                  }),
                  Builder(builder: (context) {
                    final v = context.watch<StatsSamplingService>().lastSamples;
                    final s = v.map((e) => e.downAttenuation).toList();
                    if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                    return Container(
                      height: 20,
                      width: double.infinity,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan.shade100),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: CustomPaint(painter: LineChartPainter(s)),
                    );
                  }),
                  Builder(builder: (context) {
                    final min = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.downAttenuationMin);
                    final max = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.downAttenuationMax);
                    final avg = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.downAttenuationAvg);
                    return MinMaxAvgRow(min: min, max: max, avg: avg);
                  }),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  Builder(builder: (context) {
                    final v = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.upAttenuationLast);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Att Up: ${v?.toStringAsFixed(1) ?? 'N/A'}', style: TextStyles.f14w3.blueGrey800),
                        SizedBox(width: 4),
                        SizedBox(width: 4, height: 14, child: LineBar(value: 100 - (v ?? 100), min: 0, max: 100)),
                      ],
                    );
                  }),
                  Builder(builder: (context) {
                    final v = context.watch<StatsSamplingService>().lastSamples;
                    final s = v.map((e) => e.upAttenuation).toList();
                    if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                    return Container(
                      height: 20,
                      width: double.infinity,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan.shade100),
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      child: CustomPaint(painter: LineChartPainter(s)),
                    );
                  }),
                  Builder(builder: (context) {
                    final min = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.upAttenuationMin);
                    final max = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.upAttenuationMax);
                    final avg = context.select<StatsSamplingService, double?>((s) => s.snapshotStats?.upAttenuationAvg);
                    return MinMaxAvgRow(min: min, max: max, avg: avg);
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MinMaxAvgRow extends StatelessWidget {
  final double? min;
  final double? max;
  final double? avg;
  const MinMaxAvgRow({Key? key, this.min, this.max, this.avg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${min?.toStringAsFixed(1) ?? 'N/A'} MIN', style: TextStyles.f10.blueGrey600),
        SizedBox(width: 4),
        Text('${max?.toStringAsFixed(1) ?? 'N/A'} MAX', style: TextStyles.f10.blueGrey600),
        SizedBox(width: 4),
        Text('${avg?.toStringAsFixed(1) ?? 'N/A'} AVG', style: TextStyles.f10.blueGrey600),
      ],
    );
  }
}
