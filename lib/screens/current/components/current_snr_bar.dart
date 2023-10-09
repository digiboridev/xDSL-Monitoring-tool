// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/widgets/line_chart_painter.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class CurrentSNRBar extends StatelessWidget {
  const CurrentSNRBar({super.key});

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
                    return Text('SNR Down: ${v?.toStringAsFixed(1) ?? 'N/A'}', style: TextStyles.f14w3.blueGrey800);
                  }),
                  Builder(builder: (context) {
                    final v = context.watch<StatsSamplingService>().lastSamples;
                    final s = v.map((e) => e.downMargin).toList();
                    if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                    return Container(
                      // key: ObjectKey(s),
                      height: 20,
                      width: double.infinity,
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
                    return Text('SNR Up: ${v?.toStringAsFixed(1) ?? 'N/A'}', style: TextStyles.f14w3.blueGrey800);
                  }),
                  Builder(builder: (context) {
                    final v = context.watch<StatsSamplingService>().lastSamples;
                    final s = v.map((e) => e.upMargin).toList();
                    if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                    return Container(
                      // key: ObjectKey(s),
                      height: 20,
                      width: double.infinity,
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
                    return Text('Att Down: ${v?.toStringAsFixed(1) ?? 'N/A'}', style: TextStyles.f14w3.blueGrey800);
                  }),
                  Builder(builder: (context) {
                    final v = context.watch<StatsSamplingService>().lastSamples;
                    final s = v.map((e) => e.downAttenuation).toList();
                    if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                    return Container(
                      // key: ObjectKey(s),
                      height: 20,
                      width: double.infinity,
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
                    return Text('Att Up: ${v?.toStringAsFixed(1) ?? 'N/A'}', style: TextStyles.f14w3.blueGrey800);
                  }),
                  Builder(builder: (context) {
                    final v = context.watch<StatsSamplingService>().lastSamples;
                    final s = v.map((e) => e.upAttenuation).toList();
                    if (s.length < 100) s.insertAll(0, List.filled(100 - s.length, null));
                    return Container(
                      // key: ObjectKey(s),
                      height: 20,
                      width: double.infinity,
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

class Linechart extends StatefulWidget {
  final List<double?> data;
  const Linechart({super.key, required this.data});

  @override
  State<Linechart> createState() => _LinechartState();
}

class _LinechartState extends State<Linechart> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.all(2),
      clipBehavior: Clip.hardEdge,
      duration: Duration(seconds: 1),
      curve: Curves.easeOutCubic,
      height: widget.data.length < 2 ? 0 : 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan.shade100),
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: CustomPaint(painter: LineChartPainter(widget.data)),
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
