// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:xdslmt/data/models/line_stats.dart';

class RecentCounters with EquatableMixin {
  // RS error variables

  final List<int?> downFECRecent;
  final int downFECTotal;
  final int downFECLast;
  final List<int?> upFECRecent;
  final int upFECTotal;
  final int upFECLast;
  final List<int?> downCRCRecent;
  final int downCRCTotal;
  final int downCRCLast;
  final List<int?> upCRCRecent;
  final int upCRCTotal;
  final int upCRCLast;

  final int rsMax;

  // SNR variables

  final List<int?> downSNRRecent;
  final List<int?> upSNRRecent;

  final int downSNRCount;
  final int downSNRSum;
  final int downSNRMin;
  final int downSNRMax;
  final int downSNRAvg;

  final int upSNRCount;
  final int upSNRSum;
  final int upSNRMin;
  final int upSNRMax;
  final int upSNRAvg;

  final int snrMin;
  final int snrMax;

  // ATTN variables

  final List<int?> downATTNRecent;
  final List<int?> upATTNRecent;

  final int downATTNCount;
  final int downATTNSum;
  final int downATTNMin;
  final int downATTNMax;
  final int downATTNAvg;

  final int upATTNCount;
  final int upATTNSum;
  final int upATTNMin;
  final int upATTNMax;
  final int upATTNAvg;

  final int attnMin;
  final int attnMax;

  RecentCounters({
    // RS errors variables
    required this.downFECRecent,
    required this.downFECTotal,
    required this.downFECLast,
    required this.upFECRecent,
    required this.upFECTotal,
    required this.upFECLast,
    required this.downCRCRecent,
    required this.downCRCTotal,
    required this.downCRCLast,
    required this.upCRCRecent,
    required this.upCRCTotal,
    required this.upCRCLast,
    required this.rsMax,

    // SNR variables
    required this.downSNRRecent,
    required this.upSNRRecent,
    required this.downSNRCount,
    required this.downSNRSum,
    required this.downSNRMin,
    required this.downSNRMax,
    required this.downSNRAvg,
    required this.upSNRCount,
    required this.upSNRSum,
    required this.upSNRMin,
    required this.upSNRMax,
    required this.upSNRAvg,
    required this.snrMin,
    required this.snrMax,

    // ATTN variables
    required this.downATTNRecent,
    required this.upATTNRecent,
    required this.downATTNCount,
    required this.downATTNSum,
    required this.downATTNMin,
    required this.downATTNMax,
    required this.downATTNAvg,
    required this.upATTNCount,
    required this.upATTNSum,
    required this.upATTNMin,
    required this.upATTNMax,
    required this.upATTNAvg,
    required this.attnMin,
    required this.attnMax,
  });

  factory RecentCounters.fromLineStats(Iterable<LineStats> lineStats) {
    // Pay attention, line stats are in reverse order (newest first)

    // RS errors variables

    List<int?> downFECRecent = [];
    int downFECTotal = 0;
    int downFECLast = 0;
    List<int?> upFECRecent = [];
    int upFECTotal = 0;
    int upFECLast = 0;
    List<int?> downCRCRecent = [];
    int downCRCTotal = 0;
    int downCRCLast = 0;
    List<int?> upCRCRecent = [];
    int upCRCTotal = 0;
    int upCRCLast = 0;

    int rsMax = 0;

    // SNR variables

    List<int?> downSNRRecent = [];
    List<int?> upSNRRecent = [];
    int downSNRCount = 0;
    int downSNRSum = 0;
    int downSNRMin = 99;
    int downSNRMax = 0;
    int downSNRAvg = 0;

    int upSNRCount = 0;
    int upSNRSum = 0;
    int upSNRMin = 99;
    int upSNRMax = 0;
    int upSNRAvg = 0;

    int snrMin = 0;
    int snrMax = 0;

    // ATTN variables

    List<int?> downATTNRecent = [];
    List<int?> upATTNRecent = [];
    int downATTNCount = 0;
    int downATTNSum = 0;
    int downATTNMin = 99;
    int downATTNMax = 0;
    int downATTNAvg = 0;

    int upATTNCount = 0;
    int upATTNSum = 0;
    int upATTNMin = 99;
    int upATTNMax = 0;
    int upATTNAvg = 0;

    int attnMin = 0;
    int attnMax = 0;

    for (var i = 0; i < 500; i++) {
      final s = lineStats.elementAtOrNull(i);

      // RS errors

      final downFECIncr = s?.downFECIncr;
      downFECRecent.add(downFECIncr);
      if (downFECIncr != null) {
        downFECTotal += downFECIncr;
        if (downFECLast == 0) downFECLast = downFECIncr;
        rsMax = downFECIncr > rsMax ? downFECIncr : rsMax;
      }

      final upFECIncr = s?.upFECIncr;
      upFECRecent.add(upFECIncr);
      if (upFECIncr != null) {
        upFECTotal += upFECIncr;
        if (upFECLast == 0) upFECLast = upFECIncr;
        rsMax = upFECIncr > rsMax ? upFECIncr : rsMax;
      }

      final downCRCIncr = s?.downCRCIncr;
      downCRCRecent.add(downCRCIncr);
      if (downCRCIncr != null) {
        downCRCTotal += downCRCIncr;
        if (downCRCLast == 0) downCRCLast = downCRCIncr;
        rsMax = downCRCIncr > rsMax ? downCRCIncr : rsMax;
      }

      final upCRCIncr = s?.upCRCIncr;
      upCRCRecent.add(upCRCIncr);
      if (upCRCIncr != null) {
        upCRCTotal += upCRCIncr;
        if (upCRCLast == 0) upCRCLast = upCRCIncr;
        rsMax = upCRCIncr > rsMax ? upCRCIncr : rsMax;
      }

      // Margins

      final downMargin = s?.downMargin;
      downSNRRecent.add(downMargin);
      if (downMargin != null) {
        if (downMargin < downSNRMin) downSNRMin = downMargin;
        if (downMargin > downSNRMax) downSNRMax = downMargin;
        downSNRCount++;
        downSNRSum += downMargin;
      }

      final upMargin = s?.upMargin;
      upSNRRecent.add(upMargin);
      if (upMargin != null) {
        if (upMargin < upSNRMin) upSNRMin = upMargin;
        if (upMargin > upSNRMax) upSNRMax = upMargin;
        upSNRCount++;
        upSNRSum += upMargin;
      }

      // Attenuations

      final downAttenuation = s?.downAttenuation;
      downATTNRecent.add(downAttenuation);
      if (downAttenuation != null) {
        if (downAttenuation < downATTNMin) downATTNMin = downAttenuation;
        if (downAttenuation > downATTNMax) downATTNMax = downAttenuation;
        downATTNCount++;
        downATTNSum += downAttenuation;
      }

      final upAttenuation = s?.upAttenuation;
      upATTNRecent.add(upAttenuation);
      if (upAttenuation != null) {
        if (upAttenuation < upATTNMin) upATTNMin = upAttenuation;
        if (upAttenuation > upATTNMax) upATTNMax = upAttenuation;
        upATTNCount++;
        upATTNSum += upAttenuation;
      }
    }

    if (downSNRCount > 1 && downSNRSum > 1) downSNRAvg = downSNRSum ~/ downSNRCount;
    if (upSNRCount > 1 && upSNRSum > 1) upSNRAvg = upSNRSum ~/ upSNRCount;
    snrMin = downSNRMin < upSNRMin ? downSNRMin : upSNRMin;
    snrMax = downSNRMax > upSNRMax ? downSNRMax : upSNRMax;

    if (downATTNCount > 1 && downATTNSum > 1) downATTNAvg = downATTNSum ~/ downATTNCount;
    if (upATTNCount > 1 && upATTNSum > 1) upATTNAvg = upATTNSum ~/ upATTNCount;
    attnMin = downATTNMin < upATTNMin ? downATTNMin : upATTNMin;
    attnMax = downATTNMax > upATTNMax ? downATTNMax : upATTNMax;

    return RecentCounters(
      // RS errors variables
      downFECRecent: downFECRecent,
      downFECTotal: downFECTotal,
      downFECLast: downFECLast,
      upFECRecent: upFECRecent,
      upFECTotal: upFECTotal,
      upFECLast: upFECLast,
      downCRCRecent: downCRCRecent,
      downCRCTotal: downCRCTotal,
      downCRCLast: downCRCLast,
      upCRCRecent: upCRCRecent,
      upCRCTotal: upCRCTotal,
      upCRCLast: upCRCLast,
      rsMax: rsMax,

      // SNR variables
      downSNRRecent: downSNRRecent,
      upSNRRecent: upSNRRecent,
      downSNRCount: downSNRCount,
      downSNRSum: downSNRSum,
      downSNRMin: downSNRMin,
      downSNRMax: downSNRMax,
      downSNRAvg: downSNRAvg,
      upSNRCount: upSNRCount,
      upSNRSum: upSNRSum,
      upSNRMin: upSNRMin,
      upSNRMax: upSNRMax,
      upSNRAvg: upSNRAvg,
      snrMin: snrMin,
      snrMax: snrMax,

      // ATTN variables
      downATTNRecent: downATTNRecent,
      upATTNRecent: upATTNRecent,
      downATTNCount: downATTNCount,
      downATTNSum: downATTNSum,
      downATTNMin: downATTNMin,
      downATTNMax: downATTNMax,
      downATTNAvg: downATTNAvg,
      upATTNCount: upATTNCount,
      upATTNSum: upATTNSum,
      upATTNMin: upATTNMin,
      upATTNMax: upATTNMax,
      upATTNAvg: upATTNAvg,
      attnMin: attnMin,
      attnMax: attnMax,
    );
  }

  @override
  List<Object> get props {
    return [
      downFECRecent,
      downFECTotal,
      downFECLast,
      upFECRecent,
      upFECTotal,
      upFECLast,
      downCRCRecent,
      downCRCTotal,
      downCRCLast,
      upCRCRecent,
      rsMax,
      downSNRRecent,
      upSNRRecent,
      downSNRCount,
      downSNRSum,
      downSNRMin,
      downSNRMax,
      downSNRAvg,
      upSNRCount,
      upSNRSum,
      upSNRMin,
      upSNRMax,
      upSNRAvg,
      snrMin,
      snrMax,
      downATTNRecent,
      upATTNRecent,
      downATTNCount,
      downATTNSum,
      downATTNMin,
      downATTNMax,
      downATTNAvg,
      upATTNCount,
      upATTNSum,
      upATTNMin,
      upATTNMax,
      upATTNAvg,
      attnMin,
      attnMax,
    ];
  }

  @override
  String toString() {
    return 'RecentCounters( downFECRecent: $downFECRecent, downFECTotal: $downFECTotal, downFECLast: $downFECLast, upFECRecent: $upFECRecent, upFECTotal: $upFECTotal, upFECLast: $upFECLast, downCRCRecent: $downCRCRecent, downCRCTotal: $downCRCTotal, downCRCLast: $downCRCLast, upCRCRecent: $upCRCRecent, rsMax: $rsMax, downSNRRecent: $downSNRRecent, upSNRRecent: $upSNRRecent, downSNRCount: $downSNRCount, downSNRSum: $downSNRSum, downSNRMin: $downSNRMin, downSNRMax: $downSNRMax, downSNRAvg: $downSNRAvg, upSNRCount: $upSNRCount, upSNRSum: $upSNRSum, upSNRMin: $upSNRMin, upSNRMax: $upSNRMax, upSNRAvg: $upSNRAvg, snrMin: $snrMin, snrMax: $snrMax, downATTNRecent: $downATTNRecent, upATTNRecent: $upATTNRecent, downATTNCount: $downATTNCount, downATTNSum: $downATTNSum, downATTNMin: $downATTNMin, downATTNMax: $downATTNMax, downATTNAvg: $downATTNAvg, upATTNCount: $upATTNCount, upATTNSum: $upATTNSum, upATTNMin: $upATTNMin, upATTNMax: $upATTNMax, upATTNAvg: $upATTNAvg, attnMin: $attnMin, attnMax: $attnMax)';
  }

  // Without lists only length and last value
  String toStringMin() {
    return 'RecentCounters( downFECTotal: $downFECTotal, downFECLast: $downFECLast, upFECTotal: $upFECTotal, upFECLast: $upFECLast, downCRCTotal: $downCRCTotal, downCRCLast: $downCRCLast, upCRCTotal: $upCRCTotal, upCRCLast: $upCRCLast, rsMax: $rsMax, downSNRCount: $downSNRCount, downSNRMax: $downSNRMax, downSNRAvg: $downSNRAvg, upSNRCount: $upSNRCount, upSNRMax: $upSNRMax, upSNRAvg: $upSNRAvg, snrMin: $snrMin, snrMax: $snrMax, downATTNCount: $downATTNCount, downATTNMax: $downATTNMax, downATTNAvg: $downATTNAvg, upATTNCount: $upATTNCount, upATTNMax: $upATTNMax, upATTNAvg: $upATTNAvg, attnMin: $attnMin, attnMax: $attnMax)';
  }
}
