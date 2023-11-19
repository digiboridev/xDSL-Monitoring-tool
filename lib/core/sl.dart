import 'package:xdslmt/data/drift/db.dart';
import 'package:xdslmt/data/drift/stats.dart';
import 'package:xdslmt/data/repositories/current_sampling_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/data/services/stats_sampling_service.dart';

abstract class SL {
  static final _drift = DB();

  static final SettingsRepository settingsRepository = SettingsRepositoryPrefsImpl();
  static final StatsRepository statsRepository = StatsRepositoryDriftImpl(dao: StatsDao(_drift));
  static final CurrentSamplingRepository currentSamplingRepository = CurrentSamplingRepositoryImpl();

  static final statsSamplingService = StatsSamplingService(
    statsRepository,
    settingsRepository,
    currentSamplingRepository,
  );
}
