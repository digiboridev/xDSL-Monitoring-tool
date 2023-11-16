import 'dart:async';
import 'dart:collection';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';

/// Repository for shared state of current line sampling
abstract class CurrentSamplingRepository {
  bool get samplingActive;
  SnapshotStats? get lastSnapshotStats;
  Iterable<LineStats> get lastLineStats;
  Stream get updatesStream;

  void updateStats(LineStats lineStats, SnapshotStats snapshotStats);
  void wipeStats();
  void updateStatus(bool samplingActive);
}

/// In-memory implementation of [CurrentSamplingRepository]
class CurrentSamplingRepositoryImpl implements CurrentSamplingRepository {
  bool _samplingActive = false;
  SnapshotStats? _lastSnapshotStats;
  final _lastLineStatsQueue = Queue<LineStats>();
  final _controller = StreamController.broadcast();

  @override
  bool get samplingActive => _samplingActive;
  @override
  SnapshotStats? get lastSnapshotStats => _lastSnapshotStats;
  @override
  Iterable<LineStats> get lastLineStats => _lastLineStatsQueue;
  @override
  Stream get updatesStream => _controller.stream;

  @override
  updateStats(LineStats lineStats, SnapshotStats snapshotStats) {
    _lastSnapshotStats = snapshotStats;
    _addLineStatsToQueue(lineStats);
    _controller.add(null);
  }

  @override
  wipeStats() {
    _lastSnapshotStats = null;
    _lastLineStatsQueue.clear();
    _controller.add(null);
  }

  @override
  updateStatus(bool samplingActive) {
    _samplingActive = samplingActive;
    _controller.add(null);
  }

  _addLineStatsToQueue(LineStats lineStats) {
    _lastLineStatsQueue.addLast(lineStats);
    if (_lastLineStatsQueue.length > 500) _lastLineStatsQueue.removeFirst();
  }
}
