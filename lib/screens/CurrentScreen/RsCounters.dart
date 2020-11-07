import 'package:flutter/material.dart';

class RsCounters extends StatelessWidget {
  const RsCounters({Key key}) : super(key: key);

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
                    '50254',
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
                    '354',
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
                    '1254',
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
                    '354',
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
