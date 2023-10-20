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

  SnapshotStats? _snapshotStats;
  SnapshotStats? get snapshotStats => _snapshotStats;
  bool get samplingActive => _snapshotStats != null;

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
    final statsBlank = SnapshotStats.create(snapshotId, settings.host, settings.login, settings.pwd);
    _snapshotStats = statsBlank;
    notifyListeners();

    // Enqueue the sampling
    tick() async {
      LineStats lineStats = await client.fetchStats();

      // If sampling was stopped or changed while waiting for the response
      // drop responce and break the loop
      if (lineStats.snapshotId != _snapshotStats?.snapshotId) return;

      _handleLineStats(lineStats);

      // Restart sampling if the split interval has passed, without wiping the queue
      if (_snapshotStats!.samplingDuration > splitInterval) {
        _snapshotStats = null;
        runSampling();
        return;
      }

      Timer(samplingInterval, () => tick());
    }

    tick();
  }

  /// Stop Network Unit stats sampling
  stopSampling() {
    _samplesQueue.clear();
    _snapshotStats = null;
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
