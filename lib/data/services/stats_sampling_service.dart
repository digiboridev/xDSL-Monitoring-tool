// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field, avoid_print
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/data/models/app_settings.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/repositories/current_sampling_repo.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';

class StatsSamplingService {
  final SettingsRepository _settingsRepository;
  final StatsRepository _statsRepository;
  final CurrentSamplingRepository _currentSamplingRepository;
  StatsSamplingService(this._statsRepository, this._settingsRepository, this._currentSamplingRepository);

  final _mc = const MethodChannel('main');
  StreamSubscription? _samplingSub;
  bool get samplingActive => _samplingSub != null;

  Stream<(LineStats lineStats, SnapshotStats snapshotStats, Duration fetchDuration)> createLineStatsStream() async* {
    AppSettings settings = await _settingsRepository.getSettings;
    Duration samplingInterval = settings.samplingInterval;
    String snapshotId = DateTime.now().millisecondsSinceEpoch.toString();

    NetUnitClient client = NetUnitClient.fromSettings(settings, snapshotId);
    SnapshotStats snapshotStats = SnapshotStats.create(snapshotId, settings.host, settings.login, settings.pwd);

    if (settings.wakeLock) _mc.invokeMethod('startWakeLock').ignore();
    if (settings.foregroundService) _mc.invokeMethod('startForegroundService').ignore();

    AppLogger.info(name: 'StatsSamplingService', 'Run sampling: $snapshotId');
    AppLogger.debug(name: 'StatsSamplingService', '$settings');

    try {
      while (true) {
        AppLogger.debug(name: 'StatsSamplingService', 'stream tick before');

        final fetchStart = DateTime.now();
        _currentSamplingRepository.signalFetchAttempt();

        LineStats lineStats = await client.fetchStats().catchError((_) => LineStats.errored(snapshotId: snapshotId, statusText: 'Sampling error'));
        snapshotStats = snapshotStats.copyWithLineStats(lineStats);

        final fetchEnd = DateTime.now();
        final fetchDuration = fetchEnd.difference(fetchStart);

        yield (lineStats, snapshotStats, fetchDuration);

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

  runSampling() async {
    if (samplingActive) return;

    AppLogger.debug(name: 'StatsSamplingService', 'Run sampling');

    _currentSamplingRepository.wipeStats();
    _samplingSub = createLineStatsStream().listen(
      (event) => _currentSamplingRepository.updateStats(event.$1, event.$2, event.$3),
      onDone: () => stopSampling(), // Actually, this should never happen
    );
    _currentSamplingRepository.updateStatus(true);
  }

  stopSampling({bool wipeQueue = true}) {
    if (!samplingActive) return;

    AppLogger.info(name: 'StatsSamplingService', 'Stop sampling');

    _mc.invokeMethod('stopForegroundService');
    _mc.invokeMethod('stopWakeLock');

    _samplingSub?.cancel();
    _samplingSub = null;

    _currentSamplingRepository.updateStatus(false);
  }
}
