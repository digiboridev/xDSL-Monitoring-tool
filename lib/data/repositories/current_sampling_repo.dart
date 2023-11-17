import 'dart:async';
import 'dart:collection';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';

enum UpdateType { statusChanged, statsUpdated, statsWiped, fetchAttempt }

/// Repository for shared state of current line sampling
abstract class CurrentSamplingRepository {
  bool get samplingActive;
  SnapshotStats? get lastSnapshotStats;
  Iterable<LineStats> get lastLineStats;
  Duration get lastSamplingDuration;
  Stream<UpdateType> get updatesStream;

  void updateStats(LineStats lineStats, SnapshotStats snapshotStats, Duration samplingDuration);
  void updateStatus(bool samplingActive);
  void signalFetchAttempt();
  void wipeStats();
}

/// In-memory implementation of [CurrentSamplingRepository]
class CurrentSamplingRepositoryImpl implements CurrentSamplingRepository {
  final _controller = StreamController<UpdateType>.broadcast();
  final _lastLineStatsQueue = Queue<LineStats>();
  bool _samplingActive = false;
  SnapshotStats? _lastSnapshotStats;
  Duration _lastSamplingDuration = Duration.zero;

  @override
  bool get samplingActive => _samplingActive;
  @override
  SnapshotStats? get lastSnapshotStats => _lastSnapshotStats;
  @override
  Iterable<LineStats> get lastLineStats => _lastLineStatsQueue;
  @override
  Duration get lastSamplingDuration => _lastSamplingDuration;
  @override
  Stream<UpdateType> get updatesStream => _controller.stream;

  @override
  updateStats(LineStats lineStats, SnapshotStats snapshotStats, Duration samplingDuration) {
    _lastSnapshotStats = snapshotStats;
    _lastSamplingDuration = samplingDuration;
    _addLineStatsToQueue(lineStats);
    _controller.add(UpdateType.statsUpdated);
  }

  @override
  updateStatus(bool samplingActive) {
    _samplingActive = samplingActive;
    _controller.add(UpdateType.statusChanged);
  }

  @override
  signalFetchAttempt() {
    _controller.add(UpdateType.fetchAttempt);
  }

  @override
  wipeStats() {
    _lastSnapshotStats = null;
    _lastLineStatsQueue.clear();
    _controller.add(UpdateType.statsWiped);
  }

  _addLineStatsToQueue(LineStats lineStats) {
    _lastLineStatsQueue.addLast(lineStats);
    if (_lastLineStatsQueue.length > 500) _lastLineStatsQueue.removeFirst();
  }
}
