// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:xdsl_mt/data/models/network_unit_type.dart';

class AppSettings {
  final NetworkUnitType nuType;
  final String host;
  final String login;
  final String pwd;
  final Duration samplingInterval;
  final Duration splitInterval;
  final String externalHost;
  final bool animations;
  final bool orientLock;

  AppSettings._({
    required this.nuType,
    required this.host,
    required this.login,
    required this.pwd,
    required this.samplingInterval,
    required this.splitInterval,
    required this.externalHost,
    required this.animations,
    required this.orientLock,
  });

  factory AppSettings.base() {
    return AppSettings._(
      nuType: NetworkUnitType.simulator,
      host: '192.168.1.1',
      login: 'admin',
      pwd: 'admin',
      samplingInterval: Duration(seconds: 1),
      splitInterval: Duration(minutes: 30),
      externalHost: '8.8.8.8',
      animations: true,
      orientLock: true,
    );
  }

  AppSettings copyWith({
    NetworkUnitType? nuType,
    String? host,
    String? login,
    String? pwd,
    Duration? samplingInterval,
    Duration? splitInterval,
    String? externalHost,
    bool? animations,
    bool? orientLock,
  }) {
    return AppSettings._(
      nuType: nuType ?? this.nuType,
      host: host ?? this.host,
      login: login ?? this.login,
      pwd: pwd ?? this.pwd,
      samplingInterval: samplingInterval ?? this.samplingInterval,
      splitInterval: splitInterval ?? this.splitInterval,
      externalHost: externalHost ?? this.externalHost,
      animations: animations ?? this.animations,
      orientLock: orientLock ?? this.orientLock,
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
      'externalHost': externalHost,
      'animations': animations,
      'orientLock': orientLock,
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
      externalHost: map['externalHost'] as String,
      animations: map['animations'] as bool,
      orientLock: map['orientLock'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) => AppSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppSettings(nuType: $nuType, host: $host, login: $login, pwd: $pwd, samplingInterval: $samplingInterval, splitInterval: $splitInterval, externalHost: $externalHost, animations: $animations, orientLock: $orientLock)';
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
        other.externalHost == externalHost &&
        other.animations == animations &&
        other.orientLock == orientLock;
  }

  @override
  int get hashCode {
    return nuType.hashCode ^
        host.hashCode ^
        login.hashCode ^
        pwd.hashCode ^
        samplingInterval.hashCode ^
        splitInterval.hashCode ^
        externalHost.hashCode ^
        animations.hashCode ^
        orientLock.hashCode;
  }
}
