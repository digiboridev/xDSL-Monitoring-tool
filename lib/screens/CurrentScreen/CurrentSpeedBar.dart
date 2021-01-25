import 'dart:async';

import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:xDSL_Monitoring_tool/models/ADSLDataModel.dart';
import 'package:xDSL_Monitoring_tool/models/DataSamplingService.dart';
import 'package:xDSL_Monitoring_tool/models/SettingsModel.dart';
import 'package:xDSL_Monitoring_tool/models/modemClients/LineStatsCollection.dart';

//Draw and animate current speed by canvas
class CurrentSpeedBar extends StatefulWidget {
  bool _isEmpty;

  CurrentSpeedBar(this._isEmpty);

  @override
  _CurrentSpeedBarState createState() => _CurrentSpeedBarState();
}

class _CurrentSpeedBarState extends State<CurrentSpeedBar>
    with TickerProviderStateMixin {
  //Speed vars
  double currDown = 0;
  double currUp = 0;
  double attainableDown = 0;
  double attainableUp = 0;

  //Animation vars
  AnimationController controller;
  Animation<double> currDownAnimation;
  Animation<double> currUpAnimation;
  Animation<double> attainableDownAnimation;
  Animation<double> attainableUpAnimation;

  //Init tweens fo animation
  Tween<double> currDownTween = Tween(begin: 0, end: 0);
  Tween<double> currUpTween = Tween(begin: 0, end: 0);
  Tween<double> attainableDownTween = Tween(begin: 0, end: 0);
  Tween<double> attainableUpTween = Tween(begin: 0, end: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Init animation controllers
    //Init main controller
    controller = AnimationController(
        vsync: this,
        duration: Duration(
            milliseconds:
                (context.read<SettingsModel>().getAnimated) ? 1000 : 0));

    //Extend main controller with curves
    //First curve for download speed
    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOut,
    );

    //second curve for upload speed
    final curvedAnimationAlt = CurvedAnimation(
      parent: controller,
      curve: Curves.bounceInOut,
      reverseCurve: Curves.easeOut,
    );

    //Init animations separately for all variables
    currDownAnimation = currDownTween.animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.stop();
        } else if (status == AnimationStatus.dismissed) {
          controller.stop();
        }
      });

    currUpAnimation = currUpTween.animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.stop();
        } else if (status == AnimationStatus.dismissed) {
          controller.stop();
        }
      });

    attainableDownAnimation = attainableDownTween.animate(curvedAnimationAlt)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.stop();
        } else if (status == AnimationStatus.dismissed) {
          controller.stop();
        }
      });

    attainableUpAnimation = attainableUpTween.animate(curvedAnimationAlt)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.stop();
        } else if (status == AnimationStatus.dismissed) {
          controller.stop();
        }
      });
    updateData(context);
  }

  @override
  void didUpdateWidget(covariant CurrentSpeedBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // update data in winget updating by parrent
    // prevent updating data on widget render
    Timer(Duration(milliseconds: 100), () => {updateData(context)});
  }

  void updateData(BuildContext context) {
    //Save old data before update for animation
    var currDownold = currDown;
    var currUpold = currUp;
    var attainableDownold = attainableDown;
    var attainableUpold = attainableUp;

    //Update data
    if (!context.read<DataSamplingService>().isCounting) {
      currDown = 0;
      currUp = 0;
      attainableDown = 0;
      attainableUp = 0;
      // return;
    } else if (widget._isEmpty) {
      currDown = 0;
      currUp = 0;
      attainableDown = 0;
      attainableUp = 0;
      // return;
    } else {
      LineStatsCollection asd =
          context.read<ADSLDataModel>().getLastCollection.last;
      currDown = asd.downRate?.toDouble() ?? 0;
      currUp = asd.upRate?.toDouble() ?? 0;
      attainableDown = asd.downMaxRate?.toDouble() ?? 0;
      attainableUp = asd.upMaxRate?.toDouble() ?? 0;
    }

    //Check for difference beetween old and new data
    //Start animation from old and to data

    if (currDown != currDownold ||
        currUp != currUpold ||
        attainableDown != attainableDownold ||
        attainableUp != attainableUpold) {
      currDownTween.begin = currDownold;
      currDownTween.end = currDown;
      currUpTween.begin = currUpold;
      currUpTween.end = currUp;
      attainableDownTween.begin = attainableDownold;
      attainableDownTween.end = attainableDown;
      attainableUpTween.begin = attainableUpold;
      attainableUpTween.end = attainableUp;
      controller.reset();
      controller.forward();
    }

    // if (currDown != currDownold) {
    //   currDownTween.begin = currDownold;
    //   currDownTween.end = currDown;
    //   controller.reset();
    //   controller.forward();
    // }
    // if (currUp != currUpold) {
    //   currUpTween.begin = currUpold;
    //   currUpTween.end = currUp;
    //   controller.reset();
    //   controller.forward();
    // }
    // if (attainableDown != attainableDownold) {
    //   attainableDownTween.begin = attainableDownold;
    //   attainableDownTween.end = attainableDown;
    //   controller.reset();
    //   controller.forward();
    // }
    // if (attainableUp != attainableUpold) {
    //   attainableUpTween.begin = attainableUpold;
    //   attainableUpTween.end = attainableUp;
    //   controller.reset();
    //   controller.forward();
    // }
  }

  //Stop controller on dispose
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(16),
          child: Text(
            'Current speed rates',
            style: TextStyle(
                color: Colors.blueGrey[900],
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 120,
                width: 120,
                child: CustomPaint(
                  painter: SpdPainter(
                      curr: currDownAnimation.value,
                      attainable: attainableDownAnimation.value,
                      max: 24000),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Down',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey[900],
                              fontWeight: FontWeight.w300)),
                      Text(
                        '${currDownAnimation.value.toInt()}/${attainableDownAnimation.value.toInt()}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blueGrey[900],
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        'Kbps',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey[900],
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 120,
                width: 120,
                child: CustomPaint(
                  painter: SpdPainter(
                      curr: currUpAnimation.value,
                      attainable: attainableUpAnimation.value,
                      max: 3000),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Up',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey[900],
                              fontWeight: FontWeight.w300)),
                      Text(
                          '${currUpAnimation.value.toInt()}/${attainableUpAnimation.value.toInt()}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey[900],
                              fontWeight: FontWeight.w300)),
                      Text('Kbps',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey[900],
                              fontWeight: FontWeight.w300))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

//Current speed animater circles paiter
class SpdPainter extends CustomPainter {
  double curr;
  double attainable;
  double max;
  SpdPainter({this.curr, this.attainable, this.max});

  double percentageCurr() {
    return curr > max ? 5.4 : 5.4 * curr / max;
  }

  double percentageAtta() {
    return attainable > max ? 5.4 : 5.4 * attainable / max;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & Size(size.width, size.height);
    canvas.drawArc(
        rect,
        2,
        5.4,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..color = Colors.blueGrey[200]);
    canvas.drawArc(
        rect,
        2,
        percentageAtta(),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..color = Colors.yellow[400]);
    canvas.drawArc(
        rect,
        2,
        percentageCurr(),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..color = Colors.blueGrey[800]);
  }

  @override
  bool shouldRepaint(SpdPainter oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(SpdPainter oldDelegate) => false;
}
