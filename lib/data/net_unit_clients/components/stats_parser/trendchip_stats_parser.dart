// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/raw_line_stats.dart';

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

      final nbr = int.tryParse(RegExp(r'(?<=near-end bit rate:\s*)\d+').stringMatch(msg) ?? '');
      if (nbr != null && nbr > 0) linestats.downRate = nbr;
      final nibr = int.tryParse(RegExp(r'(?<=near-end interleaved channel bit rate:\s*)\d+').stringMatch(msg) ?? '');
      if (nibr != null && nibr > 0) linestats.downRate = nibr;
      final nfbr = int.tryParse(RegExp(r'(?<=near-end fast channel bit rate:\s*)\d+').stringMatch(msg) ?? '');
      if (nfbr != null && nfbr > 0) linestats.downRate = nfbr;

      final fbr = int.tryParse(RegExp(r'(?<=far-end bit rate:\s*)\d+').stringMatch(msg) ?? '');
      if (fbr != null && fbr > 0) linestats.upRate = fbr;
      final fibr = int.tryParse(RegExp(r'(?<=far-end interleaved channel bit rate:\s*)\d+').stringMatch(msg) ?? '');
      if (fibr != null && fibr > 0) linestats.upRate = fibr;
      final ffbr = int.tryParse(RegExp(r'(?<=far-end fast channel bit rate:\s*)\d+').stringMatch(msg) ?? '');
      if (ffbr != null && ffbr > 0) linestats.upRate = ffbr;

      final downMargin = RegExp(r'(?<=noise margin downstream:\s*)\d+').stringMatch(msg);
      if (downMargin != null) linestats.downMargin = double.tryParse(downMargin);

      final upMargin = RegExp(r'(?<=noise margin upstream:\s*)\d+').stringMatch(msg);
      if (upMargin != null) linestats.upMargin = double.tryParse(upMargin);

      final downAttenuation = RegExp(r'(?<=attenuation downstream:\s*)\d+').stringMatch(msg);
      if (downAttenuation != null) linestats.downAttenuation = double.tryParse(downAttenuation);

      final upAttenuation = RegExp(r'(?<=attenuation upstream:\s*)\d+').stringMatch(msg);
      if (upAttenuation != null) linestats.upAttenuation = double.tryParse(upAttenuation);

      int downCRC = 0;
      final downCRCIr = int.tryParse(RegExp(r'(?<=near-end CRC error interleaved:\s*)\d+').stringMatch(msg) ?? '');
      if (downCRCIr != null) downCRC += downCRCIr;
      final downCRCF = int.tryParse(RegExp(r'(?<=near-end CRC error fast:\s*)\d+').stringMatch(msg) ?? '');
      if (downCRCF != null) downCRC += downCRCF;
      linestats.downCRC = downCRC;

      int upCRC = 0;
      final upCRCIr = int.tryParse(RegExp(r'(?<=far-end CRC error interleaved:\s*)\d+').stringMatch(msg) ?? '');
      if (upCRCIr != null) upCRC += upCRCIr;
      final upCRCF = int.tryParse(RegExp(r'(?<=far-end CRC error fast:\s*)\d+').stringMatch(msg) ?? '');
      if (upCRCF != null) upCRC += upCRCF;
      linestats.upCRC = upCRC;

      int downFEC = 0;
      final downFECIr = int.tryParse(RegExp(r'(?<=near-end FEC error interleaved:\s*)\d+').stringMatch(msg) ?? '');
      if (downFECIr != null) downFEC += downFECIr;
      final downFECF = int.tryParse(RegExp(r'(?<=near-end FEC error fast:\s*)\d+').stringMatch(msg) ?? '');
      if (downFECF != null) downFEC += downFECF;
      linestats.downFEC = downFEC;

      int upFEC = 0;
      final upFECIr = int.tryParse(RegExp(r'(?<=far-end FEC error interleaved:\s*)\d+').stringMatch(msg) ?? '');
      if (upFECIr != null) upFEC += upFECIr;
      final upFECF = int.tryParse(RegExp(r'(?<=far-end FEC error fast:\s*)\d+').stringMatch(msg) ?? '');
      if (upFECF != null) upFEC += upFECF;
      linestats.upFEC = upFEC;

      return linestats;
    }

    return RawLineStats(status: SampleStatus.connectionDown, statusText: status);
  } else {
    return null;
  }
}
