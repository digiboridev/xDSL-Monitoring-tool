// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/core/sl.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/screens/screens_wrapper.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final logerName = record.loggerName.isEmpty ? 'ROOT' : record.loggerName;
    final level = record.level.name;
    final time = record.time;

    debugPrint('$time $level $logerName:\n${record.message}');
  });

  runApp(const App());
  // runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  /// Sets up orientation settings and listens to updates
  void bindOrientLock(SettingsRepository settingsRepo) async {
    void set(bool orientLock) {
      Logger.root.info('orientLock set: $orientLock');
      if (orientLock) {
        SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
        );
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

    settingsRepo.getSettings.then((settings) => set(settings.orientLock));
    settingsRepo.updatesStream.map((settings) => settings.orientLock).distinct().listen((orientLock) => set(orientLock));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsRepository>(create: (_) => SL.settingsRepository),
        Provider<StatsRepository>(create: (_) => SL.statsRepository),
        ChangeNotifierProvider<StatsSamplingService>.value(value: SL.statsSamplingService),
      ],
      builder: (context, child) {
        bindOrientLock(context.read<SettingsRepository>());
        return child!;
      },
      child: MaterialApp(
        title: 'xDSL Monitoring Tool',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)),
        home: const ScreensWrapper(),
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
      ),
    );
  }
}



// TODO sign
// TODO about
// TODO analytics
// TODO release
