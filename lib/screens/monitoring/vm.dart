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

  _init() {
    _updatesSub = _currentSamplingRepository.updatesStream.listen((_) => notifyListeners());
    AppLogger.debug(name: 'MonitoringScreenViewModel', 'init complete');
  }

  @override
  void dispose() {
    _updatesSub.cancel();
    super.dispose();
  }

  SnapshotStats? get lastSnapshotStats => _currentSamplingRepository.lastSnapshotStats;
  Iterable<LineStats> get lastLineStats => _currentSamplingRepository.lastLineStats;
  bool get samplingActive => _currentSamplingRepository.samplingActive;
}
