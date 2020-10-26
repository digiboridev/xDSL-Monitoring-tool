import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'screens/CurrentScreen.dart';
import 'screens/SavedDataScreen.dart';
import 'screens/SettingsScreen.dart';

import 'models/DataProvider.dart';

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
    context.read<DataProvider>().updateCollections();
    context.read<DataProvider>().updateSettings();
    print('init');
  }

  void toogleSampling() {
    bool isCounting = context.read<DataProvider>().isCounting;
    if (isCounting) {
      context.read<DataProvider>().stopCounter();
    } else {
      context.read<DataProvider>().startCounter();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Render buttonbar');

    return Scaffold(
      appBar: AppBar(
        title: Text(_screenList[_screenIndex].name),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: _screenList[_screenIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => toogleSampling(),
        child: context.watch<DataProvider>().isCounting
            ? Icon(Icons.stop)
            : Icon(Icons.play_arrow),
        hoverColor: Colors.amber[100],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _screenIndex,
        onTap: selectScreen,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.timeline), title: Text('Current')),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), title: Text('Saved data')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Setup'))
        ],
      ),
    );
  }
}
