import 'package:dslstats/models/modemClients/LineStatsCollection.dart';
import 'package:provider/provider.dart';
import 'package:dslstats/models/DataProvider.dart';
import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  bool _isEmpty;

  StatusBar(this._isEmpty);

  bool getConnectionStatus(BuildContext context) {
    if (!context.watch<DataProvider>().isCounting) {
      return false;
    } else if (_isEmpty) {
      return false;
    } else {
      LineStatsCollection asd =
          context.watch<DataProvider>().getLastCollection.last;
      return asd.isErrored ? false : true;
    }
  }

  bool getDSLStatus(BuildContext context) {
    if (!context.watch<DataProvider>().isCounting) {
      return false;
    } else if (_isEmpty) {
      return false;
    } else if (context.watch<DataProvider>().getLastCollection.last.isErrored) {
      return false;
    } else {
      LineStatsCollection asd =
          context.watch<DataProvider>().getLastCollection.last;
      return asd.isConnectionUp ? true : false;
    }
  }

  String getLastSync(BuildContext context) {
    if (_isEmpty) {
      return 'unknown';
    }
    LineStatsCollection asd =
        context.watch<DataProvider>().getLastCollection.last;
    return asd.dateTime.toString().substring(0, 19);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  'S/C/DSL',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
                Container(
                  width: 10,
                  margin: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: context.watch<DataProvider>().isCounting
                            ? Colors.yellow
                            : Colors.black,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  width: 10,
                  margin: EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: getConnectionStatus(context)
                            ? Colors.yellow
                            : Colors.black,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                ),
                Container(
                  width: 10,
                  margin: EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: getDSLStatus(context)
                            ? Colors.yellow
                            : Colors.black,
                        width: 5,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ],
            ),
            Text(
              'Last sync: ${getLastSync(context)}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
    );
  }
}
