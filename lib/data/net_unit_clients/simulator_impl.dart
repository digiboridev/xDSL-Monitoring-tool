// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'package:xdsl_mt/data/models/line_stats.dart';
import 'package:xdsl_mt/data/net_unit_clients/net_unit_client.dart';

final class ClientSimulator extends NetUnitClient {
  ClientSimulator({required super.session}) : super(ip: '_', login: '_', password: '_');

  // Base line values
  final double _bmrU = 10;
  final double _bmrD = 10;
  final double _battU = 40;
  final double _battD = 40;

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
      return LineStats.errored(session: session, statusText: 'Connection failed');
    }

    // 1% chance of connection down
    if (_rndChance <= 1) {
      _reduceStatsHalfway();
      return LineStats.connectionDown(session: session, statusText: 'Down');
    }

    // 5% chance of donwstream stats drift
    if (_rndChance <= 5) {
      int rndDrift = Random().nextInt(100);

      _mrD = ((_mrD + (rndDrift - 50) / 100) * 100).round() / 100;
      _attD = ((_attD + (rndDrift - 50) / 100) * 100).round() / 100;
      _fecD = _fecD + rndDrift * 20;
      _crcD = _crcD + rndDrift * 9;
    }

    // 5% chance of upstream stats drift
    if (_rndChance <= 5) {
      int rndDrift = Random().nextInt(100);

      _mrU = ((_mrU + (rndDrift - 50) / 100) * 100).round() / 100;
      _attU = ((_attU + (rndDrift - 50) / 100) * 100).round() / 100;
      _fecU = _fecU + rndDrift * 13;
      _crcU = _crcU + rndDrift * 6;
    }

    return LineStats.connectionUp(
      session: session,
      statusText: 'Up',
      connectionType: 'ADSL2+',
      // upMaxRate: 2000,
      upMaxRate: Random().nextInt(2000),
      // downMaxRate: 19000,
      downMaxRate: Random().nextInt(19000),
      // upRate: 1898,
      upRate: Random().nextInt(1898),
      // downRate: 17809,
      downRate: Random().nextInt(17809),
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
