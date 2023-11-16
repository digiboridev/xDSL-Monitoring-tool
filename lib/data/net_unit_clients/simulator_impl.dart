// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';

/// This class represents a client simulator for a network unit.
/// It extends the [NetUnitClient] class and overrides the [fetchStats] method to simulate network stats.
/// The class contains base speed rates, base line values, current speed rates, current line stats, and current error counters.
/// It also has a method to reduce stats to half of the current value, like if the line has impulse drops.
/// The [fetchStats] method simulates the network stats by introducing chances of fetch failure, connection down, downstream stats drift, and upstream stats drift.
/// It returns a [LineStats] object with the simulated stats.
final class SimulatorClientImpl implements NetUnitClient {
  @override
  final String snapshotId;
  final String protocol;
  SimulatorClientImpl({
    required this.snapshotId,
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

  LineStats? _prevStats;

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

  int get _rndChance => _rnd.nextInt(100);

  int _incrDiff(int? prev, int? next) {
    prev ??= 0;
    if (next == null) return 0;
    final diff = next - prev;
    return diff > 0 ? diff : 0;
  }

  @override
  Future<LineStats> fetchStats() async {
    await Future.delayed(Duration(milliseconds: _rnd.nextInt(1000)));

    // chance of connection recovery
    if (_prevStats?.status == SampleStatus.connectionDown && _rndChance <= 90) {
      final newStats = LineStats.connectionDown(snapshotId: snapshotId, statusText: 'Initializing');
      _prevStats = newStats;
      return newStats;
    }

    // chance of fetch failure
    if (_rndChance <= 1) {
      final newStats = LineStats.errored(snapshotId: snapshotId, statusText: 'Connection failed');
      _prevStats = newStats;
      return newStats;
    }

    // chance of connection down
    if (_rndChance <= 1) {
      _reduceStatsHalfway();
      final newStats = LineStats.connectionDown(snapshotId: snapshotId, statusText: 'Down');
      _prevStats = newStats;
      return newStats;
    }

    // common stats drift
    // to simulate an ustable but sincronized stats drift
    int sigDrift = _rnd.nextInt(200) - 100;
    int unsigDrift = sigDrift.abs();

    // chance of donwstream stats drift
    if (_rndChance <= 10) {
      _downRate = (_downRate + ((sigDrift + _rnd.nextInt(50)) * 10)).clamp(2000, _bdownRateLimit);
      _downAttainableRate = (_downAttainableRate + ((sigDrift + _rnd.nextInt(50)) * 10)).clamp(3000, _bdownRateLimit);

      _mrD = (_mrD + ((sigDrift + _rnd.nextInt(100)) / 100)).clamp(0, 30);
      _attD = (_attD + ((sigDrift + _rnd.nextInt(100)) / 100)).clamp(0, 100);
      _fecD += (unsigDrift + _rnd.nextInt(50).abs()) * 8;
      _crcD += (unsigDrift + _rnd.nextInt(50).abs()) * 4;
    }

    // chance of upstream stats drift
    if (_rndChance <= 10) {
      _upRate = (_upRate + ((sigDrift + _rnd.nextInt(50)) * 5)).clamp(250, _bupRateLimit);
      _upAttainableRate = (_upAttainableRate + ((sigDrift + _rnd.nextInt(50)) * 5)).clamp(500, _bupRateLimit);

      _mrU = (_mrU + ((sigDrift + _rnd.nextInt(100)) / 100)).clamp(0, 30);
      _attU = (_attU + ((sigDrift + _rnd.nextInt(100)) / 100)).clamp(0, 100);
      _fecU += (unsigDrift + _rnd.nextInt(50).abs()) * 4;
      _crcU += (unsigDrift + _rnd.nextInt(50).abs()) * 2;
    }

    final nextStats = LineStats.connectionUp(
      snapshotId: snapshotId,
      statusText: 'Up',
      connectionType: protocol,
      upAttainableRate: _upAttainableRate,
      downAttainableRate: _downAttainableRate,
      upRate: _upRate,
      downRate: _downRate,
      upMargin: (_mrU * 10).truncate(),
      downMargin: (_mrD * 10).truncate(),
      upAttenuation: (_attU * 10).truncate(),
      downAttenuation: (_attD * 10).truncate(),
      upCRC: _crcU,
      downCRC: _crcD,
      upFEC: _fecU,
      downFEC: _fecD,
      upCRCIncr: _incrDiff(_prevStats?.upCRC, _crcU),
      downCRCIncr: _incrDiff(_prevStats?.downCRC, _crcD),
      upFECIncr: _incrDiff(_prevStats?.upFEC, _fecU),
      downFECIncr: _incrDiff(_prevStats?.downFEC, _fecD),
    );

    _prevStats = nextStats;
    return nextStats;
  }

  @override
  dispose() {}
}
