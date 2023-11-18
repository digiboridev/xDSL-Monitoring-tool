import 'dart:async';
// import 'dart:collection';
import 'package:xdslmt/data/models/line_stats.dart';
import 'package:xdslmt/data/models/recent_counters.dart';
import 'package:xdslmt/data/models/snapshot_stats.dart';

@Deprecated('new stream is used instead')
enum UpdateType { statusChanged, statsUpdated, statsWiped, fetchAttempt }

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
  Duration get lastSamplingDuration;

  @Deprecated('new stream is used instead')
  Stream<UpdateType> get updatesStream;

  Stream<CurrentSamplingEvent> get eventBus;

  @Deprecated('new stream is used instead')
  void updateStats(LineStats lineStats, SnapshotStats snapshotStats, RecentCounters recentCounters, Duration samplingDuration);
  void updateStatus(bool samplingActive);
  @Deprecated('new stream is used instead')
  void signalFetchAttempt();
  void signalFetchPending(DateTime timestamp, Duration desiredDuration);
  void signalTemporizing(DateTime timestamp, Duration desiredDuration);
  void setLineStats(LineStats lineStats);
  void setSnapshotStats(SnapshotStats snapshotStats);
  void setRecentCounters(RecentCounters recentCounters);
  void submitEvent(CurrentSamplingEvent event);
  void wipeStats();
}

/// In-memory implementation of [CurrentSamplingRepository]
class CurrentSamplingRepositoryImpl implements CurrentSamplingRepository {
  final _controller = StreamController<UpdateType>.broadcast();
  final _eventBus = StreamController<CurrentSamplingEvent>.broadcast();
  bool _samplingActive = false;
  LineStats? _lastLineStats;
  SnapshotStats? _lastSnapshotStats;
  RecentCounters? _recentCounters;
  Duration _lastSamplingDuration = Duration.zero;

  @override
  bool get samplingActive => _samplingActive;
  @override
  LineStats? get lastLineStats => _lastLineStats;
  @override
  SnapshotStats? get lastSnapshotStats => _lastSnapshotStats;
  @override
  RecentCounters? get recentCounters => _recentCounters;
  @override
  Duration get lastSamplingDuration => _lastSamplingDuration;
  @override
  Stream<UpdateType> get updatesStream => _controller.stream;
  @override
  Stream<CurrentSamplingEvent> get eventBus => _eventBus.stream;

  @override
  updateStats(LineStats lineStats, SnapshotStats snapshotStats, RecentCounters recentCounters, Duration samplingDuration) {
    _lastLineStats = lineStats;
    _lastSnapshotStats = snapshotStats;
    _recentCounters = recentCounters;
    _lastSamplingDuration = samplingDuration;

    _controller.add(UpdateType.statsUpdated);
  }

  @override
  updateStatus(bool samplingActive) {
    _samplingActive = samplingActive;
    _controller.add(UpdateType.statusChanged);
    _eventBus.add(StatusChanged(samplingActive));
  }

  @override
  signalFetchAttempt() {
    _controller.add(UpdateType.fetchAttempt);
  }

  @override
  signalFetchPending(DateTime timestamp, Duration desiredDuration) {
    _eventBus.add(FetchPending(timestamp, desiredDuration));
  }

  @override
  signalTemporizing(DateTime timestamp, Duration desiredDuration) {
    _eventBus.add(Temporizing(timestamp, desiredDuration));
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
    _lastSamplingDuration = Duration.zero;
    _controller.add(UpdateType.statsWiped);
  }

  @override
  void submitEvent(CurrentSamplingEvent event) {
    _eventBus.add(event);
    switch (event) {
      case StatusChanged():
        _samplingActive = event.samplingActive;
        _controller.add(UpdateType.statusChanged);
      case FetchPending():
        _controller.add(UpdateType.fetchAttempt);
      case Temporizing():
        ;
      case LineStatsArived():
        _lastLineStats = event.lineStats;
        _controller.add(UpdateType.statsUpdated);
      case SnapshotStatsArived():
        _lastSnapshotStats = event.snapshotStats;
        _controller.add(UpdateType.statsUpdated);
      case RecentCountersArived():
        _recentCounters = event.recentCounters;
        _controller.add(UpdateType.statsUpdated);
    }
  }
}
