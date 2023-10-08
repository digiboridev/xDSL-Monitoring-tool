// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';

final class ClientSimulator extends NetUnitClient {
  ClientSimulator({required super.snapshotId}) : super(ip: '_', login: '_', password: '_');

  // Base speed rates
  final int _bupRate = 1500;
  final int _bdownRate = 16000;
  final int _bupAttainableRate = 2000;
  final int _bdownAttainableRate = 18000;

  // Base line values
  final double _bmrU = 10;
  final double _bmrD = 10;
  final double _battU = 40;
  final double _battD = 40;

  // Current speed rates
  late int _upRate = _bupRate;
  late int _downRate = _bdownRate;
  late int _upAttainableRate = _bupAttainableRate;
  late int _downAttainableRate = _bdownAttainableRate;

  // Current line stats
  late double _mrU = _bmrU;
  late double _mrD = _bmrD;
  late double _attU = _battU;
  late double _attD = _battD;

  //Current error counters
  late int _fecU = 0;
  late int _fecD = 0;
  late int _crcU = 0;
  late int _crcD = 0;

  // Reduce stats to half of the current value, like if the line has impulse drops
  _reduceStatsHalfway() {
    _mrU = (_mrU.abs() + _bmrU) / 2;
    _mrD = (_mrD.abs() + _bmrD) / 2;
    _attU = (_attU.abs() + _battU) / 2;
    _attD = (_attD.abs() + _battD) / 2;
    _fecU = 0;
    _fecD = 0;
    _crcU = 0;
    _crcD = 0;
  }

  int get _rndChance => Random().nextInt(100);

  @override
  Future<LineStats> fetchStats() async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(1000)));

    // 1% chance of fetch failure
    if (_rndChance <= 1) {
      return LineStats.errored(snapshotId: snapshotId, statusText: 'Connection failed');
    }

    // 1% chance of connection down
    if (_rndChance <= 1) {
      _reduceStatsHalfway();
      return LineStats.connectionDown(snapshotId: snapshotId, statusText: 'Down');
    }

    // 5% chance of donwstream stats drift
    if (_rndChance <= 5) {
      int sigDrift = Random().nextInt(200) - 100;
      int unsigDrift = sigDrift.abs();

      _downRate += sigDrift * 8;
      _downAttainableRate += sigDrift * 8;

      _mrD += sigDrift / 100;
      _attD += sigDrift / 100;
      _fecD += unsigDrift * 8;
      _crcD += unsigDrift * 4;

      // TODO max values limit
    }

    // 5% chance of upstream stats drift
    if (_rndChance <= 5) {
      int sigDrift = Random().nextInt(200) - 100;
      int unsigDrift = sigDrift.abs();

      _upRate += sigDrift * 2;
      _upAttainableRate += sigDrift * 2;

      _mrU += sigDrift / 100;
      _attU += sigDrift / 100;
      _fecU += unsigDrift * 4;
      _crcU += unsigDrift * 2;
    }

    return LineStats.connectionUp(
      snapshotId: snapshotId,
      statusText: 'Up',
      connectionType: 'ADSL2+',
      upAttainableRate: _upAttainableRate,
      downAttainableRate: _downAttainableRate,
      upRate: _upRate,
      downRate: _downRate,
      upMargin: _mrU,
      downMargin: _mrD,
      upAttenuation: _attU,
      downAttenuation: _attD,
      upCRC: _crcU,
      downCRC: _crcD,
      upFEC: _fecU,
      downFEC: _fecD,
    );
  }
}
