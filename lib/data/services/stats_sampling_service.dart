// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'dart:async';
import 'dart:collection';
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
  StatsSamplingService(this._statsRepository, this._settingsRepository);

  NetUnitClient? _client;
  SnapshotStats? _snapshotStats;
  SnapshotStats? get snapshotStats => _snapshotStats;
  bool get samplingActive => _client != null && _snapshotStats != null;

  final _samplesQueue = Queue<LineStats>();
  List<LineStats> get lastSamples => List.unmodifiable(_samplesQueue);

  /// Start Network Unit stats sampling using the current settings
  runSampling() async {
    if (samplingActive) return;

    AppSettings settings = await _settingsRepository.getSettings;
    Duration samplingInterval = settings.samplingInterval;
    Duration splitInterval = settings.splitInterval;
    String snapshotId = DateTime.now().millisecondsSinceEpoch.toString();

    var client = NetUnitClient.fromSettings(settings, snapshotId);
    var snapshotStats = SnapshotStats.create(snapshotId, settings.host, settings.login, settings.pwd);
    _client = client;
    _snapshotStats = snapshotStats;
    notifyListeners();

    tick(String session) async {
      // If sampling was stopped or restarted during the previous tick
      if (_snapshotStats?.snapshotId != session) return;

      LineStats lineStats = await client.fetchStats();
      snapshotStats = snapshotStats.copyWithLineStats(lineStats);
      _statsRepository.insertLineStats(lineStats);
      _statsRepository.upsertSnapshotStats(snapshotStats);

      // If sampling was stopped or restarted while new stats were being fetched
      if (_snapshotStats?.snapshotId != session) return;

      // Handle new values
      _snapshotStats = snapshotStats;
      _addLineStatsToQueue(lineStats);
      notifyListeners();

      // Restart sampling if the split interval has been reached
      if (_snapshotStats!.samplingDuration > splitInterval) {
        stopSampling(wipeQueue: false);
        runSampling();
        return;
      }

      // Schedule next iteration
      Timer(samplingInterval, () => tick(session));
    }

    // Enqueue the sampling
    tick(snapshotId);
  }

  /// Stop Network Unit stats sampling
  stopSampling({bool wipeQueue = true}) {
    if (wipeQueue) _samplesQueue.clear();
    _snapshotStats = null;
    _client?.dispose();
    _client = null;
    notifyListeners();
  }

  _addLineStatsToQueue(LineStats lineStats) {
    _samplesQueue.addLast(lineStats);
    if (_samplesQueue.length > 500) _samplesQueue.removeFirst();
  }

  @override
  void dispose() {
    stopSampling();
    super.dispose();
  }
}
