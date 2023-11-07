import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/core/sl.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/screens/screens_wrapper.dart';

// void main() => runApp(const App());
void main() => runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => const App()));

class App extends StatelessWidget {
  const App({super.key});

  /// Sets up orientation settings and listens to updates
  void bindOrientLock(SettingsRepository settingsRepo) async {
    void set(bool orientLock) {
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
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}



// TODO nu clients restore
// TODO vDSL rates extend, dynamic range by protocol
// TODO sign
// TODO about
// TODO analytics
// TODO release
