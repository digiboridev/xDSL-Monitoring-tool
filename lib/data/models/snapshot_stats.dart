// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:xdslmt/data/models/line_stats.dart';

class SnapshotStats {
  final String snapshotId;
  final String host;
  final String login;
  final String password;
  final DateTime startTime;
  final int samples;
  final int disconnects;
  final int samplingErrors;
  final Duration samplingDuration;
  final Duration uplinkDuration;
  final SampleStatus? lastSampleStatus;
  final String? lastStatusText;
  final String? lastConnectionType;
  final DateTime? lastSampleTime;
  final int? downRateLast;
  final int? downRateMin;
  final int? downRateMax;
  final int? downRateSum;
  final int? downRateCount;
  final int? downRateAvg;
  final int? downAttainableRateLast;
  final int? downAttainableRateMin;
  final int? downAttainableRateMax;
  final int? downAttainableRateSum;
  final int? downAttainableRateCount;
  final int? downAttainableRateAvg;
  final int? upRateLast;
  final int? upRateMin;
  final int? upRateMax;
  final int? upRateSum;
  final int? upRateCount;
  final int? upRateAvg;
  final int? upAttainableRateLast;
  final int? upAttainableRateMin;
  final int? upAttainableRateMax;
  final int? upAttainableRateSum;
  final int? upAttainableRateCount;
  final int? upAttainableRateAvg;
  final int? downSNRmLast;
  final int? downSNRmMin;
  final int? downSNRmMax;
  final int? downSNRmSum;
  final int? downSNRmCount;
  final int? downSNRmAvg;
  final int? upSNRmLast;
  final int? upSNRmMin;
  final int? upSNRmMax;
  final int? upSNRmSum;
  final int? upSNRmCount;
  final int? upSNRmAvg;
  final int? downAttenuationLast;
  final int? downAttenuationMin;
  final int? downAttenuationMax;
  final int? downAttenuationSum;
  final int? downAttenuationCount;
  final int? downAttenuationAvg;
  final int? upAttenuationLast;
  final int? upAttenuationMin;
  final int? upAttenuationMax;
  final int? upAttenuationSum;
  final int? upAttenuationCount;
  final int? upAttenuationAvg;
  final int? downFecLast;
  final int? downFecTotal;
  final int? upFecLast;
  final int? upFecTotal;
  final int? downCrcLast;
  final int? downCrcTotal;
  final int? upCrcLast;
  final int? upCrcTotal;

  SnapshotStats._({
    required this.snapshotId,
    required this.host,
    required this.login,
    required this.password,
    required this.startTime,
    required this.samples,
    required this.disconnects,
    required this.samplingErrors,
    required this.samplingDuration,
    required this.uplinkDuration,
    this.lastSampleStatus,
    this.lastStatusText,
    this.lastConnectionType,
    this.lastSampleTime,
    this.downRateLast,
    this.downRateMin,
    this.downRateMax,
    this.downRateSum,
    this.downRateCount,
    this.downRateAvg,
    this.downAttainableRateLast,
    this.downAttainableRateMin,
    this.downAttainableRateMax,
    this.downAttainableRateSum,
    this.downAttainableRateCount,
    this.downAttainableRateAvg,
    this.upRateLast,
    this.upRateMin,
    this.upRateMax,
    this.upRateSum,
    this.upRateCount,
    this.upRateAvg,
    this.upAttainableRateLast,
    this.upAttainableRateMin,
    this.upAttainableRateMax,
    this.upAttainableRateSum,
    this.upAttainableRateCount,
    this.upAttainableRateAvg,
    this.downSNRmLast,
    this.downSNRmMin,
    this.downSNRmMax,
    this.downSNRmSum,
    this.downSNRmCount,
    this.downSNRmAvg,
    this.upSNRmLast,
    this.upSNRmMin,
    this.upSNRmMax,
    this.upSNRmSum,
    this.upSNRmCount,
    this.upSNRmAvg,
    this.downAttenuationLast,
    this.downAttenuationMin,
    this.downAttenuationMax,
    this.downAttenuationSum,
    this.downAttenuationCount,
    this.downAttenuationAvg,
    this.upAttenuationLast,
    this.upAttenuationMin,
    this.upAttenuationMax,
    this.upAttenuationSum,
    this.upAttenuationCount,
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

  /// Creates a new snapshot with initial values
  factory SnapshotStats.create(
    String snapshotId,
    String host,
    String login,
    String password,
  ) {
    return SnapshotStats._(
      snapshotId: snapshotId,
      host: host,
      login: login,
      password: password,
      startTime: DateTime.now(),
      samples: 0,
      disconnects: 0,
      samplingErrors: 0,
      samplingDuration: Duration.zero,
      uplinkDuration: Duration.zero,
    );
  }

  int? _minVal(int? prev, int? next) {
    if (prev == null) return next;
    if (next == null) return prev;
    return prev < next ? prev : next;
  }

  int? _maxVal(int? prev, int? next) {
    if (prev == null) return next;
    if (next == null) return prev;
    return prev > next ? prev : next;
  }

  int? _avgVal(int? sum, int? count) {
    if (sum == null) return null;
    if (count == null) return null;
    if (count == 0) return null;
    return sum ~/ count;
  }

  bool _isDisconnect(SampleStatus newStatus) {
    if (lastSampleStatus == SampleStatus.connectionUp && newStatus == SampleStatus.connectionDown) {
      return true;
    } else {
      return false;
    }
  }

  bool _isSamplingError(SampleStatus newStatus) {
    if (newStatus == SampleStatus.samplingError) {
      return true;
    } else {
      return false;
    }
  }

  Duration uplinkDurationIncrement(SampleStatus newStatus, DateTime newTime) {
    if (lastSampleTime == null) return Duration.zero;
    if (lastSampleStatus != SampleStatus.connectionUp) return Duration.zero;
    if (newStatus != SampleStatus.connectionUp) return Duration.zero;

    return newTime.difference(lastSampleTime!);
  }

  SnapshotStats copyWithLineStats(LineStats lineStats) {
    return SnapshotStats._(
      snapshotId: snapshotId,
      host: host,
      login: login,
      password: password,
      startTime: startTime,
      samples: samples + 1,
      disconnects: _isDisconnect(lineStats.status) ? disconnects + 1 : disconnects,
      samplingErrors: _isSamplingError(lineStats.status) ? samplingErrors + 1 : samplingErrors,
      samplingDuration: DateTime.now().difference(startTime),
      uplinkDuration: uplinkDuration + uplinkDurationIncrement(lineStats.status, lineStats.time),
      lastSampleStatus: lineStats.status,
      lastStatusText: lineStats.statusText,
      lastConnectionType: lineStats.connectionType ?? lastConnectionType,
      lastSampleTime: lineStats.time,
      downRateLast: lineStats.downRate,
      downRateMin: _minVal(downRateMin, lineStats.downRate),
      downRateMax: _maxVal(downRateMax, lineStats.downRate),
      downRateSum: (downRateSum ?? 0) + (lineStats.downRate ?? 0),
      downRateCount: lineStats.downRate != null ? (downRateCount ?? 0) + 1 : downRateCount,
      downRateAvg: _avgVal(downRateSum, downRateCount),
      downAttainableRateLast: lineStats.downAttainableRate,
      downAttainableRateMin: _minVal(downAttainableRateMin, lineStats.downAttainableRate),
      downAttainableRateMax: _maxVal(downAttainableRateMax, lineStats.downAttainableRate),
      downAttainableRateSum: (downAttainableRateSum ?? 0) + (lineStats.downAttainableRate ?? 0),
      downAttainableRateCount: lineStats.downAttainableRate != null ? (downAttainableRateCount ?? 0) + 1 : downAttainableRateCount,
      downAttainableRateAvg: _avgVal(downAttainableRateSum, downAttainableRateCount),
      upRateLast: lineStats.upRate,
      upRateMin: _minVal(upRateMin, lineStats.upRate),
      upRateMax: _maxVal(upRateMax, lineStats.upRate),
      upRateSum: (upRateSum ?? 0) + (lineStats.upRate ?? 0),
      upRateCount: lineStats.upRate != null ? (upRateCount ?? 0) + 1 : upRateCount,
      upRateAvg: _avgVal(upRateSum, upRateCount),
      upAttainableRateLast: lineStats.upAttainableRate,
      upAttainableRateMin: _minVal(upAttainableRateMin, lineStats.upAttainableRate),
      upAttainableRateMax: _maxVal(upAttainableRateMax, lineStats.upAttainableRate),
      upAttainableRateSum: (upAttainableRateSum ?? 0) + (lineStats.upAttainableRate ?? 0),
      upAttainableRateCount: lineStats.upAttainableRate != null ? (upAttainableRateCount ?? 0) + 1 : upAttainableRateCount,
      upAttainableRateAvg: _avgVal(upAttainableRateSum, upAttainableRateCount),
      downSNRmLast: lineStats.downMargin,
      downSNRmMin: _minVal(downSNRmMin, lineStats.downMargin),
      downSNRmMax: _maxVal(downSNRmMax, lineStats.downMargin),
      downSNRmSum: (downSNRmSum ?? 0) + (lineStats.downMargin ?? 0),
      downSNRmCount: lineStats.downMargin != null ? (downSNRmCount ?? 0) + 1 : downSNRmCount,
      downSNRmAvg: _avgVal(downSNRmSum, downSNRmCount),
      upSNRmLast: lineStats.upMargin,
      upSNRmMin: _minVal(upSNRmMin, lineStats.upMargin),
      upSNRmMax: _maxVal(upSNRmMax, lineStats.upMargin),
      upSNRmSum: (upSNRmSum ?? 0) + (lineStats.upMargin ?? 0),
      upSNRmCount: lineStats.upMargin != null ? (upSNRmCount ?? 0) + 1 : upSNRmCount,
      upSNRmAvg: _avgVal(upSNRmSum, upSNRmCount),
      downAttenuationLast: lineStats.downAttenuation,
      downAttenuationMin: _minVal(downAttenuationMin, lineStats.downAttenuation),
      downAttenuationMax: _maxVal(downAttenuationMax, lineStats.downAttenuation),
      downAttenuationSum: (downAttenuationSum ?? 0) + (lineStats.downAttenuation ?? 0),
      downAttenuationCount: lineStats.downAttenuation != null ? (downAttenuationCount ?? 0) + 1 : downAttenuationCount,
      downAttenuationAvg: _avgVal(downAttenuationSum, downAttenuationCount),
      upAttenuationLast: lineStats.upAttenuation,
      upAttenuationMin: _minVal(upAttenuationMin, lineStats.upAttenuation),
      upAttenuationMax: _maxVal(upAttenuationMax, lineStats.upAttenuation),
      upAttenuationSum: (upAttenuationSum ?? 0) + (lineStats.upAttenuation ?? 0),
      upAttenuationCount: lineStats.upAttenuation != null ? (upAttenuationCount ?? 0) + 1 : upAttenuationCount,
      upAttenuationAvg: _avgVal(upAttenuationSum, upAttenuationCount),
      downFecTotal: (downFecTotal ?? 0) + (lineStats.downFECIncr ?? 0),
      downFecLast: lineStats.downFECIncr,
      upFecTotal: (upFecTotal ?? 0) + (lineStats.upFECIncr ?? 0),
      upFecLast: lineStats.upFECIncr,
      downCrcTotal: (downCrcTotal ?? 0) + (lineStats.downCRCIncr ?? 0),
      downCrcLast: lineStats.downCRCIncr,
      upCrcTotal: (upCrcTotal ?? 0) + (lineStats.upCRCIncr ?? 0),
      upCrcLast: lineStats.upCRCIncr,
    );
  }

  @override
  String toString() {
    return 'SnapshotStats(snapshotId: $snapshotId, host: $host, login: $login, password: $password, startTime: $startTime, samples: $samples, disconnects: $disconnects, samplingErrors: $samplingErrors, samplingDuration: $samplingDuration, uplinkDuration: $uplinkDuration, lastSampleStatus: $lastSampleStatus, lastStatusText: $lastStatusText, lastConnectionType: $lastConnectionType, lastSampleTime: $lastSampleTime, downRateLast: $downRateLast, downRateMin: $downRateMin, downRateMax: $downRateMax, downRateSum: $downRateSum, downRateCount: $downRateCount, downRateAvg: $downRateAvg, downAttainableRateLast: $downAttainableRateLast, downAttainableRateMin: $downAttainableRateMin, downAttainableRateMax: $downAttainableRateMax, downAttainableRateSum: $downAttainableRateSum, downAttainableRateCount: $downAttainableRateCount, downAttainableRateAvg: $downAttainableRateAvg, upRateLast: $upRateLast, upRateMin: $upRateMin, upRateMax: $upRateMax, upRateSum: $upRateSum, upRateCount: $upRateCount, upRateAvg: $upRateAvg, upAttainableRateLast: $upAttainableRateLast, upAttainableRateMin: $upAttainableRateMin, upAttainableRateMax: $upAttainableRateMax, upAttainableRateSum: $upAttainableRateSum, upAttainableRateCount: $upAttainableRateCount, upAttainableRateAvg: $upAttainableRateAvg, downSNRmLast: $downSNRmLast, downSNRmMin: $downSNRmMin, downSNRmMax: $downSNRmMax, downSNRmSum: $downSNRmSum, downSNRmCount: $downSNRmCount, downSNRmAvg: $downSNRmAvg, upSNRmLast: $upSNRmLast, upSNRmMin: $upSNRmMin, upSNRmMax: $upSNRmMax, upSNRmSum: $upSNRmSum, upSNRmCount: $upSNRmCount, upSNRmAvg: $upSNRmAvg, downAttenuationLast: $downAttenuationLast, downAttenuationMin: $downAttenuationMin, downAttenuationMax: $downAttenuationMax, downAttenuationSum: $downAttenuationSum, downAttenuationCount: $downAttenuationCount, downAttenuationAvg: $downAttenuationAvg, upAttenuationLast: $upAttenuationLast, upAttenuationMin: $upAttenuationMin, upAttenuationMax: $upAttenuationMax, upAttenuationSum: $upAttenuationSum, upAttenuationCount: $upAttenuationCount, upAttenuationAvg: $upAttenuationAvg, downFecLast: $downFecLast, downFecTotal: $downFecTotal, upFecLast: $upFecLast, upFecTotal: $upFecTotal, downCrcLast: $downCrcLast, downCrcTotal: $downCrcTotal, upCrcLast: $upCrcLast, upCrcTotal: $upCrcTotal)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'snapshotId': snapshotId,
      'host': host,
      'login': login,
      'password': password,
      'startTime': startTime.millisecondsSinceEpoch,
      'samples': samples,
      'disconnects': disconnects,
      'samplingErrors': samplingErrors,
      'samplingDuration': samplingDuration.inMilliseconds,
      'uplinkDuration': uplinkDuration.inMilliseconds,
      'lastSampleStatus': lastSampleStatus?.name,
      'lastStatusText': lastStatusText,
      'lastConnectionType': lastConnectionType,
      'lastSampleTime': lastSampleTime?.millisecondsSinceEpoch,
      'downRateLast': downRateLast,
      'downRateMin': downRateMin,
      'downRateMax': downRateMax,
      'downRateSum': downRateSum,
      'downRateCount': downRateCount,
      'downRateAvg': downRateAvg,
      'downAttainableRateLast': downAttainableRateLast,
      'downAttainableRateMin': downAttainableRateMin,
      'downAttainableRateMax': downAttainableRateMax,
      'downAttainableRateSum': downAttainableRateSum,
      'downAttainableRateCount': downAttainableRateCount,
      'downAttainableRateAvg': downAttainableRateAvg,
      'upRateLast': upRateLast,
      'upRateMin': upRateMin,
      'upRateMax': upRateMax,
      'upRateSum': upRateSum,
      'upRateCount': upRateCount,
      'upRateAvg': upRateAvg,
      'upAttainableRateLast': upAttainableRateLast,
      'upAttainableRateMin': upAttainableRateMin,
      'upAttainableRateMax': upAttainableRateMax,
      'upAttainableRateSum': upAttainableRateSum,
      'upAttainableRateCount': upAttainableRateCount,
      'upAttainableRateAvg': upAttainableRateAvg,
      'downSNRmLast': downSNRmLast,
      'downSNRmMin': downSNRmMin,
      'downSNRmMax': downSNRmMax,
      'downSNRmSum': downSNRmSum,
      'downSNRmCount': downSNRmCount,
      'downSNRmAvg': downSNRmAvg,
      'upSNRmLast': upSNRmLast,
      'upSNRmMin': upSNRmMin,
      'upSNRmMax': upSNRmMax,
      'upSNRmSum': upSNRmSum,
      'upSNRmCount': upSNRmCount,
      'upSNRmAvg': upSNRmAvg,
      'downAttenuationLast': downAttenuationLast,
      'downAttenuationMin': downAttenuationMin,
      'downAttenuationMax': downAttenuationMax,
      'downAttenuationSum': downAttenuationSum,
      'downAttenuationCount': downAttenuationCount,
      'downAttenuationAvg': downAttenuationAvg,
      'upAttenuationLast': upAttenuationLast,
      'upAttenuationMin': upAttenuationMin,
      'upAttenuationMax': upAttenuationMax,
      'upAttenuationSum': upAttenuationSum,
      'upAttenuationCount': upAttenuationCount,
      'upAttenuationAvg': upAttenuationAvg,
      'downFecLast': downFecLast,
      'downFecTotal': downFecTotal,
      'upFecLast': upFecLast,
      'upFecTotal': upFecTotal,
      'downCrcLast': downCrcLast,
      'downCrcTotal': downCrcTotal,
      'upCrcLast': upCrcLast,
      'upCrcTotal': upCrcTotal,
    };
  }

  factory SnapshotStats.fromMap(Map<String, dynamic> map) {
    return SnapshotStats._(
      snapshotId: map['snapshotId'] as String,
      host: map['host'] as String,
      login: map['login'] as String,
      password: map['password'] as String,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      samples: map['samples'] as int,
      disconnects: map['disconnects'] as int,
      samplingErrors: map['samplingErrors'] as int,
      samplingDuration: Duration(milliseconds: map['samplingDuration'] as int),
      uplinkDuration: Duration(milliseconds: map['uplinkDuration'] as int),
      lastSampleStatus: map['lastSampleStatus'] != null ? SampleStatus.values.byName(map['lastSampleStatus'] as String) : null,
      lastStatusText: map['lastStatusText'],
      lastConnectionType: map['lastConnectionType'],
      lastSampleTime: map['lastSampleTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastSampleTime'] as int) : null,
      downRateLast: map['downRateLast'],
      downRateMin: map['downRateMin'],
      downRateMax: map['downRateMax'],
      downRateSum: map['downRateSum'],
      downRateCount: map['downRateCount'],
      downRateAvg: map['downRateAvg'],
      downAttainableRateLast: map['downAttainableRateLast'],
      downAttainableRateMin: map['downAttainableRateMin'],
      downAttainableRateMax: map['downAttainableRateMax'],
      downAttainableRateSum: map['downAttainableRateSum'],
      downAttainableRateCount: map['downAttainableRateCount'],
      downAttainableRateAvg: map['downAttainableRateAvg'],
      upRateLast: map['upRateLast'],
      upRateMin: map['upRateMin'],
      upRateMax: map['upRateMax'],
      upRateSum: map['upRateSum'],
      upRateCount: map['upRateCount'],
      upRateAvg: map['upRateAvg'],
      upAttainableRateLast: map['upAttainableRateLast'],
      upAttainableRateMin: map['upAttainableRateMin'],
      upAttainableRateMax: map['upAttainableRateMax'],
      upAttainableRateSum: map['upAttainableRateSum'],
      upAttainableRateCount: map['upAttainableRateCount'],
      upAttainableRateAvg: map['upAttainableRateAvg'],
      downSNRmLast: map['downSNRmLast'],
      downSNRmMin: map['downSNRmMin'],
      downSNRmMax: map['downSNRmMax'],
      downSNRmSum: map['downSNRmSum'],
      downSNRmCount: map['downSNRmCount'],
      downSNRmAvg: map['downSNRmAvg'],
      upSNRmLast: map['upSNRmLast'],
      upSNRmMin: map['upSNRmMin'],
      upSNRmMax: map['upSNRmMax'],
      upSNRmSum: map['upSNRmSum'],
      upSNRmCount: map['upSNRmCount'],
      upSNRmAvg: map['upSNRmAvg'],
      downAttenuationLast: map['downAttenuationLast'],
      downAttenuationMin: map['downAttenuationMin'],
      downAttenuationMax: map['downAttenuationMax'],
      downAttenuationSum: map['downAttenuationSum'],
      downAttenuationCount: map['downAttenuationCount'],
      downAttenuationAvg: map['downAttenuationAvg'],
      upAttenuationLast: map['upAttenuationLast'],
      upAttenuationMin: map['upAttenuationMin'],
      upAttenuationMax: map['upAttenuationMax'],
      upAttenuationSum: map['upAttenuationSum'],
      upAttenuationCount: map['upAttenuationCount'],
      upAttenuationAvg: map['upAttenuationAvg'],
      downFecLast: map['downFecLast'],
      downFecTotal: map['downFecTotal'],
      upFecLast: map['upFecLast'],
      upFecTotal: map['upFecTotal'],
      downCrcLast: map['downCrcLast'],
      downCrcTotal: map['downCrcTotal'],
      upCrcLast: map['upCrcLast'],
      upCrcTotal: map['upCrcTotal'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SnapshotStats.fromJson(String source) => SnapshotStats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant SnapshotStats other) {
    if (identical(this, other)) return true;

    return other.snapshotId == snapshotId &&
        other.host == host &&
        other.login == login &&
        other.password == password &&
        other.startTime == startTime &&
        other.samples == samples &&
        other.disconnects == disconnects &&
        other.samplingErrors == samplingErrors &&
        other.samplingDuration == samplingDuration &&
        other.uplinkDuration == uplinkDuration &&
        other.lastSampleStatus == lastSampleStatus &&
        other.lastStatusText == lastStatusText &&
        other.lastConnectionType == lastConnectionType &&
        other.lastSampleTime == lastSampleTime &&
        other.downRateLast == downRateLast &&
        other.downRateMin == downRateMin &&
        other.downRateMax == downRateMax &&
        other.downRateSum == downRateSum &&
        other.downRateCount == downRateCount &&
        other.downRateAvg == downRateAvg &&
        other.downAttainableRateLast == downAttainableRateLast &&
        other.downAttainableRateMin == downAttainableRateMin &&
        other.downAttainableRateMax == downAttainableRateMax &&
        other.downAttainableRateSum == downAttainableRateSum &&
        other.downAttainableRateCount == downAttainableRateCount &&
        other.downAttainableRateAvg == downAttainableRateAvg &&
        other.upRateLast == upRateLast &&
        other.upRateMin == upRateMin &&
        other.upRateMax == upRateMax &&
        other.upRateSum == upRateSum &&
        other.upRateCount == upRateCount &&
        other.upRateAvg == upRateAvg &&
        other.upAttainableRateLast == upAttainableRateLast &&
        other.upAttainableRateMin == upAttainableRateMin &&
        other.upAttainableRateMax == upAttainableRateMax &&
        other.upAttainableRateSum == upAttainableRateSum &&
        other.upAttainableRateCount == upAttainableRateCount &&
        other.upAttainableRateAvg == upAttainableRateAvg &&
        other.downSNRmLast == downSNRmLast &&
        other.downSNRmMin == downSNRmMin &&
        other.downSNRmMax == downSNRmMax &&
        other.downSNRmSum == downSNRmSum &&
        other.downSNRmCount == downSNRmCount &&
        other.downSNRmAvg == downSNRmAvg &&
        other.upSNRmLast == upSNRmLast &&
        other.upSNRmMin == upSNRmMin &&
        other.upSNRmMax == upSNRmMax &&
        other.upSNRmSum == upSNRmSum &&
        other.upSNRmCount == upSNRmCount &&
        other.upSNRmAvg == upSNRmAvg &&
        other.downAttenuationLast == downAttenuationLast &&
        other.downAttenuationMin == downAttenuationMin &&
        other.downAttenuationMax == downAttenuationMax &&
        other.downAttenuationSum == downAttenuationSum &&
        other.downAttenuationCount == downAttenuationCount &&
        other.downAttenuationAvg == downAttenuationAvg &&
        other.upAttenuationLast == upAttenuationLast &&
        other.upAttenuationMin == upAttenuationMin &&
        other.upAttenuationMax == upAttenuationMax &&
        other.upAttenuationSum == upAttenuationSum &&
        other.upAttenuationCount == upAttenuationCount &&
        other.upAttenuationAvg == upAttenuationAvg &&
        other.downFecLast == downFecLast &&
        other.downFecTotal == downFecTotal &&
        other.upFecLast == upFecLast &&
        other.upFecTotal == upFecTotal &&
        other.downCrcLast == downCrcLast &&
        other.downCrcTotal == downCrcTotal &&
        other.upCrcLast == upCrcLast &&
        other.upCrcTotal == upCrcTotal;
  }

  @override
  int get hashCode {
    return snapshotId.hashCode ^
        host.hashCode ^
        login.hashCode ^
        password.hashCode ^
        startTime.hashCode ^
        samples.hashCode ^
        disconnects.hashCode ^
        samplingErrors.hashCode ^
        samplingDuration.hashCode ^
        uplinkDuration.hashCode ^
        lastSampleStatus.hashCode ^
        lastStatusText.hashCode ^
        lastConnectionType.hashCode ^
        lastSampleTime.hashCode ^
        downRateLast.hashCode ^
        downRateMin.hashCode ^
        downRateMax.hashCode ^
        downRateSum.hashCode ^
        downRateCount.hashCode ^
        downRateAvg.hashCode ^
        downAttainableRateLast.hashCode ^
        downAttainableRateMin.hashCode ^
        downAttainableRateMax.hashCode ^
        downAttainableRateSum.hashCode ^
        downAttainableRateCount.hashCode ^
        downAttainableRateAvg.hashCode ^
        upRateLast.hashCode ^
        upRateMin.hashCode ^
        upRateMax.hashCode ^
        upRateSum.hashCode ^
        upRateCount.hashCode ^
        upRateAvg.hashCode ^
        upAttainableRateLast.hashCode ^
        upAttainableRateMin.hashCode ^
        upAttainableRateMax.hashCode ^
        upAttainableRateSum.hashCode ^
        upAttainableRateCount.hashCode ^
        upAttainableRateAvg.hashCode ^
        downSNRmLast.hashCode ^
        downSNRmMin.hashCode ^
        downSNRmMax.hashCode ^
        downSNRmSum.hashCode ^
        downSNRmCount.hashCode ^
        downSNRmAvg.hashCode ^
        upSNRmLast.hashCode ^
        upSNRmMin.hashCode ^
        upSNRmMax.hashCode ^
        upSNRmSum.hashCode ^
        upSNRmCount.hashCode ^
        upSNRmAvg.hashCode ^
        downAttenuationLast.hashCode ^
        downAttenuationMin.hashCode ^
        downAttenuationMax.hashCode ^
        downAttenuationSum.hashCode ^
        downAttenuationCount.hashCode ^
        downAttenuationAvg.hashCode ^
        upAttenuationLast.hashCode ^
        upAttenuationMin.hashCode ^
        upAttenuationMax.hashCode ^
        upAttenuationSum.hashCode ^
        upAttenuationCount.hashCode ^
        upAttenuationAvg.hashCode ^
        downFecLast.hashCode ^
        downFecTotal.hashCode ^
        upFecLast.hashCode ^
        upFecTotal.hashCode ^
        downCrcLast.hashCode ^
        downCrcTotal.hashCode ^
        upCrcLast.hashCode ^
        upCrcTotal.hashCode;
  }
}
