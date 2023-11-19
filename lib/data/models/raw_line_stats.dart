// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:xdslmt/data/models/line_stats.dart';

/// Mutable builder for [LineStats]
/// Represents raw state from network unit parsed as possible
class RawLineStats {
  final SampleStatus status;
  final String statusText;
  String? connectionType;
  int? upAttainableRate;
  int? downAttainableRate;
  int? upRate;
  int? downRate;
  double? upMargin;
  double? downMargin;
  double? upAttenuation;
  double? downAttenuation;
  int? upCRC;
  int? downCRC;
  int? upFEC;
  int? downFEC;
  RawLineStats({
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

  factory RawLineStats.errored({required String statusText}) {
    return RawLineStats(
      status: SampleStatus.samplingError,
      statusText: statusText,
    );
  }

  factory RawLineStats.connectionDown({required String statusText}) {
    return RawLineStats(
      status: SampleStatus.connectionDown,
      statusText: statusText,
    );
  }

  factory RawLineStats.connectionUp({required String statusText}) {
    return RawLineStats(
      status: SampleStatus.connectionUp,
      statusText: statusText,
    );
  }

  @override
  String toString() {
    return 'RawLineStats(status: $status, statusText: $statusText, connectionType: $connectionType, upAttainableRate: $upAttainableRate, downAttainableRate: $downAttainableRate, upRate: $upRate, downRate: $downRate, upMargin: $upMargin, downMargin: $downMargin, upAttenuation: $upAttenuation, downAttenuation: $downAttenuation, upCRC: $upCRC, downCRC: $downCRC, upFEC: $upFEC, downFEC: $downFEC)';
  }
}
