// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/raw_line_stats.dart';

RawLineStats? bcm63xxParser(String msg) {
  if (msg.contains('Status:')) {
    final statusText = RegExp(r'(?<=Status: ).+').firstMatch(msg)?.group(0) ?? 'unknown';
    final status = statusText.toLowerCase().contains('showtime') ? SampleStatus.connectionUp : SampleStatus.connectionDown;
    var linestats = RawLineStats(status: status, statusText: statusText);

    final connectionType = RegExp(r'(?<=Mode:                   ).+').firstMatch(msg)?.group(0);
    if (connectionType != null) linestats.connectionType = connectionType;

    final spd = RegExp(r'(?<=Bearer: 0,).+').firstMatch(msg)?.group(0);
    if (spd != null) {
      final upRate = RegExp(r'(?<=Upstream rate = )\d+').firstMatch(spd)?.group(0);
      if (upRate != null) linestats.upRate = int.tryParse(upRate);
      final downRate = RegExp(r'(?<=Downstream rate = )\d+').firstMatch(spd)?.group(0);
      if (downRate != null) linestats.downRate = int.tryParse(downRate);
    }

    final maxSpd = RegExp(r'(?<=Max:    ).+').firstMatch(msg)?.group(0);
    if (maxSpd != null) {
      final upMaxRate = RegExp(r'(?<=Upstream rate = )\d+').firstMatch(maxSpd)?.group(0);
      if (upMaxRate != null) linestats.upAttainableRate = int.tryParse(upMaxRate);
      final downMaxRate = RegExp(r'(?<=Downstream rate = )\d+').firstMatch(maxSpd)?.group(0);
      if (downMaxRate != null) linestats.downAttainableRate = int.tryParse(downMaxRate);
    }

    final snr = RegExp(r'(?<=SNR \(dB\):).+').firstMatch(msg)?.group(0);
    final snrArr = snr?.split(RegExp(r'\s+')) ?? [];

    final upMargin = snrArr.elementAtOrNull(2);
    if (upMargin != null) linestats.upMargin = double.tryParse(upMargin);
    final downMargin = snrArr.elementAtOrNull(1);
    if (downMargin != null) linestats.downMargin = double.tryParse(downMargin);

    final att = RegExp(r'(?<=Attn\(dB\):).+').firstMatch(msg)?.group(0);
    final attArr = att?.split(RegExp(r'\s+')) ?? [];

    final upAttenuation = attArr.elementAtOrNull(2);
    if (upAttenuation != null) linestats.upAttenuation = double.tryParse(upAttenuation);
    final downAttenuation = attArr.elementAtOrNull(1);
    if (downAttenuation != null) linestats.downAttenuation = double.tryParse(downAttenuation);

    final fex = RegExp(r'(?<=RSCorr:).+').firstMatch(msg)?.group(0);
    final fecArr = fex?.split(RegExp(r'\s+')) ?? [];

    final upFEC = fecArr.elementAtOrNull(2);
    if (upFEC != null) linestats.upFEC = int.tryParse(upFEC);
    final downFEC = fecArr.elementAtOrNull(1);
    if (downFEC != null) linestats.downFEC = int.tryParse(downFEC);

    final crc = RegExp(r'(?<=RSUnCorr:).+').firstMatch(msg)?.group(0);
    final crcArr = crc?.split(RegExp(r'\s+')) ?? [];

    final upCRC = crcArr.elementAtOrNull(2);
    if (upCRC != null) linestats.upCRC = int.tryParse(upCRC);
    final downCRC = crcArr.elementAtOrNull(1);
    if (downCRC != null) linestats.downCRC = int.tryParse(downCRC);

    return linestats;
  }

  return null;
}
