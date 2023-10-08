// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:xdslmt/data/models/app_settings.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';

class StatsSamplingService extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final StatsRepository _statsRepository;

  final _statsStreamController = StreamController<LineStats>.broadcast();

  StatsSamplingService(this._statsRepository, this._settingsRepository) {
    debugPrint('SamplingService init');
  }

  SnapshotStats? _snapshotStats;
  final _lastSamples = Queue<LineStats>();

  bool get sampling => _snapshotStats != null;
  Queue<LineStats> get lastSamples => _lastSamples;
  Stream<LineStats> get statsStream => _statsStreamController.stream;

  SnapshotStats? get snapshotStats => _snapshotStats;

  runSampling() async {
    if (sampling) return;

    AppSettings settings = await _settingsRepository.getSettings;
    Duration samplingInterval = settings.samplingInterval;
    String snapshotId = DateTime.now().toString();
    NetUnitClient client = NetUnitClient.fromSettings(settings, snapshotId);

    _snapshotStats = SnapshotStats.create(snapshotId, settings.host, settings.login, settings.pwd);
    notifyListeners();

    tick() async {
      LineStats lineStats = await client.fetchStats();

      // drop results if sampling was stopped
      if (!sampling) return;

      _handleLineStats(lineStats);
      Timer(samplingInterval, () => tick());
    }

    tick();
  }

  stopSampling() {
    if (!sampling) return;
    _lastSamples.clear();
    _snapshotStats = null;
    notifyListeners();
  }

  _handleLineStats(LineStats lineStats) {
    _snapshotStats = _snapshotStats?.copyWithLineStats(lineStats);
    _lastSamples.addLast(lineStats);
    if (_lastSamples.length > 10) _lastSamples.removeFirst();
    _statsStreamController.add(lineStats);
    _statsRepository.insert(lineStats);
    notifyListeners();

    log('Handled lineStats: $lineStats', name: 'StatsSamplingService', time: DateTime.now(), level: 1);
  }

  @override
  void dispose() {
    _statsStreamController.close();
    _snapshotStats = null;
    super.dispose();
  }
}
