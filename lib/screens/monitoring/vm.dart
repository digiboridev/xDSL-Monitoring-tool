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

  final List<int> _rsDownFec = [];
  final List<int> _rsUpFec = [];
  final List<int> _rsDownCrc = [];
  final List<int> _rsUpCrc = [];
  int _rsMax = 1000;

  _init() {
    _updateRSCounters(_currentSamplingRepository.lastLineStats);

    _updatesSub = _currentSamplingRepository.updatesStream.listen((_) {
      _updateRSCounters(_currentSamplingRepository.lastLineStats);
      notifyListeners();
    });
    AppLogger.debug(name: 'MonitoringScreenViewModel', 'init complete');
  }

  @override
  void dispose() {
    _updatesSub.cancel();
    super.dispose();
  }

  _updateRSCounters(Iterable<LineStats> lineStats) {
    _rsDownFec.clear();
    _rsUpFec.clear();
    _rsDownCrc.clear();
    _rsUpCrc.clear();
    _rsMax = 1;

    for (final s in lineStats) {
      final downFECIncr = s.downFECIncr ?? 0;
      if (downFECIncr > _rsMax) _rsMax = downFECIncr;
      _rsDownFec.add(downFECIncr);

      final upFECIncr = s.upFECIncr ?? 0;
      if (upFECIncr > _rsMax) _rsMax = upFECIncr;
      _rsUpFec.add(upFECIncr);

      final downCRCIncr = s.downCRCIncr ?? 0;
      if (downCRCIncr > _rsMax) _rsMax = downCRCIncr;
      _rsDownCrc.add(downCRCIncr);

      final upCRCIncr = s.upCRCIncr ?? 0;
      if (upCRCIncr > _rsMax) _rsMax = upCRCIncr;
      _rsUpCrc.add(upCRCIncr);
    }

    if (_rsDownFec.length < 200) _rsDownFec.insertAll(0, List.filled(200 - _rsDownFec.length, 0));
    if (_rsUpFec.length < 200) _rsUpFec.insertAll(0, List.filled(200 - _rsUpFec.length, 0));
    if (_rsDownCrc.length < 200) _rsDownCrc.insertAll(0, List.filled(200 - _rsDownCrc.length, 0));
    if (_rsUpCrc.length < 200) _rsUpCrc.insertAll(0, List.filled(200 - _rsUpCrc.length, 0));
  }

  SnapshotStats? get lastSnapshotStats => _currentSamplingRepository.lastSnapshotStats;
  Iterable<LineStats> get lastLineStats => _currentSamplingRepository.lastLineStats;
  bool get samplingActive => _currentSamplingRepository.samplingActive;

  List<int> get rsDownFec => _rsDownFec;
  List<int> get rsUpFec => _rsUpFec;
  List<int> get rsDownCrc => _rsDownCrc;
  List<int> get rsUpCrc => _rsUpCrc;
  int get rsMax => _rsMax;
}
