import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/repositories/current_sampling_repo.dart';

class MonitoringScreenViewModel extends ChangeNotifier {
  final CurrentSamplingRepository _currentSamplingRepository;
  MonitoringScreenViewModel(this._currentSamplingRepository) {
    _init();
  }

  late StreamSubscription _updatesSub;

  final List<int?> _rsDownFec = [];
  final List<int?> _rsUpFec = [];
  final List<int?> _rsDownCrc = [];
  final List<int?> _rsUpCrc = [];
  int _rsMax = 1000;

  final List<int?> _downMargin = [];
  final List<int?> _upMargin = [];
  int _marginMin = 0;
  int _marginMax = 10;

  final List<int?> _downAttenuation = [];
  final List<int?> _upAttenuation = [];
  int _attenuationMin = 0;
  int _attenuationMax = 10;

  _init() {
    _updateCounters(_currentSamplingRepository.lastLineStats);

    _updatesSub = _currentSamplingRepository.updatesStream.listen((_) {
      _updateCounters(_currentSamplingRepository.lastLineStats);
      notifyListeners();
    });

    AppLogger.debug(name: 'MonitoringScreenViewModel', 'init complete');
  }

  @override
  void dispose() {
    _updatesSub.cancel();
    super.dispose();
  }

  _updateCounters(Iterable<LineStats> lineStats) {
    _rsDownFec.clear();
    _rsUpFec.clear();
    _rsDownCrc.clear();
    _rsUpCrc.clear();
    _rsMax = 1;

    for (final s in lineStats) {
      final downFECIncr = s.downFECIncr;
      _rsDownFec.add(downFECIncr);
      if (downFECIncr != null && downFECIncr > _rsMax) _rsMax = downFECIncr;

      final upFECIncr = s.upFECIncr;
      _rsUpFec.add(upFECIncr);
      if (upFECIncr != null && upFECIncr > _rsMax) _rsMax = upFECIncr;

      final downCRCIncr = s.downCRCIncr;
      _rsDownCrc.add(downCRCIncr);
      if (downCRCIncr != null && downCRCIncr > _rsMax) _rsMax = downCRCIncr;

      final upCRCIncr = s.upCRCIncr;
      _rsUpCrc.add(upCRCIncr);
      if (upCRCIncr != null && upCRCIncr > _rsMax) _rsMax = upCRCIncr;
    }

    if (_rsDownFec.length < 200) _rsDownFec.insertAll(0, List.filled(200 - _rsDownFec.length, 0));
    if (_rsUpFec.length < 200) _rsUpFec.insertAll(0, List.filled(200 - _rsUpFec.length, 0));
    if (_rsDownCrc.length < 200) _rsDownCrc.insertAll(0, List.filled(200 - _rsDownCrc.length, 0));
    if (_rsUpCrc.length < 200) _rsUpCrc.insertAll(0, List.filled(200 - _rsUpCrc.length, 0));

    _downMargin.clear();
    _upMargin.clear();
    _downAttenuation.clear();
    _upAttenuation.clear();

    _marginMin = 99;
    _marginMax = 0;
    _attenuationMin = 99;
    _attenuationMax = 0;

    for (final s in lineStats) {
      final downMargin = s.downMargin;
      _downMargin.add(downMargin);
      if (downMargin != null) {
        if (downMargin < _marginMin) _marginMin = downMargin;
        if (downMargin > _marginMax) _marginMax = downMargin;
      }

      final upMargin = s.upMargin;
      _upMargin.add(upMargin);
      if (upMargin != null) {
        if (upMargin < _marginMin) _marginMin = upMargin;
        if (upMargin > _marginMax) _marginMax = upMargin;
      }

      final downAttenuation = s.downAttenuation;
      _downAttenuation.add(downAttenuation);
      if (downAttenuation != null) {
        if (downAttenuation < _attenuationMin) _attenuationMin = downAttenuation;
        if (downAttenuation > _attenuationMax) _attenuationMax = downAttenuation;
      }

      final upAttenuation = s.upAttenuation;
      _upAttenuation.add(upAttenuation);
      if (upAttenuation != null) {
        if (upAttenuation < _attenuationMin) _attenuationMin = upAttenuation;
        if (upAttenuation > _attenuationMax) _attenuationMax = upAttenuation;
      }
    }

    if (_downMargin.length < 200) _downMargin.insertAll(0, List.filled(200 - _downMargin.length, null));
    if (_upMargin.length < 200) _upMargin.insertAll(0, List.filled(200 - _upMargin.length, null));
    if (_downAttenuation.length < 200) _downAttenuation.insertAll(0, List.filled(200 - _downAttenuation.length, null));
    if (_upAttenuation.length < 200) _upAttenuation.insertAll(0, List.filled(200 - _upAttenuation.length, null));
  }

  SnapshotStats? get lastSnapshotStats => _currentSamplingRepository.lastSnapshotStats;
  Iterable<LineStats> get lastLineStats => _currentSamplingRepository.lastLineStats;
  bool get samplingActive => _currentSamplingRepository.samplingActive;

  List<int?> get rsDownFec => _rsDownFec;
  List<int?> get rsUpFec => _rsUpFec;
  List<int?> get rsDownCrc => _rsDownCrc;
  List<int?> get rsUpCrc => _rsUpCrc;
  int get rsMax => _rsMax;

  List<int?> get downMargins => _downMargin;
  List<int?> get upMargins => _upMargin;
  List<int?> get downAttenuations => _downAttenuation;
  List<int?> get upAttenuations => _upAttenuation;
  int get marginMin => _marginMin;
  int get marginMax => _marginMax;
  int get attenuationMin => _attenuationMin;
  int get attenuationMax => _attenuationMax;
}
