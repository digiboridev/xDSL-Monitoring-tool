import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:xdslmt/data/drift/db.dart';
import 'package:xdslmt/data/drift/stats.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';
import 'package:xdslmt/screens_wrapper.dart';

void main() async {
  debugRepaintRainbowEnabled = false;
  runApp(const App());
}

final class SL {
  SL._();
  static final SL _instance = SL._();
  factory SL() => _instance;

  late final _drift = DB();

  late final SettingsRepository settingsRepository = SettingsRepositoryPrefsImpl();
  late final StatsRepository statsRepository = StatsRepositoryDriftImpl(dao: StatsDao(_drift));

  StatsSamplingService get statsSamplingService => StatsSamplingService(statsRepository, settingsRepository);
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettingsRepository>(create: (_) => SL().settingsRepository),
        Provider<StatsRepository>(create: (_) => SL().statsRepository),
        ChangeNotifierProvider<StatsSamplingService>(create: (_) => SL().statsSamplingService),
      ],
      child: MaterialApp(
        title: 'xDSL Monitoring Tool',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        ),
        home: const ScreensWrapper(),
      ),
    );
  }
}

// TODO settings text, ext host remove, wakelock and fore switch
// TODO painters colors from constructor
// TODO nu clients restore
// TODO sign
// TODO release
