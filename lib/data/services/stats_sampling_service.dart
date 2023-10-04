// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'package:flutter/foundation.dart';
import 'package:xdsl_mt/data/repositories/line_stats_repo.dart';
import 'package:xdsl_mt/data/repositories/settings_repo.dart';

class StatsSamplingService extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final LineStatsRepository _lineStatsRepository;

  StatsSamplingService(this._lineStatsRepository, this._settingsRepository);
}
