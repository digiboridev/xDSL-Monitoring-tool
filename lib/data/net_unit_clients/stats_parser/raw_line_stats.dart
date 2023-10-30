// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:xdslmt/data/models/line_stats.dart';

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
}
