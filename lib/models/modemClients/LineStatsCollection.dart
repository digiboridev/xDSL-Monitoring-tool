class LineStatsCollection {
  final bool isErrored;
  final bool isConnectionUp;
  final String status;
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
  final dateTime = DateTime.now();

  Map get getAsMap {
    return {
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
      'dateTime': dateTime
    };
  }

  LineStatsCollection(
      {this.isErrored,
      this.isConnectionUp,
      this.status,
      this.connectionType,
      this.upMaxRate,
      this.downMaxRate,
      this.upRate,
      this.downRate,
      this.upMargin,
      this.downMargin,
      this.upAttenuation,
      this.downAttenuation,
      this.upCRC,
      this.downCRC,
      this.upFEC,
      this.downFEC});
}
