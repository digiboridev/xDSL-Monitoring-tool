import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/screens/current/current_screen.dart';
import 'package:xdslmt/screens/settings/binding.dart';
import 'package:xdslmt/screens/settings/view.dart';
import 'package:xdslmt/screens/snapshots/binding.dart';
import 'package:xdslmt/screens/snapshots/view.dart';
import 'package:xdslmt/widgets/text_styles.dart';

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

  int screenIndex = 0;
  selectScreen(int index) => setState(() => screenIndex = index);

  String get screenName {
    switch (screenIndex) {
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

  setupOrient() async {
    set(bool orientLock) {
      if (orientLock) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      }
    }

    final srepo = context.read<SettingsRepository>();
    final settings = await srepo.getSettings;
    set(settings.orientLock);
    srepo.updatesStream.map((settings) => settings.orientLock).distinct().listen((orientLock) => set(orientLock));
  }

  @override
  void initState() {
    super.initState();
    setupOrient();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool sampling = context.read<StatsSamplingService>().sampling;
        if (sampling) MethodChannel('main').invokeMethod('minimize');
        return !sampling;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(screenName, style: TextStyles.f18w6.cyan100),
          actions: [
            IconButton(
              tooltip: 'Minimize app',
              icon: Icon(Icons.minimize, color: Colors.cyan.shade100),
              onPressed: () {
                MethodChannel('main').invokeMethod('minimize');
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
        body: AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: screens[screenIndex]),
        floatingActionButton: screenIndex == 2 ? null : FloatButton(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: screenIndex,
          onTap: selectScreen,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Monitoring'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Snapshots'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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
