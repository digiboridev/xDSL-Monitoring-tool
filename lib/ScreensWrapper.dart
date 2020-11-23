import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'screens/CurrentScreen.dart';
import 'screens/SavedDataScreen.dart';
import 'screens/SettingsScreen.dart';

import 'models/DataProvider.dart';

import 'package:move_to_background/move_to_background.dart';

class ScreensWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
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
    setState(() {
      _screenIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    //Load state data from hive store
    context.read<DataProvider>().updateCollections();
    context.read<DataProvider>().updateSettings();
    print('init');
  }

  //Starts or stop sampling
  void toogleSampling() async {
    bool isCounting = context.read<DataProvider>().isCounting;
    if (isCounting) {
      context.read<DataProvider>().stopCounter();
    } else {
      context.read<DataProvider>().startCounter();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.blueGrey[900],
        ),
        // body: _screenList[_screenIndex],
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          child: _screenList[_screenIndex],
        ),
        floatingActionButton: FloatingActionButton(
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
                  color: Colors.blueGrey[50],
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.blueGrey[50],
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
    return context.watch<DataProvider>().isCounting
        ? Icon(Icons.stop)
        : Icon(
            Icons.play_arrow,
          );
  }
}
