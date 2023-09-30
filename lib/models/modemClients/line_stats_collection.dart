// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

// import 'package:hive/hive.dart';

// part 'LineStatsCollection.g.dart';

// @HiveType(typeId: 30)
// class LineStatsCollection {
//   @HiveField(18)
//   final bool isErrored;
//   @HiveField(0)
//   final bool isConnectionUp;
//   @HiveField(1)
//   final String status;
//   @HiveField(2)
//   final String connectionType;
//   @HiveField(3)
//   final int upMaxRate;
//   @HiveField(4)
//   final int downMaxRate;
//   @HiveField(5)
//   final int upRate;
//   @HiveField(6)
//   final int downRate;
//   @HiveField(7)
//   final double upMargin;
//   @HiveField(8)
//   final double downMargin;
//   @HiveField(9)
//   final double upAttenuation;
//   @HiveField(10)
//   final double downAttenuation;
//   @HiveField(11)
//   final int upCRC;
//   @HiveField(12)
//   final int downCRC;
//   @HiveField(13)
//   final int upFEC;
//   @HiveField(14)
//   final int downFEC;
//   @HiveField(17)
//   final DateTime dateTime;
//   @HiveField(28)
//   double latencyToModem;
//   @HiveField(29)
//   double latencyToExternal;

//   Map get getAsMap {
//     return {
//       'isErrored': isErrored,
//       'isConnectionUp': isConnectionUp,
//       'status': status,
//       'connectionType': connectionType,
//       'upMaxRate': upMaxRate,
//       'downMaxRate': downMaxRate,
//       'upRate': upRate,
//       'downRate': downRate,
//       'upMargin': upMargin,
//       'downMargin': downMargin,
//       'upAttenuation': upAttenuation,
//       'downAttenuation': downAttenuation,
//       'upCRC': upCRC,
//       'downCRC': downCRC,
//       'upFEC': upFEC,
//       'downFEC': downFEC,
//       'dateTime': dateTime,
//       'latencyToModem': latencyToModem,
//       'latencyToExternal': latencyToExternal
//     };
//   }

//   LineStatsCollection(
//       {this.isErrored,
//       this.isConnectionUp,
//       this.status,
//       this.connectionType,
//       this.upMaxRate,
//       this.downMaxRate,
//       this.upRate,
//       this.downRate,
//       this.upMargin,
//       this.downMargin,
//       this.upAttenuation,
//       this.downAttenuation,
//       this.upCRC,
//       this.downCRC,
//       this.upFEC,
//       this.downFEC,
//       this.dateTime,
//       this.latencyToModem,
//       this.latencyToExternal});
// }

class LineStatsCollection extends Equatable {
  final bool isErrored;
  final bool isConnectionUp;
  final String status;
  final String connectionType;
  final DateTime dateTime;
  final int upMaxRate;
  final int downMaxRate;
  final int upRate;
  final int downRate;
  final double upMargin;
  final double downMargin;
  final double upAttenuation;
  final double downAttenuation;
  final int upCRC;
  final int downCRC;
  final int upFEC;
  final int downFEC;
  final double latencyToModem;
  final double latencyToExternal;

  const LineStatsCollection({
    required this.isErrored,
    required this.isConnectionUp,
    required this.status,
    required this.connectionType,
    required this.dateTime,
    this.upMaxRate = 0,
    this.downMaxRate = 0,
    this.upRate = 0,
    this.downRate = 0,
    this.upMargin = 0,
    this.downMargin = 0,
    this.upAttenuation = 100,
    this.downAttenuation = 100,
    this.upCRC = 0,
    this.downCRC = 0,
    this.upFEC = 0,
    this.downFEC = 0,
    this.latencyToModem = 0,
    this.latencyToExternal = 0,
  });

  LineStatsCollection copyWith({
    bool? isErrored,
    bool? isConnectionUp,
    String? status,
    String? connectionType,
    int? upMaxRate,
    int? downMaxRate,
    int? upRate,
    int? downRate,
    double? upMargin,
    double? downMargin,
    double? upAttenuation,
    double? downAttenuation,
    int? upCRC,
    int? downCRC,
    int? upFEC,
    int? downFEC,
    DateTime? dateTime,
    double? latencyToModem,
    double? latencyToExternal,
  }) {
    return LineStatsCollection(
      isErrored: isErrored ?? this.isErrored,
      isConnectionUp: isConnectionUp ?? this.isConnectionUp,
      status: status ?? this.status,
      connectionType: connectionType ?? this.connectionType,
      upMaxRate: upMaxRate ?? this.upMaxRate,
      downMaxRate: downMaxRate ?? this.downMaxRate,
      upRate: upRate ?? this.upRate,
      downRate: downRate ?? this.downRate,
      upMargin: upMargin ?? this.upMargin,
      downMargin: downMargin ?? this.downMargin,
      upAttenuation: upAttenuation ?? this.upAttenuation,
      downAttenuation: downAttenuation ?? this.downAttenuation,
      upCRC: upCRC ?? this.upCRC,
      downCRC: downCRC ?? this.downCRC,
      upFEC: upFEC ?? this.upFEC,
      downFEC: downFEC ?? this.downFEC,
      dateTime: dateTime ?? this.dateTime,
      latencyToModem: latencyToModem ?? this.latencyToModem,
      latencyToExternal: latencyToExternal ?? this.latencyToExternal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isErrored': isErrored,
      'isConnectionUp': isConnectionUp,
      'status': status,
      'connectionType': connectionType,
      'upMaxRate': upMaxRate,
      'downMaxRate': downMaxRate,
      'upRate': upRate,
      'downRate': downRate,
      'upMargin': upMargin,
      'downMargin': downMargin,
      'upAttenuation': upAttenuation,
      'downAttenuation': downAttenuation,
      'upCRC': upCRC,
      'downCRC': downCRC,
      'upFEC': upFEC,
      'downFEC': downFEC,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'latencyToModem': latencyToModem,
      'latencyToExternal': latencyToExternal,
    };
  }

  factory LineStatsCollection.fromMap(Map<String, dynamic> map) {
    return LineStatsCollection(
      isErrored: map['isErrored'] as bool,
      isConnectionUp: map['isConnectionUp'] as bool,
      status: map['status'] as String,
      connectionType: map['connectionType'] as String,
      upMaxRate: map['upMaxRate'] as int,
      downMaxRate: map['downMaxRate'] as int,
      upRate: map['upRate'] as int,
      downRate: map['downRate'] as int,
      upMargin: map['upMargin'] as double,
      downMargin: map['downMargin'] as double,
      upAttenuation: map['upAttenuation'] as double,
      downAttenuation: map['downAttenuation'] as double,
      upCRC: map['upCRC'] as int,
      downCRC: map['downCRC'] as int,
      upFEC: map['upFEC'] as int,
      downFEC: map['downFEC'] as int,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      latencyToModem: map['latencyToModem'] as double,
      latencyToExternal: map['latencyToExternal'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory LineStatsCollection.fromJson(String source) => LineStatsCollection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      isErrored,
      isConnectionUp,
      status,
      connectionType,
      upMaxRate,
      downMaxRate,
      upRate,
      downRate,
      upMargin,
      downMargin,
      upAttenuation,
      downAttenuation,
      upCRC,
      downCRC,
      upFEC,
      downFEC,
      dateTime,
      latencyToModem,
      latencyToExternal,
    ];
  }
}
