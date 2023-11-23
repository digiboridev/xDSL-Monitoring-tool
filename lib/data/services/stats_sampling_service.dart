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
import 'package:xdslmt/data/models/raw_line_stats.dart';
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

  /// Is sampling currently active
  bool get samplingActive => _isolate != null;

  /// Create stream that containing continuous procedure of
  /// retrieving actual line stats, parsing it and upsert to child data structures
  ///
  /// [LineStats] -> [SnapshotStats] -> [RecentCounters]
  ///
  /// Can be gracefully stopped by closing stream subscription.
  /// Can be used inside isolate.
  static Stream<CurrentSamplingEvent> _createSamplingStream(AppSettings settings) async* {
    String snapshotId = DateTime.now().millisecondsSinceEpoch.toString();

    Duration samplingInterval = settings.samplingInterval;
    Duration splitInterval = settings.splitInterval;
    int recentSize = settings.recentSize;
    NetUnitClient client = NetUnitClient.fromSettings(settings);
    SnapshotStats snapshotStats = SnapshotStats.create(snapshotId, settings.host, settings.login, settings.pwd);

    Queue<LineStats> lineStatsQueue = Queue();
    Duration lastFetchDuration = const Duration(seconds: 1);

    try {
      while (true) {
        final fetchStart = DateTime.now();
        yield CurrentSamplingEvent.fetchPending(fetchStart, lastFetchDuration);
        AppLogger.debug(name: 'Sampling stream', 'Fetch pending');

        RawLineStats rawLineStats = await client.fetchStats();
        LineStats lineStats = LineStats.fromRaw(snapshotId: snapshotId, rawLineStats: rawLineStats, prevStats: lineStatsQueue.firstOrNull);
        yield CurrentSamplingEvent.lineStatsArived(lineStats);
        AppLogger.debug(name: 'Sampling stream', 'Line stats arived');
        AppLogger.debug(name: 'Sampling stream', lineStats.toString());

        final fetchEnd = DateTime.now();
        lastFetchDuration = fetchEnd.difference(fetchStart);
        lineStatsQueue.addFirst(lineStats);
        if (lineStatsQueue.length > recentSize) lineStatsQueue.removeLast();

        snapshotStats = snapshotStats.copyWithLineStats(lineStats);
        yield CurrentSamplingEvent.snapshotStatsArived(snapshotStats);
        AppLogger.debug(name: 'Sampling stream', 'Snapshot stats arived');
        AppLogger.debug(name: 'Sampling stream', snapshotStats.toString());

        final recentCounters = RecentCounters.fromLineStats(lineStatsQueue, maxCount: recentSize);
        yield CurrentSamplingEvent.recentCountersArived(recentCounters);
        AppLogger.debug(name: 'Sampling stream', 'Recent counters arived');
        AppLogger.debug(name: 'Sampling stream', recentCounters.toStringMin());

        // Renew snapshot if split interval is reached
        if (snapshotStats.samplingDuration > splitInterval) {
          snapshotId = DateTime.now().millisecondsSinceEpoch.toString();
          snapshotStats = SnapshotStats.create(snapshotId, settings.host, settings.login, settings.pwd);
          lineStatsQueue.clear();
        }

        yield CurrentSamplingEvent.temporizing(DateTime.now(), samplingInterval);
        AppLogger.debug(name: 'Sampling stream', 'Temporizing');

        await Future.delayed(samplingInterval);
      }
    } finally {
      client.dispose();
    }
  }

  void _isolateMessageHandler(message) {
    if (message is CurrentSamplingEvent) {
      _currentSamplingRepository.submitEvent(message);
      if (message is LineStatsArived) _statsRepository.insertLineStats(message.lineStats).ignore();
      if (message is SnapshotStatsArived) _statsRepository.upsertSnapshotStats(message.snapshotStats).ignore();
      AppLogger.debug(name: 'Sampling isolate', 'SamplingEvent: ${message.runtimeType}');
      return;
    }

    if (message is LogEntity) {
      AppLogger.forward(message);
      return;
    }

    if (message is List<dynamic>) {
      final e = Exception(message[0]);
      final s = StackTrace.fromString(message[1]);
      AppLogger.error(name: 'Sampling isolate', message[0], error: e, stack: s);
      return;
    }

    if (message == null) {
      AppLogger.debug(name: 'Sampling isolate', 'Done signal');
      return;
    }

    AppLogger.debug(name: 'Sampling isolate', 'Unknown message: $message');
    AppLogger.debug(name: 'Sampling isolate', message.runtimeType.toString());
  }

  runSampling() async {
    if (samplingActive) return;
    AppLogger.debug(name: 'StatsSamplingService', 'Run sampling');

    AppSettings settings = await _settingsRepository.getSettings;
    AppLogger.debug(name: 'StatsSamplingService', '$settings');

    // Start native bindings
    if (settings.wakeLock) _mc.invokeMethod('startWakeLock').ignore();
    if (settings.foregroundService) _mc.invokeMethod('startForegroundService').ignore();

    // Wipe stats from previous sampling
    _currentSamplingRepository.wipeStats();

    // Create isolate receive port and listen for messages
    final receivePort = ReceivePort()..listen(_isolateMessageHandler);

    // Spawn isolate and pass sendPort, binary token and settings to it
    // BackgroundIsolateBinaryMessenger needed for using db in isolate
    _isolate = await Isolate.spawn(
      (data) async {
        final (sendPort, token, settings) = data;
        BackgroundIsolateBinaryMessenger.ensureInitialized(token);
        AppLogger.stream.listen((event) => sendPort.send(event));

        final stream = _createSamplingStream(settings);
        await for (var event in stream) {
          sendPort.send(event);
        }
      },
      (receivePort.sendPort, RootIsolateToken.instance!, settings),
      onExit: receivePort.sendPort, // Forward isolate exit event to same receivePort
      onError: receivePort.sendPort, // Forward isolate error event to same receivePort
    );

    // Report to shared repo that sampling is active
    _currentSamplingRepository.setStatus(true);
  }

  stopSampling() {
    if (!samplingActive) return;
    AppLogger.info(name: 'StatsSamplingService', 'Stop sampling');

    // Stop navive bindings
    _mc.invokeMethod('stopForegroundService');
    _mc.invokeMethod('stopWakeLock');

    // Close isolate
    _isolate?.kill();
    _isolate = null;

    // Report to shared repo that sampling is inactive
    _currentSamplingRepository.setStatus(false);
  }
}
