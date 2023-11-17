// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field, avoid_print
import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/data/models/app_settings.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/repositories/current_sampling_repo.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';

class StatsSamplingService extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final StatsRepository _statsRepository;
  final CurrentSamplingRepository _currentSamplingRepository;
  StatsSamplingService(this._statsRepository, this._settingsRepository, this._currentSamplingRepository);

  @Deprecated('move to shared repo')
  SnapshotStats? _snapshotStats;
  @Deprecated('move to shared repo')
  SnapshotStats? get snapshotStats => _snapshotStats;

  @Deprecated('move to shared repo')
  final _samplesQueue = Queue<LineStats>();
  @Deprecated('move to shared repo')
  Iterable<LineStats> get lastSamples => _samplesQueue;

  StreamSubscription? samplingSub;
  @Deprecated('move to shared repo')
  bool get samplingActive => samplingSub != null;

  Stream<(LineStats lineStats, SnapshotStats snapshotStats)> createLineStatsStream() async* {
    AppSettings settings = await _settingsRepository.getSettings;
    Duration samplingInterval = settings.samplingInterval;
    String snapshotId = DateTime.now().millisecondsSinceEpoch.toString();

    NetUnitClient client = NetUnitClient.fromSettings(settings, snapshotId);
    SnapshotStats snapshotStats = SnapshotStats.create(snapshotId, settings.host, settings.login, settings.pwd);

    AppLogger.info(name: 'StatsSamplingService', 'Run sampling: $snapshotId');
    AppLogger.debug(name: 'StatsSamplingService', '$settings');

    try {
      while (true) {
        AppLogger.debug(name: 'StatsSamplingService', 'stream tick before');

        LineStats lineStats = await client.fetchStats().catchError((_) => LineStats.errored(snapshotId: snapshotId, statusText: 'Sampling error'));
        snapshotStats = snapshotStats.copyWithLineStats(lineStats);

        yield (lineStats, snapshotStats);

        AppLogger.debug(name: 'StatsSamplingService', 'stream tick after');
        AppLogger.debug(name: 'StatsSamplingService', '$lineStats');
        AppLogger.debug(name: 'StatsSamplingService', '$snapshotStats');

        _statsRepository.insertLineStats(lineStats).ignore();
        _statsRepository.upsertSnapshotStats(snapshotStats).ignore();

        // TODO split

        await Future.delayed(samplingInterval);
      }
    } catch (e, s) {
      AppLogger.error(name: 'StatsSamplingService', 'stream catch', error: e, stack: s);
    } finally {
      AppLogger.debug(name: 'StatsSamplingService', 'stream finally');
      client.dispose();
    }
  }

  // Start Network Unit stats sampling using the current settings
  runSampling() async {
    if (samplingSub != null) return;

    AppLogger.debug(name: 'StatsSamplingService', 'Run sampling');

    _snapshotStats = null;
    _samplesQueue.clear();

    samplingSub = createLineStatsStream().listen(
      (event) {
        final (lineStats, snapshotStats) = event;
        _addLineStatsToQueue(lineStats);
        _snapshotStats = snapshotStats;
        notifyListeners();
        _currentSamplingRepository.updateStats(lineStats, snapshotStats);
      },
      onDone: () => stopSampling(), // Actually, this should never happen
    );

    notifyListeners();
    _currentSamplingRepository.updateStatus(true);
  }

  stopSampling({bool wipeQueue = true}) {
    AppLogger.info(name: 'StatsSamplingService', 'Stop sampling');

    samplingSub?.cancel();
    samplingSub = null;

    notifyListeners();
    _currentSamplingRepository.updateStatus(false);
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
