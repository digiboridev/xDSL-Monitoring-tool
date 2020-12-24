import 'dart:io';

import 'package:dslstats/models/ADSLDataModel.dart';
import 'package:dslstats/models/DataSamplingService.dart';
import 'package:dslstats/models/SettingsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screens/CurrentScreen.dart';
import 'screens/SavedDataScreen.dart';
import 'screens/SettingsScreen.dart';

import 'package:move_to_background/move_to_background.dart';

class ScreensWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ADSLDataModel()),
        ChangeNotifierProvider(create: (_) => DataSamplingService()),
        ChangeNotifierProvider(create: (_) => SettingsModel()),
      ],
      child: MaterialApp(
        title: 'DslStats',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: ButtonDisplaySelection(),
      ),
    );
  }
}

class ButtonDisplaySelection extends StatefulWidget {
  ButtonDisplaySelection({Key key}) : super(key: key);

  @override
  _ButtonDisplaySelectionState createState() => _ButtonDisplaySelectionState();
}

class _ButtonDisplaySelectionState extends State<ButtonDisplaySelection> {
  //import screens as list
  List _screenList = [CurrentScreen(), SavedDataScreen(), SettingsScreen()];

  //screenindex
  int _screenIndex = 0;

  //screen index setter
  void selectScreen(int index) {
    bool isCounting = context.read<DataSamplingService>().isCounting;
    if (isCounting & (index == 2)) {
      print('blocket');
      return;
    }
    setState(() {
      _screenIndex = index;
    });
  }

  //Starts or stop sampling
  void toogleSampling() async {
    bool isCounting = context.read<DataSamplingService>().isCounting;
    if (isCounting) {
      context.read<DataSamplingService>().stopSampling();
      context.read<ADSLDataModel>().saveLastCollection();
    } else {
      context.read<ADSLDataModel>().createCollection();
      context
          .read<DataSamplingService>()
          .startSampling(context.read<ADSLDataModel>().addToLast);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<SettingsModel>().getOrient) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    }

    print('Render screens wrapper');

    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        print('minimized');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_screenList[_screenIndex].name),
          actions: [
            IconButton(
                tooltip: 'minimize app',
                icon: Icon(
                  Icons.minimize,
                  color: Colors.white,
                ),
                onPressed: () {
                  MoveToBackground.moveTaskToBack();
                  print('minimized');
                }),
            IconButton(
                tooltip: 'Close app',
                icon: Icon(
                  Icons.power_settings_new,
                  color: Colors.white,
                ),
                onPressed: () {
                  FlutterForegroundPlugin.stopForegroundService();
                  exit(0);
                })
          ],
          backgroundColor: Colors.blueGrey[900],
        ),
        // body: _screenList[_screenIndex],
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _screenList[_screenIndex],
        ),
        floatingActionButton: _screenIndex == 2
            ? null
            : FloatingActionButton(
                onPressed: () => toogleSampling(),
                child: FloatBtnIcon(),
                hoverColor: Colors.amber[100],
              ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueGrey[900],
          currentIndex: _screenIndex,
          onTap: selectScreen,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.timeline,
                  color: Colors.blueGrey[50],
                ),
                title: Text(
                  'Monitoring',
                  style: TextStyle(
                    color: Colors.blueGrey[50],
                  ),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                  color: Colors.blueGrey[50],
                ),
                title: Text(
                  'Snapshots',
                  style: TextStyle(
                    color: Colors.blueGrey[50],
                  ),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                  color: context.watch<DataSamplingService>().isCounting
                      ? Colors.blueGrey[600]
                      : Colors.blueGrey[50],
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: context.watch<DataSamplingService>().isCounting
                        ? Colors.blueGrey[600]
                        : Colors.blueGrey[50],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

//Return icon by sampling status
//Prevent screens wrapper from rerender
class FloatBtnIcon extends StatelessWidget {
  const FloatBtnIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('flbtn render');
    bool isCounting = context.select((DataSamplingService c) => c.isCounting);
    return isCounting
        ? Icon(Icons.stop)
        : Icon(
            Icons.play_arrow,
          );
  }
}
