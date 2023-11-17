import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';
import 'package:xdslmt/data/repositories/current_sampling_repo.dart';

class MonitoringScreenViewModel extends ChangeNotifier {
  final CurrentSamplingRepository currentSamplingRepository;
  MonitoringScreenViewModel(this.currentSamplingRepository) {
    _init();
  }

  late StreamSubscription _updatesSub;

  _init() {
    _updatesSub = currentSamplingRepository.updatesStream.listen((_) => notifyListeners());
    AppLogger.debug(name: 'MonitoringScreenViewModel', 'init complete');
  }

  @override
  void dispose() {
    _updatesSub.cancel();
    super.dispose();
  }

  SnapshotStats? get snapshotStats => currentSamplingRepository.lastSnapshotStats;
  Iterable<LineStats> get lastSamples => currentSamplingRepository.lastLineStats;
  bool get samplingActive => currentSamplingRepository.samplingActive;
}
