import 'dart:async';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/recent_counters.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';

sealed class CurrentSamplingEvent {
  CurrentSamplingEvent();
  factory CurrentSamplingEvent.statusChanged(bool samplingActive) = StatusChanged;
  factory CurrentSamplingEvent.fetchPending(DateTime timestamp, Duration desiredDuration) = FetchPending;
  factory CurrentSamplingEvent.temporizing(DateTime timestamp, Duration desiredDuration) = Temporizing;
  factory CurrentSamplingEvent.lineStatsArived(LineStats lineStats) = LineStatsArived;
  factory CurrentSamplingEvent.snapshotStatsArived(SnapshotStats snapshotStats) = SnapshotStatsArived;
  factory CurrentSamplingEvent.recentCountersArived(RecentCounters recentCounters) = RecentCountersArived;
}

final class StatusChanged extends CurrentSamplingEvent {
  final bool samplingActive;
  StatusChanged(this.samplingActive);
}

final class FetchPending extends CurrentSamplingEvent {
  final DateTime timestamp;
  final Duration desiredDuration;
  FetchPending(this.timestamp, this.desiredDuration);
}

final class Temporizing extends CurrentSamplingEvent {
  final DateTime timestamp;
  final Duration desiredDuration;
  Temporizing(this.timestamp, this.desiredDuration);
}

final class LineStatsArived extends CurrentSamplingEvent {
  final LineStats lineStats;
  LineStatsArived(this.lineStats);
}

final class SnapshotStatsArived extends CurrentSamplingEvent {
  final SnapshotStats snapshotStats;
  SnapshotStatsArived(this.snapshotStats);
}

final class RecentCountersArived extends CurrentSamplingEvent {
  final RecentCounters recentCounters;
  RecentCountersArived(this.recentCounters);
}

/// Repository for shared state of current line sampling
abstract class CurrentSamplingRepository {
  bool get samplingActive;
  SnapshotStats? get lastSnapshotStats;
  LineStats? get lastLineStats;
  RecentCounters? get recentCounters;
  Stream<CurrentSamplingEvent> get eventBus;

  void setStatus(bool samplingActive);
  void setLineStats(LineStats lineStats);
  void setSnapshotStats(SnapshotStats snapshotStats);
  void setRecentCounters(RecentCounters recentCounters);
  void submitEvent(CurrentSamplingEvent event);
  void wipeStats();
}

/// In-memory implementation of [CurrentSamplingRepository]
class CurrentSamplingRepositoryImpl implements CurrentSamplingRepository {
  final _eventBus = StreamController<CurrentSamplingEvent>.broadcast();
  bool _samplingActive = false;
  LineStats? _lastLineStats;
  SnapshotStats? _lastSnapshotStats;
  RecentCounters? _recentCounters;

  @override
  bool get samplingActive => _samplingActive;
  @override
  LineStats? get lastLineStats => _lastLineStats;
  @override
  SnapshotStats? get lastSnapshotStats => _lastSnapshotStats;
  @override
  RecentCounters? get recentCounters => _recentCounters;
  @override
  Stream<CurrentSamplingEvent> get eventBus => _eventBus.stream;

  @override
  setStatus(bool samplingActive) {
    _samplingActive = samplingActive;
    _eventBus.add(StatusChanged(samplingActive));
  }

  @override
  setLineStats(LineStats lineStats) {
    _lastLineStats = lineStats;
    _eventBus.add(LineStatsArived(lineStats));
  }

  @override
  setSnapshotStats(SnapshotStats snapshotStats) {
    _lastSnapshotStats = snapshotStats;
    _eventBus.add(SnapshotStatsArived(snapshotStats));
  }

  @override
  setRecentCounters(RecentCounters recentCounters) {
    _recentCounters = recentCounters;
    _eventBus.add(RecentCountersArived(recentCounters));
  }

  @override
  wipeStats() {
    _lastSnapshotStats = null;
    _lastLineStats = null;
    _recentCounters = null;
  }

  @override
  void submitEvent(CurrentSamplingEvent event) {
    switch (event) {
      case StatusChanged():
        _samplingActive = event.samplingActive;
        _eventBus.add(event);
      case FetchPending():
        _eventBus.add(event);
      case Temporizing():
        _eventBus.add(event);
      case LineStatsArived():
        _lastLineStats = event.lineStats;
        _eventBus.add(event);
      case SnapshotStatsArived():
        _lastSnapshotStats = event.snapshotStats;
        _eventBus.add(event);
      case RecentCountersArived():
        _recentCounters = event.recentCounters;
        _eventBus.add(event);
    }
  }
}
