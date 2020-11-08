import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dslstats/models/DataProvider.dart';

class RsCounters extends StatefulWidget {
  bool _isEmpty;

  RsCounters(this._isEmpty);

  @override
  _RsCountersState createState() => _RsCountersState();
}

class _RsCountersState extends State<RsCounters> {
  int RsCorrD = 0;
  int RsCorrU = 0;
  int RsUnCorrD = 0;
  int RsUnCorrU = 0;

  @override
  void didUpdateWidget(covariant RsCounters oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getLastRS(context);
  }

  void getLastRS(BuildContext context) {
    if (!context.read<DataProvider>().isCounting) {
      setState(() {
        RsCorrD = 0;
        RsCorrU = 0;
        RsUnCorrD = 0;
        RsUnCorrU = 0;
      });
    } else if (widget._isEmpty) {
      setState(() {
        RsCorrD = 0;
        RsCorrU = 0;
        RsUnCorrD = 0;
        RsUnCorrU = 0;
      });
    } else {
      LineStatsCollection asd =
          context.read<DataProvider>().getLastCollection.last;

      setState(() {
        RsCorrD = asd.downFEC ?? 0;
        RsCorrU = asd.upFEC ?? 0;
        RsUnCorrD = asd.downCRC ?? 0;
        RsUnCorrU = asd.upCRC ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var tstyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 10);
    var tstyleh = TextStyle(fontWeight: FontWeight.w300, fontSize: 14);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(16),
          child: Text('Error correction',
              style: TextStyle(
                  color: Colors.blueGrey[900],
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ),
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RsCorrD',
                    style: tstyle,
                  ),
                  Text(
                    RsCorrD.toString(),
                    style: tstyleh,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RsUncorrD',
                    style: tstyle,
                  ),
                  Text(
                    RsUnCorrD.toString(),
                    style: tstyleh,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RsCorrU',
                    style: tstyle,
                  ),
                  Text(
                    RsCorrU.toString(),
                    style: tstyleh,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RsUncorrU',
                    style: tstyle,
                  ),
                  Text(
                    RsUnCorrU.toString(),
                    style: tstyleh,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
