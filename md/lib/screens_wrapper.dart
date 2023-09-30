// import 'dart:io';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:xdsl_mt/models/data_sampling_service.dart';
import 'package:xdsl_mt/models/settings_model.dart';
import 'package:xdsl_mt/models/adsl_data_model.dart';

import 'screens/CurrentScreen.dart';
import 'screens/saved_data_screen.dart';
import 'screens/settings_screen.dart';

import 'package:move_to_background/move_to_background.dart';

class ScreensWrapper extends StatelessWidget {
  const ScreensWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ADSLDataModel()),
        ChangeNotifierProvider(create: (_) => DataSamplingService()),
        ChangeNotifierProvider(create: (_) => SettingsModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DslStats',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: const ButtonDisplaySelection(),
      ),
    );
  }
}

class ButtonDisplaySelection extends StatefulWidget {
  const ButtonDisplaySelection({super.key});

  @override
  State<ButtonDisplaySelection> createState() => _ButtonDisplaySelectionState();
}

class _ButtonDisplaySelectionState extends State<ButtonDisplaySelection> {
  //import screens as list
  final List _screenList = [CurrentScreen(), SavedDataScreen(), const SettingsScreen()];

  //screenindex
  int _screenIndex = 0;

  //screen index setter
  void selectScreen(int index) {
    bool isCounting = context.read<DataSamplingService>().isCounting;
    if (isCounting & (index == 2)) {
      debugPrint('blocket');
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
      context.read<DataSamplingService>().startSampling(context.read<ADSLDataModel>().addToLast);
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
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      );
    }

    debugPrint('Render screens wrapper');

    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        debugPrint('minimized');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Screen: $_screenIndex'),
          actions: [
            IconButton(
              tooltip: 'minimize app',
              icon: const Icon(
                Icons.minimize,
                color: Colors.white,
              ),
              onPressed: () {
                MoveToBackground.moveTaskToBack();
                debugPrint('minimized');
              },
            ),
            IconButton(
              tooltip: 'Close app',
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              onPressed: () {
                // TODO
                // FlutterForegroundPlugin.stopForegroundService();
                exit(0);
              },
            ),
          ],
          backgroundColor: Colors.blueGrey.shade900,
        ),
        // body: _screenList[_screenIndex],
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _screenList[_screenIndex],
        ),
        floatingActionButton: _screenIndex == 2
            ? null
            : FloatingActionButton(
                onPressed: () => toogleSampling(),
                hoverColor: Colors.amber[100],
                child: const FloatBtnIcon(),
              ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueGrey.shade900,
          currentIndex: _screenIndex,
          onTap: selectScreen,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.timeline,
                color: Colors.blueGrey.shade50,
              ),
              label: 'Monitoring',
              // title: Text(
              //   'Monitoring',
              //   style: TextStyle(
              //     color: Colors.blueGrey.shade50,
              //   ),
              // ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                color: Colors.blueGrey.shade50,
              ),
              label: 'Snapshots',
              // title: Text(
              //   'Snapshots',
              //   style: TextStyle(
              //     color: Colors.blueGrey.shade50,
              //   ),
              // ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: context.watch<DataSamplingService>().isCounting ? Colors.blueGrey.shade600 : Colors.blueGrey.shade50,
              ),
              label: 'Settings',
              // title: Text(
              //   'Settings',
              //   style: TextStyle(
              //     color: context.watch<DataSamplingService>().isCounting ? Colors.blueGrey.shade600 : Colors.blueGrey.shade50,
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

//Return icon by sampling status
//Prevent screens wrapper from rerender
class FloatBtnIcon extends StatelessWidget {
  const FloatBtnIcon({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('flbtn render');
    bool isCounting = context.select((DataSamplingService c) => c.isCounting);
    return isCounting
        ? const Icon(Icons.stop)
        : const Icon(
            Icons.play_arrow,
          );
  }
}
