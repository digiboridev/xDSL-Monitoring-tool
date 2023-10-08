// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_field
import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:xdslmt/data/models/app_settings.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/repositories/line_stats_repo.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';

class SessionStats {
  final String sessionId;
  final String host;
  final String login;
  final String password;
  final DateTime startTime;
  final int samplesCount;
  final DateTime? lastSampleTime;
  final int? downRateLast;
  final int? downRateMin;
  final int? downRateMax;
  final int? downRateAvg;
  final int? downAttainableRateLast;
  final int? downAttainableRateMin;
  final int? downAttainableRateMax;
  final int? downAttainableRateAvg;
  final int? upRateLast;
  final int? upRateMin;
  final int? upRateMax;
  final int? upRateAvg;
  final int? upAttainableRateLast;
  final int? upAttainableRateMin;
  final int? upAttainableRateMax;
  final int? upAttainableRateAvg;
  final double? downSNRmLast;
  final double? downSNRmMin;
  final double? downSNRmMax;
  final double? downSNRmAvg;
  final double? upSNRmLast;
  final double? upSNRmMin;
  final double? upSNRmMax;
  final double? upSNRmAvg;
  final double? downAttenuationLast;
  final double? downAttenuationMin;
  final double? downAttenuationMax;
  final double? downAttenuationAvg;
  final double? upAttenuationLast;
  final double? upAttenuationMin;
  final double? upAttenuationMax;
  final double? upAttenuationAvg;
  final int? downFecLast;
  final int? downFecTotal;
  final int? upFecLast;
  final int? upFecTotal;
  final int? downCrcLast;
  final int? downCrcTotal;
  final int? upCrcLast;
  final int? upCrcTotal;

  SessionStats._({
    required this.sessionId,
    required this.host,
    required this.login,
    required this.password,
    required this.startTime,
    required this.samplesCount,
    this.lastSampleTime,
    this.downRateLast,
    this.downRateMin,
    this.downRateMax,
    this.downRateAvg,
    this.downAttainableRateLast,
    this.downAttainableRateMin,
    this.downAttainableRateMax,
    this.downAttainableRateAvg,
    this.upRateLast,
    this.upRateMin,
    this.upRateMax,
    this.upRateAvg,
    this.upAttainableRateLast,
    this.upAttainableRateMin,
    this.upAttainableRateMax,
    this.upAttainableRateAvg,
    this.downSNRmLast,
    this.downSNRmMin,
    this.downSNRmMax,
    this.downSNRmAvg,
    this.upSNRmLast,
    this.upSNRmMin,
    this.upSNRmMax,
    this.upSNRmAvg,
    this.downAttenuationLast,
    this.downAttenuationMin,
    this.downAttenuationMax,
    this.downAttenuationAvg,
    this.upAttenuationLast,
    this.upAttenuationMin,
    this.upAttenuationMax,
    this.upAttenuationAvg,
    this.downFecLast,
    this.downFecTotal,
    this.upFecLast,
    this.upFecTotal,
    this.downCrcLast,
    this.downCrcTotal,
    this.upCrcLast,
    this.upCrcTotal,
  });

  factory SessionStats.create(String sessionId, String host, String login, String password) {
    return SessionStats._(sessionId: sessionId, host: host, login: login, password: password, startTime: DateTime.now(), samplesCount: 0);
  }

  num? _minVal(num? prev, num? next) {
    if (prev == null) return next;
    if (next == null) return prev;
    return prev < next ? prev : next;
  }

  num? _maxVal(num? prev, num? next) {
    if (prev == null) return next;
    if (next == null) return prev;
    return prev > next ? prev : next;
  }

  num? _avgVal(num? prev, num? next) {
    if (prev == null) return next;
    if (next == null) return prev;
    return (prev + next) / 2;
  }

  num _incrDiff(num? prev, num? next) {
    prev ??= 0;
    if (next == null) return prev;
    final diff = next - prev;
    return diff > 0 ? diff : prev;
  }

  SessionStats copyWithStats(LineStats stats) {
    return SessionStats._(
      sessionId: sessionId,
      host: host,
      login: login,
      password: password,
      startTime: startTime,
      lastSampleTime: stats.time,
      samplesCount: samplesCount + 1,
      downRateLast: stats.downRate,
      downRateMin: _minVal(downRateMin, stats.downRate)?.toInt(),
      downRateMax: _maxVal(downRateMax, stats.downRate)?.toInt(),
      downRateAvg: _avgVal(downRateAvg, stats.downRate)?.toInt(),
      downAttainableRateLast: stats.downAttainableRate,
      downAttainableRateMin: _minVal(downAttainableRateMin, stats.downAttainableRate)?.toInt(),
      downAttainableRateMax: _maxVal(downAttainableRateMax, stats.downAttainableRate)?.toInt(),
      downAttainableRateAvg: _avgVal(downAttainableRateAvg, stats.downAttainableRate)?.toInt(),
      upRateLast: stats.upRate,
      upRateMin: _minVal(upRateMin, stats.upRate)?.toInt(),
      upRateMax: _maxVal(upRateMax, stats.upRate)?.toInt(),
      upRateAvg: _avgVal(upRateAvg, stats.upRate)?.toInt(),
      upAttainableRateLast: stats.upAttainableRate,
      upAttainableRateMin: _minVal(upAttainableRateMin, stats.upAttainableRate)?.toInt(),
      upAttainableRateMax: _maxVal(upAttainableRateMax, stats.upAttainableRate)?.toInt(),
      upAttainableRateAvg: _avgVal(upAttainableRateAvg, stats.upAttainableRate)?.toInt(),
      downSNRmLast: stats.downMargin,
      downSNRmMin: _minVal(downSNRmMin, stats.downMargin)?.toDouble(),
      downSNRmMax: _maxVal(downSNRmMax, stats.downMargin)?.toDouble(),
      downSNRmAvg: _avgVal(downSNRmAvg, stats.downMargin)?.toDouble(),
      upSNRmLast: stats.upMargin,
      upSNRmMin: _minVal(upSNRmMin, stats.upMargin)?.toDouble(),
      upSNRmMax: _maxVal(upSNRmMax, stats.upMargin)?.toDouble(),
      upSNRmAvg: _avgVal(upSNRmAvg, stats.upMargin)?.toDouble(),
      downAttenuationLast: stats.downAttenuation,
      downAttenuationMin: _minVal(downAttenuationMin, stats.downAttenuation)?.toDouble(),
      downAttenuationMax: _maxVal(downAttenuationMax, stats.downAttenuation)?.toDouble(),
      downAttenuationAvg: _avgVal(downAttenuationAvg, stats.downAttenuation)?.toDouble(),
      upAttenuationLast: stats.upAttenuation,
      upAttenuationMin: _minVal(upAttenuationMin, stats.upAttenuation)?.toDouble(),
      upAttenuationMax: _maxVal(upAttenuationMax, stats.upAttenuation)?.toDouble(),
      upAttenuationAvg: _avgVal(upAttenuationAvg, stats.upAttenuation)?.toDouble(),
      downFecLast: stats.downFEC,
      downFecTotal: ((downFecTotal ?? 0) + _incrDiff(downFecLast, stats.downFEC)).toInt(),
      upFecLast: stats.upFEC,
      upFecTotal: ((upFecTotal ?? 0) + _incrDiff(upFecLast, stats.upFEC)).toInt(),
      downCrcLast: stats.downCRC,
      downCrcTotal: ((downCrcTotal ?? 0) + _incrDiff(downCrcLast, stats.downCRC)).toInt(),
      upCrcLast: stats.upCRC,
      upCrcTotal: ((upCrcTotal ?? 0) + _incrDiff(upCrcLast, stats.upCRC)).toInt(),
    );
  }
}

class StatsSamplingService extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final LineStatsRepository _lineStatsRepository;

  final _statsStreamController = StreamController<LineStats>.broadcast();

  StatsSamplingService(this._lineStatsRepository, this._settingsRepository) {
    debugPrint('SamplingService init');
  }

  SessionStats? _sessionStats;
  final _lastSamples = Queue<LineStats>();

  bool get sampling => _sessionStats != null;
  Queue<LineStats> get lastSamples => _lastSamples;
  Stream<LineStats> get statsStream => _statsStreamController.stream;

  SessionStats? get sessionStats => _sessionStats;

  runSampling() async {
    if (sampling) return;

    AppSettings settings = await _settingsRepository.getSettings;
    Duration samplingInterval = settings.samplingInterval;
    String session = DateTime.now().toString();
    NetUnitClient client = NetUnitClient.fromSettings(settings, session);

    _sessionStats = SessionStats.create(session, settings.host, settings.login, settings.pwd);
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
    _lastSamples.clear();
    _sessionStats = null;
    notifyListeners();
  }

  _handleStats(LineStats stats) {
    _sessionStats = _sessionStats?.copyWithStats(stats);
    _lastSamples.addLast(stats);
    if (_lastSamples.length > 10) _lastSamples.removeFirst();
    _statsStreamController.add(stats);
    _lineStatsRepository.insert(stats);
    notifyListeners();

    log('Handled stats: $stats', name: 'StatsSamplingService', time: DateTime.now(), level: 1);
  }

  @override
  void dispose() {
    _statsStreamController.close();
    _sessionStats = null;
    super.dispose();
  }
}
