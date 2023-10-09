// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/widgets/text_styles.dart';

typedef MeterValue = ({double? value, double? min, double? max, double? avg, List<double?>? data});

class CurrentSNRBar extends StatelessWidget {
  const CurrentSNRBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Builder(
              builder: (context) {
                final data = context.select<StatsSamplingService, MeterValue>(
                  (s) => (
                    value: s.snapshotStats?.downSNRmLast,
                    min: s.snapshotStats?.downSNRmMin,
                    max: s.snapshotStats?.downSNRmMax,
                    avg: s.snapshotStats?.downSNRmAvg,
                    data: s.lastSamples.map((e) => e.downMargin).toList(),
                  ),
                );

                return Meter(name: 'SNRM DL', data: data, limit: 20, reverse: false);
              },
            ),
            Builder(
              builder: (context) {
                final data = context.select<StatsSamplingService, MeterValue>(
                  (s) => (
                    value: s.snapshotStats?.upSNRmLast,
                    min: s.snapshotStats?.upSNRmMin,
                    max: s.snapshotStats?.upSNRmMax,
                    avg: s.snapshotStats?.upSNRmAvg,
                    data: s.lastSamples.map((e) => e.upMargin).toList(),
                  ),
                );

                return Meter(name: 'SNRM UL', data: data, limit: 20, reverse: false);
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Builder(
              builder: (context) {
                final data = context.select<StatsSamplingService, MeterValue>(
                  (s) => (
                    value: s.snapshotStats?.upAttenuationLast,
                    min: s.snapshotStats?.upAttenuationMin,
                    max: s.snapshotStats?.upAttenuationMax,
                    avg: s.snapshotStats?.upAttenuationAvg,
                    data: s.lastSamples.map((e) => e.upAttenuation).toList(),
                  ),
                );
                return Meter(name: 'Att DL', data: data, limit: 100, reverse: true);
              },
            ),
            Builder(
              builder: (context) {
                final data = context.select<StatsSamplingService, MeterValue>(
                  (s) => (
                    value: s.snapshotStats?.upAttenuationLast,
                    min: s.snapshotStats?.upAttenuationMin,
                    max: s.snapshotStats?.upAttenuationMax,
                    avg: s.snapshotStats?.upAttenuationAvg,
                    data: s.lastSamples.map((e) => e.upAttenuation).toList(),
                  ),
                );
                return Meter(name: 'Att UL', data: data, limit: 100, reverse: true);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class Meter extends StatelessWidget {
  final String name;
  final MeterValue data;
  final num limit;
  final bool reverse;

  const Meter({
    Key? key,
    required this.name,
    required this.data,
    required this.limit,
    required this.reverse,
  }) : super(key: key);

  double getWidth() {
    if (data.value == null) return 150;
    if (data.value! >= limit) return reverse ? 150 : 0;

    double pre = 150 * data.value! / limit;
    return reverse ? pre : 150 - pre;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        head(),
        SizedBox(height: 4),
        value(),
        SizedBox(height: 4),
        SizedBox(
          // height: 20,
          width: 150,
          child: Linechart(data: data.data ?? []),
        ),
        ranges(),
      ],
    );
  }

  Widget head() {
    return SizedBox(
      width: 150,
      child: Text(
        '$name: ${data.value?.toStringAsFixed(1) ?? 'N/A'}',
        style: TextStyles.f14w3.blueGrey800,
      ),
    );
  }

  Widget value() {
    return Container(
      width: 150,
      height: 4,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueGrey.shade900,
                  Colors.blueGrey.shade900,
                  Colors.yellow.shade300,
                  Colors.yellow.shade300,
                  Colors.yellow.shade300,
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.elasticOut,
              color: Colors.blueGrey.shade200,
              width: getWidth(),
              height: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget ranges() {
    return SizedBox(
      width: 150,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('${data.min?.toStringAsFixed(1) ?? 'N/A'} MIN', style: TextStyles.f10.blueGrey600),
          SizedBox(width: 4),
          Text('${data.max?.toStringAsFixed(1) ?? 'N/A'} MAX', style: TextStyles.f10.blueGrey600),
          SizedBox(width: 4),
          Text('${data.avg?.toStringAsFixed(1) ?? 'N/A'} AVG', style: TextStyles.f10.blueGrey600),
        ],
      ),
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
      // padding: EdgeInsets.all(2),
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

class LineChartPainter extends CustomPainter {
  final Color lineColor;
  final double lineWidth;
  final double absMargin;
  final List<double?> data;
  LineChartPainter(this.data, {this.lineColor = Colors.blueGrey, this.lineWidth = 1, this.absMargin = 0.1});

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(LineChartPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final double step = size.width / data.length;
    final List<double> dataWithoutNulls = data.where((element) => element != null).toList().cast();
    final double dataMaxHeight = dataWithoutNulls.reduce((value, element) => value > element ? value : element);
    final double dataMinHeight = dataWithoutNulls.reduce((value, element) => value < element ? value : element);
    final double maxHeight = dataMaxHeight + absMargin;
    final double minHeight = dataMinHeight - absMargin;

    for (int i = 0; i < data.length - 1; i++) {
      bool hasCurrentAndNext = data[i] != null && data[i + 1] != null;
      if (!hasCurrentAndNext) continue;
      bool isCurrentAndNextPositive = data[i]! >= 0 && data[i + 1]! >= 0;
      if (!isCurrentAndNextPositive) continue;

      final double x1 = i * step;
      final double y1 = size.height - ((data[i]! - minHeight) / (maxHeight - minHeight)) * size.height;
      final double x2 = (i + 1) * step;
      final double y2 = size.height - ((data[i + 1]! - minHeight) / (maxHeight - minHeight)) * size.height;

      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.blueGrey.shade700,
      );
    }
  }
}
