import 'package:hive/hive.dart';

part 'LineStatsCollection.g.dart';

@HiveType(typeId: 30)
class LineStatsCollection {
  @HiveField(18)
  final bool isErrored;
  @HiveField(0)
  final bool isConnectionUp;
  @HiveField(1)
  final String status;
  @HiveField(2)
  final String connectionType;
  @HiveField(3)
  final int upMaxRate;
  @HiveField(4)
  final int downMaxRate;
  @HiveField(5)
  final int upRate;
  @HiveField(6)
  final int downRate;
  @HiveField(7)
  final double upMargin;
  @HiveField(8)
  final double downMargin;
  @HiveField(9)
  final double upAttenuation;
  @HiveField(10)
  final double downAttenuation;
  @HiveField(11)
  final int upCRC;
  @HiveField(12)
  final int downCRC;
  @HiveField(13)
  final int upFEC;
  @HiveField(14)
  final int downFEC;
  @HiveField(17)
  final DateTime dateTime;
  @HiveField(28)
  final double latencyToModem;
  @HiveField(29)
  final double latencyToExternal;

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
      'dateTime': dateTime,
      'latencyToModem': latencyToModem,
      'latencyToExternal': latencyToExternal
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
      this.downFEC,
      this.dateTime,
      this.latencyToModem,
      this.latencyToExternal});
}
