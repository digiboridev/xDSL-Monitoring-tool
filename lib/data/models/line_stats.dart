import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
enum SampleStatus {
  samplingError,
  connectionDown,
  connectionUp,
}

// TODO err increase
class LineStats {
  final DateTime time;
  final String session;
  final SampleStatus status;
  final String statusText;
  final String? connectionType;
  final int? upAttainableRate;
  final int? downAttainableRate;
  final int? upRate;
  final int? downRate;
  final double? upMargin;
  final double? downMargin;
  final double? upAttenuation;
  final double? downAttenuation;
  final int? upCRC;
  final int? downCRC;
  final int? upFEC;
  final int? downFEC;

  const LineStats._({
    required this.time,
    required this.session,
    required this.status,
    required this.statusText,
    this.connectionType,
    this.upAttainableRate,
    this.downAttainableRate,
    this.upRate,
    this.downRate,
    this.upMargin,
    this.downMargin,
    this.upAttenuation,
    this.downAttenuation,
    this.upCRC,
    this.downCRC,
    this.upFEC,
    this.downFEC,
  });

  factory LineStats.errored({required String session, required String statusText}) {
    return LineStats._(
      time: DateTime.now(),
      session: session,
      status: SampleStatus.samplingError,
      statusText: statusText,
    );
  }

  factory LineStats.connectionDown({required String session, required String statusText}) {
    return LineStats._(
      time: DateTime.now(),
      session: session,
      status: SampleStatus.connectionDown,
      statusText: statusText,
    );
  }

  factory LineStats.connectionUp({
    required String session,
    required String statusText,
    required String connectionType,
    required int upAttainableRate,
    required int downAttainableRate,
    required int upRate,
    required int downRate,
    required double upMargin,
    required double downMargin,
    required double upAttenuation,
    required double downAttenuation,
    required int upCRC,
    required int downCRC,
    required int upFEC,
    required int downFEC,
  }) {
    return LineStats._(
      time: DateTime.now(),
      session: session,
      status: SampleStatus.connectionUp,
      statusText: statusText,
      connectionType: connectionType,
      upAttainableRate: upAttainableRate,
      downAttainableRate: downAttainableRate,
      upRate: upRate,
      downRate: downRate,
      upMargin: upMargin,
      downMargin: downMargin,
      upAttenuation: upAttenuation,
      downAttenuation: downAttenuation,
      upCRC: upCRC,
      downCRC: downCRC,
      upFEC: upFEC,
      downFEC: downFEC,
    );
  }

  @override
  bool operator ==(covariant LineStats other) {
    if (identical(this, other)) return true;

    return other.time == time &&
        other.session == session &&
        other.status == status &&
        other.statusText == statusText &&
        other.connectionType == connectionType &&
        other.upAttainableRate == upAttainableRate &&
        other.downAttainableRate == downAttainableRate &&
        other.upRate == upRate &&
        other.downRate == downRate &&
        other.upMargin == upMargin &&
        other.downMargin == downMargin &&
        other.upAttenuation == upAttenuation &&
        other.downAttenuation == downAttenuation &&
        other.upCRC == upCRC &&
        other.downCRC == downCRC &&
        other.upFEC == upFEC &&
        other.downFEC == downFEC;
  }

  @override
  int get hashCode {
    return time.hashCode ^
        session.hashCode ^
        status.hashCode ^
        statusText.hashCode ^
        connectionType.hashCode ^
        upAttainableRate.hashCode ^
        downAttainableRate.hashCode ^
        upRate.hashCode ^
        downRate.hashCode ^
        upMargin.hashCode ^
        downMargin.hashCode ^
        upAttenuation.hashCode ^
        downAttenuation.hashCode ^
        upCRC.hashCode ^
        downCRC.hashCode ^
        upFEC.hashCode ^
        downFEC.hashCode;
  }

  @override
  String toString() {
    return 'LineStats(time: $time, session: $session, status: $status, statusText: $statusText, connectionType: $connectionType, upAttainableRate: $upAttainableRate, downAttainableRate: $downAttainableRate, upRate: $upRate, downRate: $downRate, upMargin: $upMargin, downMargin: $downMargin, upAttenuation: $upAttenuation, downAttenuation: $downAttenuation, upCRC: $upCRC, downCRC: $downCRC, upFEC: $upFEC, downFEC: $downFEC)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time': time.millisecondsSinceEpoch,
      'session': session,
      'status': status.name,
      'statusText': statusText,
      'connectionType': connectionType,
      'upAttainableRate': upAttainableRate,
      'downAttainableRate': downAttainableRate,
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
    };
  }

  factory LineStats.fromMap(Map<String, dynamic> map) {
    return LineStats._(
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      session: map['session'] as String,
      status: SampleStatus.values.byName(map['status'] as String),
      statusText: map['statusText'] as String,
      connectionType: map['connectionType'] != null ? map['connectionType'] as String : null,
      upAttainableRate: map['upAttainableRate'] != null ? map['upAttainableRate'] as int : null,
      downAttainableRate: map['downAttainableRate'] != null ? map['downAttainableRate'] as int : null,
      upRate: map['upRate'] != null ? map['upRate'] as int : null,
      downRate: map['downRate'] != null ? map['downRate'] as int : null,
      upMargin: map['upMargin'] != null ? map['upMargin'] as double : null,
      downMargin: map['downMargin'] != null ? map['downMargin'] as double : null,
      upAttenuation: map['upAttenuation'] != null ? map['upAttenuation'] as double : null,
      downAttenuation: map['downAttenuation'] != null ? map['downAttenuation'] as double : null,
      upCRC: map['upCRC'] != null ? map['upCRC'] as int : null,
      downCRC: map['downCRC'] != null ? map['downCRC'] as int : null,
      upFEC: map['upFEC'] != null ? map['upFEC'] as int : null,
      downFEC: map['downFEC'] != null ? map['downFEC'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LineStats.fromJson(String source) => LineStats.fromMap(json.decode(source) as Map<String, dynamic>);
}
