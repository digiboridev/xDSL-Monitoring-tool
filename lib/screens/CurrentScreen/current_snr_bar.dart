import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/models/adsl_data_model.dart';
import 'package:xdsl_mt/models/data_sampling_service.dart';
import 'package:xdsl_mt/models/modemClients/line_stats_collection.dart';
import 'package:xdsl_mt/models/settings_model.dart';

class CurrentSNRBar extends StatefulWidget {
  final bool _isEmpty;

  const CurrentSNRBar(this._isEmpty, {super.key});

  @override
  State<CurrentSNRBar> createState() => _CurrentSNRBarState();
}

class _CurrentSNRBarState extends State<CurrentSNRBar> {
  double downSNRM = 0;
  double upSNRM = 0;
  double downAtt = 100;
  double upAtt = 100;
  double minSnrD = 0;
  double minSnrU = 0;
  double maxSnrD = 0;
  double maxSnrU = 0;

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 300), () => loadData(context));
  }

  @override
  void didUpdateWidget(covariant CurrentSNRBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadData(context);
  }

  void loadData(BuildContext context) {
    if (!context.read<DataSamplingService>().isCounting) {
      setState(() {
        downSNRM = 0;
        upSNRM = 0;
        downAtt = 100;
        upAtt = 100;
      });
    } else if (widget._isEmpty) {
      setState(() {
        downSNRM = 0;
        upSNRM = 0;
        downAtt = 100;
        upAtt = 100;
      });
    } else {
      List<LineStatsCollection> lastCollMap = context.read<ADSLDataModel>().getLastCollection;

      LineStatsCollection collection = lastCollMap.last;

      //Find min value of snrmu
      double snrmuMin() {
        List<double> acc = [];

        for (var i = 0; i < lastCollMap.length; i++) {
          if (lastCollMap[i].upMargin < 2) {
            continue;
          }
          acc.add(lastCollMap[i].upMargin);
        }

        if (acc.isEmpty) {
          return 0;
        }

        return acc.reduce((value, element) => value > element ? element : value);
      }

      //Find min value of snrmd
      double snrmdMin() {
        List<double> acc = [];

        for (var i = 0; i < lastCollMap.length; i++) {
          if (lastCollMap[i].downMargin < 2) {
            continue;
          }
          acc.add(lastCollMap[i].downMargin);
        }

        if (acc.isEmpty) {
          return 0;
        }

        return acc.reduce((value, element) => value > element ? element : value);
      }

      //Find max value of snrmd
      double snrmdMax() {
        List<double> acc = [];

        for (var i = 0; i < lastCollMap.length; i++) {
          if (lastCollMap[i].downMargin < 2) {
            continue;
          }
          acc.add(lastCollMap[i].downMargin);
        }

        if (acc.isEmpty) {
          return 0;
        }

        return acc.reduce((value, element) => value < element ? element : value);
      }

      //Find max value of snrmu
      double snrmuMax() {
        List<double> acc = [];

        for (var i = 0; i < lastCollMap.length; i++) {
          if (lastCollMap[i].upMargin < 2) {
            continue;
          }
          acc.add(lastCollMap[i].upMargin);
        }

        if (acc.isEmpty) {
          return 0;
        }

        return acc.reduce((value, element) => value < element ? element : value);
      }

      setState(() {
        downSNRM = collection.downMargin;
        upSNRM = collection.upMargin;
        downAtt = collection.downAttenuation;
        upAtt = collection.upAttenuation;
        maxSnrD = snrmdMax();
        maxSnrU = snrmuMax();
        minSnrD = snrmdMin();
        minSnrU = snrmuMin();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: Text(
              'SNR Margin / Attenuation',
              style: TextStyle(
                color: Colors.blueGrey.shade900,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Meter(
                name: 'SNRM DL',
                value: downSNRM,
                max: 20,
                reverse: false,
              ),
              Meter(
                name: 'SNRM UL',
                value: upSNRM,
                max: 20,
                reverse: false,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'min: $minSnrD max: $maxSnrD',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                ),
                Text(
                  'min: $minSnrU  max: $maxSnrU',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Meter(
                name: 'Att DL',
                value: downAtt,
                max: 100,
                reverse: true,
              ),
              Meter(
                name: 'Att UL',
                value: upAtt,
                max: 100,
                reverse: true,
              )
            ],
          )
        ],
      ),
    );
  }
}

class Meter extends StatelessWidget {
  final String name;
  final double value;
  final double max;
  final bool reverse;

  const Meter({super.key, required this.name, required this.value, required this.max, required this.reverse});

  double getWidth() {
    if (value >= max) {
      return reverse ? 120 : 0;
    }
    double pre = 120 * value / max;
    return reverse ? pre : 120 - pre;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$name: $value',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.blueGrey.shade900,
                Colors.blueGrey.shade900,
                Colors.yellow.shade300,
                Colors.yellow.shade300,
                Colors.yellow.shade300,
              ],
            ),
          ),
          width: 120,
          height: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: (context.watch<SettingsModel>().getAnimated ? 1000 : 0)),
                curve: Curves.bounceOut,
                decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200, borderRadius: BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6))),
                // color: Colors.blueGrey.shade200,
                width: getWidth(),
                height: 6,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
