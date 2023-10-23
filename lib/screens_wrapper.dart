import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/screens/current/current_screen.dart';
import 'package:xdslmt/screens/settings/binding.dart';
import 'package:xdslmt/screens/settings/view.dart';
import 'package:xdslmt/screens/snapshots/binding.dart';
import 'package:xdslmt/screens/snapshots/view.dart';
import 'package:xdslmt/widgets/app_colors.dart';
import 'package:xdslmt/widgets/text_styles.dart';

class ScreensWrapper extends StatefulWidget {
  const ScreensWrapper({super.key});

  @override
  State<ScreensWrapper> createState() => _ScreensWrapperState();
}

class _ScreensWrapperState extends State<ScreensWrapper> {
  late final List screens = [
    const CurrentScreen(),
    const SnapshotsScreenBinding(child: SnapshotsScreenView()),
    const SettingsScreenBinding(child: SettingsScreenView()),
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
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
        );
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
        bool sampling = context.read<StatsSamplingService>().samplingActive;
        if (sampling) const MethodChannel('main').invokeMethod('minimize');
        return !sampling;
      },
      child: Scaffold(
        backgroundColor: AppColors.blueGrey900,
        appBar: appBar(),
        body: body(),
        floatingActionButton: screenIndex == 0 ? const FloatButton() : null,
        bottomNavigationBar: bottomBar(),
      ),
    );
  }

  Widget body() {
    return SafeArea(
      child: Container(
        color: AppColors.cyan100,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(animation),
            child: FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            ),
          ),
          child: screens[screenIndex],
        ),
      ),
    );
  }

  BottomNavigationBar bottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      showUnselectedLabels: true,
      unselectedFontSize: 12,
      selectedFontSize: 14,
      unselectedItemColor: AppColors.blueGrey200,
      selectedItemColor: AppColors.cyan50,
      currentIndex: screenIndex,
      onTap: selectScreen,
      items: const [
        BottomNavigationBarItem(
          label: 'Monitoring',
          icon: Icon(Icons.cloud_sync_outlined),
          activeIcon: Icon(Icons.cloud_sync_sharp),
          backgroundColor: AppColors.blueGrey900,
        ),
        BottomNavigationBarItem(
          label: 'Snapshots',
          icon: Icon(Icons.document_scanner_outlined),
          activeIcon: Icon(Icons.document_scanner_sharp),
          backgroundColor: AppColors.blueGrey800,
        ),
        BottomNavigationBarItem(
          label: 'Settings',
          icon: Icon(Icons.data_object_outlined),
          activeIcon: Icon(Icons.data_object_sharp),
          backgroundColor: AppColors.blueGrey800,
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: Tween(begin: 0.7, end: 1.0).animate(animation),
          child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          ),
        ),
        child: Row(key: Key(screenName), children: [Text(screenName, style: TextStyles.f18w6.cyan50)]),
      ),
      actions: [
        IconButton(
          tooltip: 'Minimize app',
          icon: const Icon(Icons.minimize, color: AppColors.cyan50),
          onPressed: () {
            const MethodChannel('main').invokeMethod('minimize');
          },
        ),
        IconButton(
          tooltip: 'Close app',
          icon: const Icon(Icons.power_settings_new, color: AppColors.cyan50),
          onPressed: () {
            exit(0);
          },
        ),
      ],
      backgroundColor: AppColors.blueGrey900,
    );
  }
}

class FloatButton extends StatefulWidget {
  const FloatButton({super.key});

  @override
  State<FloatButton> createState() => _FloatButtonState();
}

class _FloatButtonState extends State<FloatButton> {
  bool busy = false;

  void toogleSampling(BuildContext context) async {
    if (busy) return;

    final samplingService = context.read<StatsSamplingService>();

    if (samplingService.samplingActive) {
      samplingService.stopSampling();
      const MethodChannel('main').invokeMethod('stopForegroundService');
      const MethodChannel('main').invokeMethod('stopWakeLock');
    } else {
      samplingService.runSampling();
      const MethodChannel('main').invokeMethod('startForegroundService');
      const MethodChannel('main').invokeMethod('startWakeLock');
    }

    setState(() => busy = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => busy = false);
  }

  Icon get getIcon {
    bool sampling = context.select<StatsSamplingService, bool>((value) => value.samplingActive);

    if (sampling) {
      return const Icon(Icons.stop, color: AppColors.cyan50, key: Key('stop'));
    } else {
      return const Icon(Icons.play_arrow, color: AppColors.cyan50, key: Key('play'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: busy ? AppColors.cyan600 : AppColors.blueGrey900.withOpacity(0.75),
      onPressed: () => toogleSampling(context),
      hoverColor: Colors.amber[100],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
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
