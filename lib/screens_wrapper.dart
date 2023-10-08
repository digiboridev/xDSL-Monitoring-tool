import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/screens/current/current_screen.dart';
import 'package:xdslmt/screens/settings/binding.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:xdslmt/screens/settings/view.dart';
import 'package:xdslmt/screens/snapshots/binding.dart';
import 'package:xdslmt/screens/snapshots/view.dart';

class ScreensWrapper extends StatefulWidget {
  const ScreensWrapper({super.key});

  @override
  State<ScreensWrapper> createState() => _ScreensWrapperState();
}

class _ScreensWrapperState extends State<ScreensWrapper> {
  late final List screens = [
    CurrentScreen(),
    SnapshotsScreenBinding(child: SnapshotsScreenView()),
    SettingsScreenBinding(child: SettingsScreenView()),
  ];

  int _screenIndex = 0;

  void selectScreen(int index) => setState(() => _screenIndex = index);

  String get screenName {
    switch (_screenIndex) {
      case 0:
        return 'Monitoring';
      case 1:
        return 'Snapshots';
      case 2:
        return 'Settings';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO - fix orientation
    // if (context.watch<SettingsModel>().getOrient) {
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.portraitDown,
    //   ]);
    // } else {
    //   SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    //   );
    // }

    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        log('Minimized');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(screenName, style: TextStyle(color: Colors.cyan.shade100)),
          actions: [
            IconButton(
              tooltip: 'Minimize app',
              icon: Icon(Icons.minimize, color: Colors.cyan.shade100),
              onPressed: () {
                MoveToBackground.moveTaskToBack();
                debugPrint('minimized');
              },
            ),
            IconButton(
              tooltip: 'Close app',
              icon: Icon(Icons.power_settings_new, color: Colors.cyan.shade100),
              onPressed: () {
                // TODO
                // FlutterForegroundPlugin.stopForegroundService();
                exit(0);
              },
            ),
          ],
          backgroundColor: Colors.blueGrey.shade900,
        ),
        // body: screens[_screenIndex],
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: screens[_screenIndex],
        ),
        floatingActionButton: _screenIndex == 2 ? null : FloatButton(),
        bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Colors.blueGrey.shade900,
          currentIndex: _screenIndex,
          onTap: selectScreen,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.timeline,
                // color: Colors.blueGrey.shade50,
              ),
              label: 'Monitoring',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                // color: Colors.blueGrey.shade50,
              ),
              label: 'Snapshots',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                // color: Colors.blueGrey.shade50,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class FloatButton extends StatefulWidget {
  const FloatButton({super.key});

  @override
  State<FloatButton> createState() => _FloatButtonState();
}

class _FloatButtonState extends State<FloatButton> {
  // late StatsSamplingService samplingService = SL().statsSamplingService;

  void toogleSampling(BuildContext context) async {
    final samplingService = context.read<StatsSamplingService>();

    if (samplingService.sampling) {
      samplingService.stopSampling();
    } else {
      samplingService.runSampling();
    }
  }

  Icon get getIcon {
    bool sampling = context.select<StatsSamplingService, bool>((value) => value.sampling);

    if (sampling) {
      return Icon(Icons.stop, color: Colors.white, key: Key('stop'));
    } else {
      return Icon(Icons.play_arrow, color: Colors.white, key: Key('play'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blueGrey.shade900.withOpacity(0.75),
      onPressed: () => toogleSampling(context),
      hoverColor: Colors.amber[100],
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 1000),
        switchInCurve: Curves.elasticOut,
        switchOutCurve: Curves.ease,
        child: getIcon,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: Tween(begin: -1.0, end: 1.0).animate(animation),
          child: FadeTransition(
            opacity: Tween(begin: -4.0, end: 1.0).animate(animation),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 2.0).animate(animation),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
