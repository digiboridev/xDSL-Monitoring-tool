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

    final client = NetUnitClient.fromSettings(settings, snapshotId);
    final snapshotStats = SnapshotStats.create(snapshotId, settings.host, settings.login, settings.pwd);
    _client = client;
    _snapshotStats = snapshotStats;
    notifyListeners();

    tick(String session) async {
      // If sampling was stopped or restarted during the timer delay
      if (_snapshotStats?.snapshotId != session) return;

      LineStats lineStats = await client.fetchStats();

      // If sampling was stopped or restarted while new stats were being fetched
      if (_snapshotStats?.snapshotId != session) return;

      // Handle new line stats
      _handleLineStats(lineStats);

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

  /// Handle a new line stats sample
  _handleLineStats(LineStats lineStats) {
    _snapshotStats = _snapshotStats?.copyWithLineStats(lineStats);
    _addToQueue(lineStats);
    notifyListeners();

    _statsRepository.insertLineStats(lineStats);
    _statsRepository.upsertSnapshotStats(_snapshotStats!);

    debugPrint('Handled stats at: ${DateTime.now()}, count: ${_snapshotStats?.samples ?? 0}');
  }

  _addToQueue(LineStats value) {
    _samplesQueue.addLast(value);
    if (_samplesQueue.length > 500) _samplesQueue.removeFirst();
  }

  @override
  void dispose() {
    stopSampling();
    super.dispose();
  }
}
