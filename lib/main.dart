// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:xdslmt/core/sl.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart' hide log;
import 'package:xdslmt/screens/screens_wrapper.dart';

Future<void> main() async {
  // Logger configuration
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final logerName = record.loggerName.isEmpty ? 'ROOT' : record.loggerName;
    final level = record.level.name;
    final time = record.time;

    // Setup local log
    debugPrint('$time $level $logerName:');
    debugPrint(record.message);
    if (record.error != null) debugPrint('${record.error}');
    if (record.stackTrace != null) debugPrint('${record.stackTrace}');

    // Setup remote log
    if (record.error != null) Sentry.captureException(record.error, stackTrace: record.stackTrace);
    // Sentry will captures rest of logs as breadscrumps automatically, because of enablePrintBreadcrumbs
  });

  // Entry point
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('sentryKey');
      options.tracesSampleRate = 1.0;
      options.enablePrintBreadcrumbs = true;
      options.enableAutoPerformanceTracing = true;
    },
    appRunner: () => runApp(const App()),
  );

  // runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => const App()));
  // runApp(const App());
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
        navigatorObservers: [SentryNavigatorObserver()],
      ),
    );
  }
}

// TODO sign
// TODO about
// TODO analytics
// TODO release
