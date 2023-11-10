// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/components/stats_parser/raw_line_stats.dart';

RawLineStats? trendchipParser(String msg) {
  final status = RegExp(r'(?<=modem status: ).+').stringMatch(msg);

  if (status != null) {
    if (status.trim().toLowerCase() == 'up') {
      var linestats = RawLineStats(status: SampleStatus.connectionUp, statusText: 'Up');

      var connectionType = RegExp(r'(?<=DSL standard: ).+').stringMatch(msg);
      connectionType ??= RegExp(r'(?<=operational mode: ).+').stringMatch(msg);
      if (connectionType != null) linestats.connectionType = connectionType;

      final downMaxRate = RegExp(r'(?<=ATTNDRds\s*=\s*)\d+').stringMatch(msg);
      if (downMaxRate != null) linestats.downAttainableRate = int.tryParse(downMaxRate);

      final upMaxRate = RegExp(r'(?<=ATTNDRus\s*=\s*)\d+').stringMatch(msg);
      if (upMaxRate != null) linestats.upAttainableRate = int.tryParse(upMaxRate);

      var downRate = RegExp(r'(?<=near-end bit rate:\s*)\d+').stringMatch(msg);
      downRate ??= RegExp(r'(?<=near-end interleaved channel bit rate:\s*)\d+').stringMatch(msg);
      downRate ??= RegExp(r'(?<=near-end fast channel bit rate:\s*)\d+').stringMatch(msg);
      if (downRate != null) linestats.downRate = int.tryParse(downRate);

      var upRate = RegExp(r'(?<=far-end bit rate:\s*)\d+').stringMatch(msg);
      upRate ??= RegExp(r'(?<=far-end interleaved channel bit rate:\s*)\d+').stringMatch(msg);
      upRate ??= RegExp(r'(?<=far-end fast channel bit rate:\s*)\d+').stringMatch(msg);
      if (upRate != null) linestats.upRate = int.tryParse(upRate);

      final downMargin = RegExp(r'(?<=noise margin downstream:\s*)\d+').stringMatch(msg);
      if (downMargin != null) linestats.downMargin = double.tryParse(downMargin);

      final upMargin = RegExp(r'(?<=noise margin upstream:\s*)\d+').stringMatch(msg);
      if (upMargin != null) linestats.upMargin = double.tryParse(upMargin);

      final downAttenuation = RegExp(r'(?<=attenuation downstream:\s*)\d+').stringMatch(msg);
      if (downAttenuation != null) linestats.downAttenuation = double.tryParse(downAttenuation);

      final upAttenuation = RegExp(r'(?<=attenuation upstream:\s*)\d+').stringMatch(msg);
      if (upAttenuation != null) linestats.upAttenuation = double.tryParse(upAttenuation);

      var downCRC = RegExp(r'(?<=near-end CRC error interleaved:\s*)\d+').stringMatch(msg);
      downCRC ??= RegExp(r'(?<=near-end CRC error fast:\s*)\d+').stringMatch(msg);
      if (downCRC != null) linestats.downCRC = int.tryParse(downCRC);

      var upCRC = RegExp(r'(?<=far-end CRC error interleaved:\s*)\d+').stringMatch(msg);
      upCRC ??= RegExp(r'(?<=far-end CRC error fast:\s*)\d+').stringMatch(msg);
      if (upCRC != null) linestats.upCRC = int.tryParse(upCRC);

      var downFEC = RegExp(r'(?<=near-end FEC error interleaved:\s*)\d+').stringMatch(msg);
      downFEC ??= RegExp(r'(?<=near-end FEC error fast:\s*)\d+').stringMatch(msg);
      if (downFEC != null) linestats.downFEC = int.tryParse(downFEC);

      var upFEC = RegExp(r'(?<=far-end FEC error interleaved:\s*)\d+').stringMatch(msg);
      upFEC ??= RegExp(r'(?<=far-end FEC error fast:\s*)\d+').stringMatch(msg);
      if (upFEC != null) linestats.upFEC = int.tryParse(upFEC);

      return linestats;
    }

    return RawLineStats(status: SampleStatus.connectionDown, statusText: status);
  } else {
    return null;
  }
}
