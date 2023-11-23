// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/raw_line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';

/// This class represents a client simulator for a network unit.
/// It extends the [NetUnitClient] class and overrides the [fetchStats] method to simulate network stats.
/// The class contains base speed rates, base line values, current speed rates, current line stats, and current error counters.
/// It also has a method to reduce stats to half of the current value, like if the line has impulse drops.
/// The [fetchStats] method simulates the network stats by introducing chances of fetch failure, connection down, downstream stats drift, and upstream stats drift.
/// It returns a [LineStats] object with the simulated stats.
final class SimulatorClientImpl implements NetUnitClient {
  final String protocol;
  SimulatorClientImpl({
    this.protocol = 'ADSL2+',
    int baseDownRate = 16000,
    int baseUpRate = 1500,
  })  : _bdownRate = baseDownRate,
        _bupRate = baseUpRate,
        _bdownAttainableRate = (baseDownRate * 1.2).toInt(),
        _bupAttainableRate = (baseUpRate * 1.2).toInt(),
        _bdownRateLimit = (baseDownRate * 1.5).toInt(),
        _bupRateLimit = (baseUpRate * 1.5).toInt();

  late final Random _rnd = Random();

  // Base speed rates
  final int _bupRate;
  final int _bdownRate;
  final int _bupAttainableRate;
  final int _bdownAttainableRate;
  final int _bupRateLimit;
  final int _bdownRateLimit;

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

  RawLineStats? _prevStats;

  // Reduce stats to half of the current value, like if the line has impulse drops
  _reduceStatsHalfway() {
    _upRate = (_upRate + _bupRate) ~/ 2;
    _downRate = (_downRate + _bdownRate) ~/ 2;
    _upAttainableRate = (_upAttainableRate + _bupAttainableRate) ~/ 2;
    _downAttainableRate = (_downAttainableRate + _bdownAttainableRate) ~/ 2;
    _mrU = (_mrU + _bmrU) / 2;
    _mrD = (_mrD + _bmrD) / 2;
    _attU = (_attU + _battU) / 2;
    _attD = (_attD + _battD) / 2;
    _fecU = 0;
    _fecD = 0;
    _crcU = 0;
    _crcD = 0;
  }

  int _rndSign(int max) => _rnd.nextInt(max * 2) - max;
  int _rndUnsign(int max) => _rnd.nextInt(max);

  @override
  Future<RawLineStats> fetchStats() async {
    await Future.delayed(Duration(milliseconds: _rndUnsign(1000)));

    // chance of connection recovery
    if (_prevStats?.status == SampleStatus.connectionDown && _rndUnsign(100) <= 90) {
      final newStats = RawLineStats.connectionDown(statusText: 'Initializing');
      _prevStats = newStats;
      return newStats;
    }

    // chance of fetch failure
    if (_rndUnsign(200) <= 1) {
      final newStats = RawLineStats.errored(statusText: 'Connection failed');
      _prevStats = newStats;
      return newStats;
    }

    // chance of connection down
    if (_rndUnsign(200) <= 1) {
      _reduceStatsHalfway();
      final newStats = RawLineStats.connectionDown(statusText: 'Down');
      _prevStats = newStats;
      return newStats;
    }

    // chance of stats drift
    if (_rndUnsign(100) <= 5) {
      int syncDrift = _rndSign(100); // needs to simulate same tendency to drift for all parameters

      // Downstream
      _downRate = (_downRate + ((syncDrift + _rndSign(100)) * 8)).clamp(2000, _bdownRateLimit);
      _downAttainableRate = (_downAttainableRate + ((syncDrift + _rndSign(100)) * 8)).clamp(3000, _bdownRateLimit);

      _mrD = (_mrD + ((syncDrift + _rndSign(100)) / 100)).clamp(2, 30);
      _attD = (_attD - ((syncDrift + _rndSign(100)) / 100)).clamp(2, 80);

      _fecD += (syncDrift + _rndSign(100)).abs();
      _crcD += (syncDrift + _rndSign(100)).abs();

      // Upstream
      _upRate = (_upRate + ((syncDrift + _rndSign(100)) * 2)).clamp(250, _bupRateLimit);
      _upAttainableRate = (_upAttainableRate + ((syncDrift + _rndSign(100)) * 2)).clamp(500, _bupRateLimit);

      _mrU = (_mrU + ((syncDrift + _rndSign(100)) / 100)).clamp(2, 30);
      _attU = (_attU - ((syncDrift + _rndSign(100)) / 100)).clamp(2, 80);

      _fecU += (syncDrift + _rndSign(100)).abs();
      _crcU += (syncDrift + _rndSign(100)).abs();
    }

    final nextStats = RawLineStats(
      statusText: 'Up',
      status: SampleStatus.connectionUp,
      connectionType: protocol,
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

    _prevStats = nextStats;
    return nextStats;
  }

  @override
  dispose() {}
}
