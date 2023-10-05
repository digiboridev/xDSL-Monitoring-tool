// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:xdsl_mt/data/models/app_settings.dart';
import 'package:xdsl_mt/data/models/line_stats.dart';
import 'package:xdsl_mt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdsl_mt/data/repositories/line_stats_repo.dart';
import 'package:xdsl_mt/data/repositories/settings_repo.dart';

class StatsSamplingService extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final LineStatsRepository _lineStatsRepository;
  final _statsStreamController = StreamController<LineStats>.broadcast();

  StatsSamplingService(this._lineStatsRepository, this._settingsRepository) {
    debugPrint('SamplingService init');
  }

  bool _sampling = false;
  int _samplesCount = 0;
  final _lastSamples = Queue<LineStats>();

  bool get sampling => _sampling;
  int get samplesCount => _samplesCount;
  LineStats? get lastSample => _lastSamples.lastOrNull;
  Queue<LineStats> get lastSamples => _lastSamples;
  Stream<LineStats> get statsStream => _statsStreamController.stream;

  runSampling() async {
    if (sampling) return;

    AppSettings settings = await _settingsRepository.getSettings;
    Duration samplingInterval = settings.samplingInterval;
    String session = DateTime.now().toString();
    NetUnitClient client = NetUnitClient.fromSettings(settings, session);

    _sampling = true;
    notifyListeners();

    tick() async {
      LineStats stats = await client.fetchStats();

      // drop results if sampling was stopped
      if (!sampling) return;

      _handleStats(stats);
      Timer(samplingInterval, () => tick());
    }

    tick();
  }

  stopSampling() {
    if (!sampling) return;
    _sampling = false;
    _samplesCount = 0;
    _lastSamples.clear();
    notifyListeners();
  }

  _handleStats(LineStats stats) {
    _samplesCount++;
    _lastSamples.addLast(stats);
    if (_lastSamples.length > 10) _lastSamples.removeFirst();
    _statsStreamController.add(stats);
    _lineStatsRepository.insert(stats);
    notifyListeners();
  }

  @override
  void dispose() {
    _statsStreamController.close();
    _sampling = false;
    super.dispose();
  }
}
