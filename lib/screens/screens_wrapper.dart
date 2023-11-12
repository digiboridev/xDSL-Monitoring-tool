import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/screens/monitoring/current_screen.dart';
import 'package:xdslmt/screens/settings/binding.dart';
import 'package:xdslmt/screens/settings/view.dart';
import 'package:xdslmt/screens/snapshots/binding.dart';
import 'package:xdslmt/screens/snapshots/view.dart';
import 'package:xdslmt/core/colors.dart';
import 'package:xdslmt/core/text_styles.dart';

class ScreensWrapper extends StatefulWidget {
  const ScreensWrapper({super.key});

  @override
  State<ScreensWrapper> createState() => _ScreensWrapperState();
}

class _ScreensWrapperState extends State<ScreensWrapper> {
  final Map screens = {
    'Monitoring': const MonitoringScreen(),
    'Snapshots': const SnapshotsScreenBinding(child: SnapshotsScreenView()),
    'Settings': const SettingsScreenBinding(child: SettingsScreenView()),
  };
  late String currentScreen = screens.keys.first;

  void close() => exit(0);
  void minimize() => const MethodChannel('main').invokeMethod('minimize');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      /// Prevents back button from closing the app when sampling is active
      /// and minimizes the app instead
      onWillPop: () async {
        bool sampling = context.read<StatsSamplingService>().samplingActive;
        if (sampling) minimize();
        return !sampling;
      },
      child: Scaffold(
        backgroundColor: AppColors.blueGrey900,
        appBar: appBar(),
        body: body(),
        floatingActionButton: currentScreen == screens.keys.first ? const FloatButton() : null,
        bottomNavigationBar: bottomBar(),
      ),
    );
  }

  Widget body() {
    return SafeArea(
      child: Container(
        color: AppColors.cyan100,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: Tween(begin: 0.975, end: 1.0).animate(animation),
            child: FadeTransition(
              opacity: Tween(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          ),
          child: screens[currentScreen],
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
      currentIndex: screens.keys.toList().indexOf(currentScreen),
      onTap: (index) => setState(() => currentScreen = screens.keys.toList()[index]),
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
        duration: const Duration(milliseconds: 100),
        switchInCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(animation),
          child: FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
            child: child,
          ),
        ),
        child: Row(key: Key(currentScreen), children: [Text(currentScreen, style: TextStyles.f18w6.cyan50)]),
      ),
      actions: [
        IconButton(
          tooltip: 'Minimize app',
          icon: const Icon(Icons.minimize, color: AppColors.cyan50),
          onPressed: minimize,
        ),
        IconButton(
          tooltip: 'Close app',
          icon: const Icon(Icons.power_settings_new, color: AppColors.cyan50),
          onPressed: close,
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
    final settingsRepo = context.read<SettingsRepository>();
    final settings = await settingsRepo.getSettings;

    if (samplingService.samplingActive) {
      samplingService.stopSampling();
      const MethodChannel('main').invokeMethod('stopForegroundService');
      const MethodChannel('main').invokeMethod('stopWakeLock');
    } else {
      samplingService.runSampling();
      if (settings.wakeLock) const MethodChannel('main').invokeMethod('startWakeLock');
      if (settings.foregroundService) const MethodChannel('main').invokeMethod('startForegroundService');
    }

    setState(() => busy = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => busy = false);
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
