// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field, avoid_print
import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/data/models/app_settings.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/recent_counters.dart';
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
  Isolate? _isolate;
  bool get samplingActive => _isolate != null;

  static Stream<CurrentSamplingEvent> _createLineStatsStream(AppSettings settings) async* {
    String snapshotId = DateTime.now().millisecondsSinceEpoch.toString();

    Duration samplingInterval = settings.samplingInterval;
    NetUnitClient client = NetUnitClient.fromSettings(settings, snapshotId);
    SnapshotStats snapshotStats = SnapshotStats.create(snapshotId, settings.host, settings.login, settings.pwd);

    Queue<LineStats> lineStatsQueue = Queue();
    Duration lastFetchDuration = const Duration(seconds: 5);

    try {
      while (true) {
        final fetchStart = DateTime.now();
        yield CurrentSamplingEvent.fetchPending(fetchStart, lastFetchDuration);
        LineStats lineStats = await client.fetchStats().catchError((_) => LineStats.errored(snapshotId: snapshotId, statusText: 'Sampling error'));
        final fetchEnd = DateTime.now();
        lastFetchDuration = fetchEnd.difference(fetchStart);
        yield CurrentSamplingEvent.lineStatsArived(lineStats);

        lineStatsQueue.addFirst(lineStats);
        if (lineStatsQueue.length > 500) lineStatsQueue.removeLast();

        snapshotStats = snapshotStats.copyWithLineStats(lineStats);
        yield CurrentSamplingEvent.snapshotStatsArived(snapshotStats);

        final recentCounters = RecentCounters.fromLineStats(lineStatsQueue);
        yield CurrentSamplingEvent.recentCountersArived(recentCounters);

        // TODO split

        yield CurrentSamplingEvent.temporizing(DateTime.now(), samplingInterval);
        await Future.delayed(samplingInterval);
      }
    } finally {
      client.dispose();
    }
  }

  runSampling() async {
    if (samplingActive) return;
    AppLogger.debug(name: 'StatsSamplingService', 'Run sampling');

    AppSettings settings = await _settingsRepository.getSettings;
    if (settings.wakeLock) _mc.invokeMethod('startWakeLock').ignore();
    if (settings.foregroundService) _mc.invokeMethod('startForegroundService').ignore();
    AppLogger.debug(name: 'StatsSamplingService', '$settings');

    _currentSamplingRepository.wipeStats();

    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      (data) async {
        final (sendPort, token, settings) = data;
        BackgroundIsolateBinaryMessenger.ensureInitialized(token);
        AppLogger.stream.listen((event) => sendPort.send(event));

        final stream = _createLineStatsStream(settings);
        await for (var event in stream) {
          sendPort.send(event);
        }
      },
      (receivePort.sendPort, RootIsolateToken.instance!, settings),
      onExit: receivePort.sendPort,
      onError: receivePort.sendPort,
    );

    receivePort.listen(
      (message) {
        if (message is LogEntity) {
          AppLogger.forward(message);
          return;
        }

        if (message is CurrentSamplingEvent) {
          _currentSamplingRepository.submitEvent(message);
          if (message is LineStatsArived) _statsRepository.insertLineStats(message.lineStats).ignore();
          if (message is SnapshotStatsArived) _statsRepository.upsertSnapshotStats(message.snapshotStats).ignore();
          return;
        }

        if (message is List<dynamic>) {
          final e = Exception(message[0]);
          final s = StackTrace.fromString(message[1]);
          AppLogger.error(name: 'Sampling isolate', message[0], error: e, stack: s);
          receivePort.close();
          return;
        }

        if (message == null) {
          receivePort.close();
          return;
        }

        AppLogger.debug(name: 'Sampling isolate', 'Unknown message: $message');
        AppLogger.debug(name: 'Sampling isolate', message.runtimeType.toString());
      },
      onDone: () => AppLogger.debug(name: 'Sampling isolate', 'done'),
    );
    _currentSamplingRepository.setStatus(true);
  }

  stopSampling({bool wipeQueue = true}) {
    if (!samplingActive) return;

    AppLogger.info(name: 'StatsSamplingService', 'Stop sampling');

    _mc.invokeMethod('stopForegroundService');
    _mc.invokeMethod('stopWakeLock');

    _isolate?.kill();
    _isolate = null;

    _currentSamplingRepository.setStatus(false);
  }
}
