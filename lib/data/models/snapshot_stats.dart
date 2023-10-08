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

  SnapshotStats copyWithLineStats(LineStats stats) {
    return SnapshotStats._(
      snapshotId: snapshotId,
      host: host,
      login: login,
      password: password,
      startTime: startTime,
      samples: samples + 1,
      disconnects: _isDisconnect(stats.status) ? disconnects + 1 : disconnects,
      samplingErrors: _isSamplingError(stats.status) ? samplingErrors + 1 : samplingErrors,
      samplingDuration: DateTime.now().difference(startTime),
      uplinkDuration: uplinkDuration + uplinkDurationIncrement(stats.status, stats.time),
      lastSampleStatus: stats.status,
      lastSampleTime: stats.time,
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
        other.lastSampleTime == lastSampleTime &&
        other.downRateLast == downRateLast &&
        other.downRateMin == downRateMin &&
        other.downRateMax == downRateMax &&
        other.downRateAvg == downRateAvg &&
        other.downAttainableRateLast == downAttainableRateLast &&
        other.downAttainableRateMin == downAttainableRateMin &&
        other.downAttainableRateMax == downAttainableRateMax &&
        other.downAttainableRateAvg == downAttainableRateAvg &&
        other.upRateLast == upRateLast &&
        other.upRateMin == upRateMin &&
        other.upRateMax == upRateMax &&
        other.upRateAvg == upRateAvg &&
        other.upAttainableRateLast == upAttainableRateLast &&
        other.upAttainableRateMin == upAttainableRateMin &&
        other.upAttainableRateMax == upAttainableRateMax &&
        other.upAttainableRateAvg == upAttainableRateAvg &&
        other.downSNRmLast == downSNRmLast &&
        other.downSNRmMin == downSNRmMin &&
        other.downSNRmMax == downSNRmMax &&
        other.downSNRmAvg == downSNRmAvg &&
        other.upSNRmLast == upSNRmLast &&
        other.upSNRmMin == upSNRmMin &&
        other.upSNRmMax == upSNRmMax &&
        other.upSNRmAvg == upSNRmAvg &&
        other.downAttenuationLast == downAttenuationLast &&
        other.downAttenuationMin == downAttenuationMin &&
        other.downAttenuationMax == downAttenuationMax &&
        other.downAttenuationAvg == downAttenuationAvg &&
        other.upAttenuationLast == upAttenuationLast &&
        other.upAttenuationMin == upAttenuationMin &&
        other.upAttenuationMax == upAttenuationMax &&
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
        lastSampleTime.hashCode ^
        downRateLast.hashCode ^
        downRateMin.hashCode ^
        downRateMax.hashCode ^
        downRateAvg.hashCode ^
        downAttainableRateLast.hashCode ^
        downAttainableRateMin.hashCode ^
        downAttainableRateMax.hashCode ^
        downAttainableRateAvg.hashCode ^
        upRateLast.hashCode ^
        upRateMin.hashCode ^
        upRateMax.hashCode ^
        upRateAvg.hashCode ^
        upAttainableRateLast.hashCode ^
        upAttainableRateMin.hashCode ^
        upAttainableRateMax.hashCode ^
        upAttainableRateAvg.hashCode ^
        downSNRmLast.hashCode ^
        downSNRmMin.hashCode ^
        downSNRmMax.hashCode ^
        downSNRmAvg.hashCode ^
        upSNRmLast.hashCode ^
        upSNRmMin.hashCode ^
        upSNRmMax.hashCode ^
        upSNRmAvg.hashCode ^
        downAttenuationLast.hashCode ^
        downAttenuationMin.hashCode ^
        downAttenuationMax.hashCode ^
        downAttenuationAvg.hashCode ^
        upAttenuationLast.hashCode ^
        upAttenuationMin.hashCode ^
        upAttenuationMax.hashCode ^
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

  @override
  String toString() {
    return 'SnapshotStats(snapshotId: $snapshotId, host: $host, login: $login, password: $password, startTime: $startTime, samples: $samples, disconnects: $disconnects, samplingErrors: $samplingErrors, samplingDuration: $samplingDuration, uplinkDuration: $uplinkDuration, lastSampleStatus: $lastSampleStatus, lastSampleTime: $lastSampleTime, downRateLast: $downRateLast, downRateMin: $downRateMin, downRateMax: $downRateMax, downRateAvg: $downRateAvg, downAttainableRateLast: $downAttainableRateLast, downAttainableRateMin: $downAttainableRateMin, downAttainableRateMax: $downAttainableRateMax, downAttainableRateAvg: $downAttainableRateAvg, upRateLast: $upRateLast, upRateMin: $upRateMin, upRateMax: $upRateMax, upRateAvg: $upRateAvg, upAttainableRateLast: $upAttainableRateLast, upAttainableRateMin: $upAttainableRateMin, upAttainableRateMax: $upAttainableRateMax, upAttainableRateAvg: $upAttainableRateAvg, downSNRmLast: $downSNRmLast, downSNRmMin: $downSNRmMin, downSNRmMax: $downSNRmMax, downSNRmAvg: $downSNRmAvg, upSNRmLast: $upSNRmLast, upSNRmMin: $upSNRmMin, upSNRmMax: $upSNRmMax, upSNRmAvg: $upSNRmAvg, downAttenuationLast: $downAttenuationLast, downAttenuationMin: $downAttenuationMin, downAttenuationMax: $downAttenuationMax, downAttenuationAvg: $downAttenuationAvg, upAttenuationLast: $upAttenuationLast, upAttenuationMin: $upAttenuationMin, upAttenuationMax: $upAttenuationMax, upAttenuationAvg: $upAttenuationAvg, downFecLast: $downFecLast, downFecTotal: $downFecTotal, upFecLast: $upFecLast, upFecTotal: $upFecTotal, downCrcLast: $downCrcLast, downCrcTotal: $downCrcTotal, upCrcLast: $upCrcLast, upCrcTotal: $upCrcTotal)';
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
      'lastSampleTime': lastSampleTime?.millisecondsSinceEpoch,
      'downRateLast': downRateLast,
      'downRateMin': downRateMin,
      'downRateMax': downRateMax,
      'downRateAvg': downRateAvg,
      'downAttainableRateLast': downAttainableRateLast,
      'downAttainableRateMin': downAttainableRateMin,
      'downAttainableRateMax': downAttainableRateMax,
      'downAttainableRateAvg': downAttainableRateAvg,
      'upRateLast': upRateLast,
      'upRateMin': upRateMin,
      'upRateMax': upRateMax,
      'upRateAvg': upRateAvg,
      'upAttainableRateLast': upAttainableRateLast,
      'upAttainableRateMin': upAttainableRateMin,
      'upAttainableRateMax': upAttainableRateMax,
      'upAttainableRateAvg': upAttainableRateAvg,
      'downSNRmLast': downSNRmLast,
      'downSNRmMin': downSNRmMin,
      'downSNRmMax': downSNRmMax,
      'downSNRmAvg': downSNRmAvg,
      'upSNRmLast': upSNRmLast,
      'upSNRmMin': upSNRmMin,
      'upSNRmMax': upSNRmMax,
      'upSNRmAvg': upSNRmAvg,
      'downAttenuationLast': downAttenuationLast,
      'downAttenuationMin': downAttenuationMin,
      'downAttenuationMax': downAttenuationMax,
      'downAttenuationAvg': downAttenuationAvg,
      'upAttenuationLast': upAttenuationLast,
      'upAttenuationMin': upAttenuationMin,
      'upAttenuationMax': upAttenuationMax,
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
      lastSampleTime: map['lastSampleTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastSampleTime'] as int) : null,
      downRateLast: map['downRateLast'] != null ? map['downRateLast'] as int : null,
      downRateMin: map['downRateMin'] != null ? map['downRateMin'] as int : null,
      downRateMax: map['downRateMax'] != null ? map['downRateMax'] as int : null,
      downRateAvg: map['downRateAvg'] != null ? map['downRateAvg'] as int : null,
      downAttainableRateLast: map['downAttainableRateLast'] != null ? map['downAttainableRateLast'] as int : null,
      downAttainableRateMin: map['downAttainableRateMin'] != null ? map['downAttainableRateMin'] as int : null,
      downAttainableRateMax: map['downAttainableRateMax'] != null ? map['downAttainableRateMax'] as int : null,
      downAttainableRateAvg: map['downAttainableRateAvg'] != null ? map['downAttainableRateAvg'] as int : null,
      upRateLast: map['upRateLast'] != null ? map['upRateLast'] as int : null,
      upRateMin: map['upRateMin'] != null ? map['upRateMin'] as int : null,
      upRateMax: map['upRateMax'] != null ? map['upRateMax'] as int : null,
      upRateAvg: map['upRateAvg'] != null ? map['upRateAvg'] as int : null,
      upAttainableRateLast: map['upAttainableRateLast'] != null ? map['upAttainableRateLast'] as int : null,
      upAttainableRateMin: map['upAttainableRateMin'] != null ? map['upAttainableRateMin'] as int : null,
      upAttainableRateMax: map['upAttainableRateMax'] != null ? map['upAttainableRateMax'] as int : null,
      upAttainableRateAvg: map['upAttainableRateAvg'] != null ? map['upAttainableRateAvg'] as int : null,
      downSNRmLast: map['downSNRmLast'] != null ? map['downSNRmLast'] as double : null,
      downSNRmMin: map['downSNRmMin'] != null ? map['downSNRmMin'] as double : null,
      downSNRmMax: map['downSNRmMax'] != null ? map['downSNRmMax'] as double : null,
      downSNRmAvg: map['downSNRmAvg'] != null ? map['downSNRmAvg'] as double : null,
      upSNRmLast: map['upSNRmLast'] != null ? map['upSNRmLast'] as double : null,
      upSNRmMin: map['upSNRmMin'] != null ? map['upSNRmMin'] as double : null,
      upSNRmMax: map['upSNRmMax'] != null ? map['upSNRmMax'] as double : null,
      upSNRmAvg: map['upSNRmAvg'] != null ? map['upSNRmAvg'] as double : null,
      downAttenuationLast: map['downAttenuationLast'] != null ? map['downAttenuationLast'] as double : null,
      downAttenuationMin: map['downAttenuationMin'] != null ? map['downAttenuationMin'] as double : null,
      downAttenuationMax: map['downAttenuationMax'] != null ? map['downAttenuationMax'] as double : null,
      downAttenuationAvg: map['downAttenuationAvg'] != null ? map['downAttenuationAvg'] as double : null,
      upAttenuationLast: map['upAttenuationLast'] != null ? map['upAttenuationLast'] as double : null,
      upAttenuationMin: map['upAttenuationMin'] != null ? map['upAttenuationMin'] as double : null,
      upAttenuationMax: map['upAttenuationMax'] != null ? map['upAttenuationMax'] as double : null,
      upAttenuationAvg: map['upAttenuationAvg'] != null ? map['upAttenuationAvg'] as double : null,
      downFecLast: map['downFecLast'] != null ? map['downFecLast'] as int : null,
      downFecTotal: map['downFecTotal'] != null ? map['downFecTotal'] as int : null,
      upFecLast: map['upFecLast'] != null ? map['upFecLast'] as int : null,
      upFecTotal: map['upFecTotal'] != null ? map['upFecTotal'] as int : null,
      downCrcLast: map['downCrcLast'] != null ? map['downCrcLast'] as int : null,
      downCrcTotal: map['downCrcTotal'] != null ? map['downCrcTotal'] as int : null,
      upCrcLast: map['upCrcLast'] != null ? map['upCrcLast'] as int : null,
      upCrcTotal: map['upCrcTotal'] != null ? map['upCrcTotal'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SnapshotStats.fromJson(String source) => SnapshotStats.fromMap(json.decode(source) as Map<String, dynamic>);
}
