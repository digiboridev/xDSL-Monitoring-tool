// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:xdslmt/data/models/network_unit_type.dart';

class AppSettings {
  final NetworkUnitType nuType;
  final String host;
  final String login;
  final String pwd;
  final Duration samplingInterval;
  final Duration splitInterval;
  final bool animations;
  final bool orientLock;
  final bool wakeLock;
  final bool foregroundService;

  AppSettings._({
    required this.nuType,
    required this.host,
    required this.login,
    required this.pwd,
    required this.samplingInterval,
    required this.splitInterval,
    required this.animations,
    required this.orientLock,
    required this.wakeLock,
    required this.foregroundService,
  });

  factory AppSettings.base() {
    return AppSettings._(
      nuType: NetworkUnitType.simulator,
      host: '192.168.1.1',
      login: 'admin',
      pwd: 'admin',
      samplingInterval: const Duration(seconds: 1),
      splitInterval: const Duration(minutes: 60),
      animations: true,
      orientLock: true,
      wakeLock: true,
      foregroundService: true,
    );
  }

  AppSettings copyWith({
    NetworkUnitType? nuType,
    String? host,
    String? login,
    String? pwd,
    Duration? samplingInterval,
    Duration? splitInterval,
    bool? animations,
    bool? orientLock,
    bool? wakeLock,
    bool? foregroundService,
  }) {
    return AppSettings._(
      nuType: nuType ?? this.nuType,
      host: host ?? this.host,
      login: login ?? this.login,
      pwd: pwd ?? this.pwd,
      samplingInterval: samplingInterval ?? this.samplingInterval,
      splitInterval: splitInterval ?? this.splitInterval,
      animations: animations ?? this.animations,
      orientLock: orientLock ?? this.orientLock,
      wakeLock: wakeLock ?? this.wakeLock,
      foregroundService: foregroundService ?? this.foregroundService,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nuType': nuType.name,
      'host': host,
      'login': login,
      'pwd': pwd,
      'samplingInterval': samplingInterval.inMilliseconds,
      'splitInterval': splitInterval.inMilliseconds,
      'animations': animations,
      'orientLock': orientLock,
      'wakeLock': wakeLock,
      'foregroundService': foregroundService,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings._(
      nuType: NetworkUnitType.values.byName(map['nuType'] as String),
      host: map['host'] as String,
      login: map['login'] as String,
      pwd: map['pwd'] as String,
      samplingInterval: Duration(milliseconds: (map['samplingInterval'] as num).toInt()),
      splitInterval: Duration(milliseconds: (map['splitInterval'] as num).toInt()),
      animations: map['animations'] as bool,
      orientLock: map['orientLock'] as bool,
      wakeLock: map['wakeLock'] as bool,
      foregroundService: map['foregroundService'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) => AppSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppSettings(nuType: $nuType, host: $host, login: $login, pwd: $pwd, samplingInterval: $samplingInterval, splitInterval: $splitInterval, animations: $animations, orientLock: $orientLock), wakeLock: $wakeLock, foregroundService: $foregroundService';
  }

  @override
  bool operator ==(covariant AppSettings other) {
    if (identical(this, other)) return true;

    return other.nuType == nuType &&
        other.host == host &&
        other.login == login &&
        other.pwd == pwd &&
        other.samplingInterval == samplingInterval &&
        other.splitInterval == splitInterval &&
        other.animations == animations &&
        other.orientLock == orientLock &&
        other.wakeLock == wakeLock &&
        other.foregroundService == foregroundService;
  }

  @override
  int get hashCode {
    return nuType.hashCode ^
        host.hashCode ^
        login.hashCode ^
        pwd.hashCode ^
        samplingInterval.hashCode ^
        splitInterval.hashCode ^
        animations.hashCode ^
        orientLock.hashCode ^
        wakeLock.hashCode ^
        foregroundService.hashCode;
  }
}
