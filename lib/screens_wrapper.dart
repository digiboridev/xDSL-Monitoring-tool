import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xdsl_mt/data/repositories/line_stats_repo.dart';
import 'package:xdsl_mt/data/repositories/settings_repo.dart';
import 'package:xdsl_mt/data/services/stats_sampling_service.dart';
import 'package:xdsl_mt/main.dart';
import 'package:xdsl_mt/models/data_sampling_service.dart';
import 'package:xdsl_mt/models/settings_model.dart';
import 'package:xdsl_mt/models/adsl_data_model.dart';
import 'package:xdsl_mt/screens/current/current_screen.dart';
import 'package:xdsl_mt/screens/saved_data_screen.dart';
import 'package:xdsl_mt/screens/settings/binding.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:xdsl_mt/screens/settings/view.dart';

class ScreensWrapper extends StatelessWidget {
  const ScreensWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsRepository>(create: (_) => SettingsRepositoryPrefsImpl()),
        Provider<LineStatsRepository>(create: (_) => SL().lineStatsRepository),
        ChangeNotifierProvider<StatsSamplingService>(create: (_) => SL().statsSamplingService),
        ChangeNotifierProvider(create: (_) => ADSLDataModel()),
        ChangeNotifierProvider(create: (_) => DataSamplingService()),
        ChangeNotifierProvider(create: (_) => SettingsModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DslStats',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.yellow,
            backgroundColor: Colors.cyan.shade50,
          ),
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        ),
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
  late final List screens = [
    CurrentScreen(),
    SavedDataScreen(),
    SettingsScreenBinding(child: SettingsScreenView()),
  ];

  int _screenIndex = 0;

  void selectScreen(int index) {
    bool isCounting = context.read<DataSamplingService>().isCounting;
    if (isCounting & (index == 2)) {
      debugPrint('blocket');
      return;
    }
    setState(() => _screenIndex = index);
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
        // body: screens[_screenIndex],
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: screens[_screenIndex],
        ),
        floatingActionButton: _screenIndex == 2 ? null : FloatButton(),
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
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                color: Colors.blueGrey.shade50,
              ),
              label: 'Snapshots',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: context.watch<DataSamplingService>().isCounting ? Colors.blueGrey.shade600 : Colors.blueGrey.shade50,
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
