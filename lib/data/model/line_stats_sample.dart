class LineStats {
  final String connectionType;
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

  const LineStats({
    required this.connectionType,
    required this.upMaxRate,
    required this.downMaxRate,
    required this.upRate,
    required this.downRate,
    required this.upMargin,
    required this.downMargin,
    required this.upAttenuation,
    required this.downAttenuation,
    required this.upCRC,
    required this.downCRC,
    required this.upFEC,
    required this.downFEC,
  });

  @override
  String toString() {
    return 'LineStats(connectionType: $connectionType, upMaxRate: $upMaxRate, downMaxRate: $downMaxRate, upRate: $upRate, downRate: $downRate, upMargin: $upMargin, downMargin: $downMargin, upAttenuation: $upAttenuation, downAttenuation: $downAttenuation, upCRC: $upCRC, downCRC: $downCRC, upFEC: $upFEC, downFEC: $downFEC)';
  }

  @override
  bool operator ==(covariant LineStats other) {
    if (identical(this, other)) return true;

    return other.connectionType == connectionType &&
        other.upMaxRate == upMaxRate &&
        other.downMaxRate == downMaxRate &&
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
    return connectionType.hashCode ^
        upMaxRate.hashCode ^
        downMaxRate.hashCode ^
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
}

enum SampleStatus {
  samplingError,
  connectionDown,
  connectionUp,
}

class LineStatsSample {
  final DateTime dateTime;
  final String session;
  final SampleStatus status;
  final String statusText;
  final LineStats? lineStats;

  const LineStatsSample._({
    required this.dateTime,
    required this.session,
    required this.status,
    required this.statusText,
    this.lineStats,
  });

  factory LineStatsSample.errored(String session, String statusText) {
    return LineStatsSample._(
      dateTime: DateTime.now(),
      session: session,
      status: SampleStatus.samplingError,
      statusText: statusText,
    );
  }

  factory LineStatsSample.connectionDown(String session, String statusText) {
    return LineStatsSample._(
      dateTime: DateTime.now(),
      session: session,
      status: SampleStatus.connectionDown,
      statusText: statusText,
    );
  }

  factory LineStatsSample.connectionUp(String session, String statusText, LineStats lineStats) {
    return LineStatsSample._(
      dateTime: DateTime.now(),
      session: session,
      status: SampleStatus.connectionUp,
      statusText: statusText,
      lineStats: lineStats,
    );
  }

  @override
  String toString() {
    return 'LineStatsSample(dateTime: $dateTime, session: $session, status: $status, statusText: $statusText, lineStats: $lineStats)';
  }

  @override
  bool operator ==(covariant LineStatsSample other) {
    if (identical(this, other)) return true;

    return other.dateTime == dateTime && other.session == session && other.status == status && other.statusText == statusText && other.lineStats == lineStats;
  }

  @override
  int get hashCode {
    return dateTime.hashCode ^ session.hashCode ^ status.hashCode ^ statusText.hashCode ^ lineStats.hashCode;
  }
}
