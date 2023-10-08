// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/widgets/text_styles.dart';

typedef MeterValue = ({double? value, double? min, double? max, double? avg});

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
        SizedBox(
          width: 150,
          child: Text(
            '$name: ${data.value?.toStringAsFixed(1) ?? 'N/A'}',
            style: TextStyles.f14w3.blueGrey800,
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: 150,
          height: 8,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade900, Colors.yellow.shade300, Colors.yellow.shade300, Colors.yellow.shade300],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.bounceOut,
                color: Colors.blueGrey.shade200,
                width: getWidth(),
                height: 8,
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
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
        ),
      ],
    );
  }
}
