import 'dart:async';

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
    return asd.dateTime.toString().substring(11, 19);
  }

  String getStatus(BuildContext context) {
    if (_isEmpty) {
      return 'unknown';
    }
    LineStatsCollection asd =
        context.watch<DataProvider>().getLastCollection.last;
    return asd.status;
  }

  String getType(BuildContext context) {
    if (_isEmpty) {
      return 'unknown';
    }
    LineStatsCollection asd =
        context.watch<DataProvider>().getLastCollection.last;
    return asd.connectionType;
  }

  String getStatusString(BuildContext context) {
    if (_isEmpty) {
      return 'unknown';
    }

    return (context.watch<DataProvider>().isCounting
            ? '${getStatus(context)}  '
            : '') +
        (getDSLStatus(context) ? getType(context) : '') +
        '  ${getLastSync(context)}';
  }

  @override
  Widget build(BuildContext context) {
    print('render statusbar');
    return Column(
      children: [
        Container(
          color: Colors.blueGrey[700],
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
                  getStatusString(context),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          ),
        ),
        ProgressLine(_isEmpty)
      ],
    );
  }
}

// Draws animated line when sampling is running
class ProgressLine extends StatefulWidget {
  bool _isEmpty;
  ProgressLine(this._isEmpty);

  @override
  _ProgressLineState createState() => _ProgressLineState();
}

class _ProgressLineState extends State<ProgressLine>
    with TickerProviderStateMixin {
  //Animation vars
  AnimationController controller;
  Animation<double> animation;
  Tween<double> animTween = Tween(begin: 0, end: 0);
  double progress = 1;
  int old = 0;

  @override
  void initState() {
    super.initState();

    //Init animation controller

    controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds: context.read<DataProvider>().getSamplingInterval));

    //Extend main controller with curve
    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.slowMiddle,
      reverseCurve: Curves.easeOut,
    );

    //Init animation
    animation = animTween.animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
        } else if (status == AnimationStatus.dismissed) {
          controller.reset();
        }
      });
  }

  @override
  void didUpdateWidget(covariant ProgressLine oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    //Return if collection is empty
    if (widget._isEmpty) {
      return;
    }

    //Load current collection length
    var now = context.read<DataProvider>().getLastCollection.length;

    //Compare current length with previous
    if (old != now) {
      //Skip if init value
      if (old == 0) {
        old = now;
        return;
      }

      //Set new value as old value and start animation
      old = now;
      animTween.begin = 0;
      animTween.end = 1;
      controller.reset();
      controller.forward();
    }
  }

  //Stop controller on dispose
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 3,
        width: MediaQuery.of(context).size.width * 1,
        color: Colors.blueGrey[50],
        child: Row(
          children: [
            Container(
              color: Colors.yellow[700],
              height: 3,
              width: MediaQuery.of(context).size.width * animation.value ?? 0,
            )
          ],
        ));
  }
}
