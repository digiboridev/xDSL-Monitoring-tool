import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/core/sl.dart';
import 'package:xdslmt/data/repositories/current_sampling_repo.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/screens/screens_wrapper.dart';

Future<void> main() async {
  // Logger configuration
  AppLogger.stream.listen((LogEntity l) {
    // Setup local log
    log(l.msg, time: l.time, error: l.error, stackTrace: l.stack, name: l.name, level: l.level.index);

    // Setup remote log
    if (l.error != null) Sentry.captureException(l.error, stackTrace: l.stack);
    if (l.level == Level.info) Sentry.captureMessage(l.msg, template: l.name);
    final b = Breadcrumb(message: l.msg, level: SentryLevel.fromName(l.level.name), timestamp: l.time, category: l.name);
    Sentry.addBreadcrumb(b);
  });

  // runApp(const App());
  // runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => const App()));
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('sentryKey');
      options.tracesSampleRate = 1.0;
      options.enablePrintBreadcrumbs = false;
      options.enableAutoPerformanceTracing = true;
      options.beforeSendTransaction = (transaction) async {
        debugPrint('tr send: ${transaction.eventId} ${DateTime.now()}');
        return transaction;
      };
    },
    appRunner: () => runApp(const App()),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  /// Sets up orientation settings and listens to updates
  void bindOrientLock(SettingsRepository settingsRepo) async {
    void set(bool orientLock) {
      AppLogger.debug('OrientLock set: $orientLock');
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
        Provider<CurrentSamplingRepository>(create: (_) => SL.currentSamplingRepository),
        Provider<SettingsRepository>(create: (_) => SL.settingsRepository),
        Provider<StatsRepository>(create: (_) => SL.statsRepository),
        Provider<StatsSamplingService>.value(value: SL.statsSamplingService),
      ],
      builder: (context, child) {
        bindOrientLock(context.read<SettingsRepository>());
        return child!;
      },
      child: MaterialApp(
        title: 'xDSL Monitoring Tool',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan)),
        home: const ScreensWrapper(),
        navigatorObservers: [SentryNavigatorObserver(setRouteNameAsTransaction: true)],
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
      ),
    );
  }
}

// TODO sign
// TODO about
// TODO pp link
// TODO release
