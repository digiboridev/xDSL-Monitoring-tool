import 'dart:async';

import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dslstats/models/DataProvider.dart';

class CurrentSNRBar extends StatefulWidget {
  bool _isEmpty;

  CurrentSNRBar(this._isEmpty);

  @override
  _CurrentSNRBarState createState() => _CurrentSNRBarState();
}

class _CurrentSNRBarState extends State<CurrentSNRBar> {
  double downSNRM = 0;

  double upSNRM = 0;

  double downAtt = 100;

  double upAtt = 100;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(milliseconds: 300), () => {getLastSNRM(context)});
  }

  @override
  void didUpdateWidget(covariant CurrentSNRBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getLastSNRM(context);
  }

  void getLastSNRM(BuildContext context) {
    if (!context.read<DataProvider>().isCounting) {
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
      LineStatsCollection asd =
          context.read<DataProvider>().getLastCollection.last;

      setState(() {
        downSNRM = asd.downMargin ?? 0;
        upSNRM = asd.upMargin ?? 0;
        downAtt = asd.downAttenuation ?? 100;
        upAtt = asd.upAttenuation ?? 100;
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
            child: Text('SNR Margin / Attenuation',
                style: TextStyle(
                    color: Colors.blueGrey[900],
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Meter(
                name: 'SNRMd',
                value: downSNRM,
                max: 20,
                reverse: false,
              ),
              Meter(
                name: 'Att D',
                value: downAtt,
                max: 100,
                reverse: true,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Meter(
                name: 'SNRMu',
                value: upSNRM,
                max: 20,
                reverse: false,
              ),
              Meter(
                name: 'Attu',
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
  String name;
  double value;
  double max;
  bool reverse;

  Meter(
      {@required this.name,
      @required this.value,
      @required this.max,
      @required this.reverse});

  double getWidth() {
    if (value >= max) {
      return reverse ? 120 : 0;
    }
    double pre = 120 * value / max;
    return reverse ? pre : 120 - pre;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: Column(children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${name}: ${value}',
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
                    Colors.blueGrey[900],
                    Colors.blueGrey[900],
                    Colors.yellow[300],
                    Colors.yellow[300],
                    Colors.yellow[200]
                  ])),
          width: 120,
          height: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.bounceOut,
                decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6))),
                // color: Colors.blueGrey[200],
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
