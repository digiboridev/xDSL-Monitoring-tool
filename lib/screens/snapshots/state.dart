import 'package:flutter/foundation.dart';

sealed class SnapshotsScreenState {
  SnapshotsScreenState();
  factory SnapshotsScreenState.loading() => SnapshotsScreenLoading();
  factory SnapshotsScreenState.loaded(List<String> snapshots) => SnapshotsScreenLoaded(snapshots);
}

final class SnapshotsScreenLoading extends SnapshotsScreenState {}

final class SnapshotsScreenLoaded extends SnapshotsScreenState {
  final List<String> snapshots;
  SnapshotsScreenLoaded(this.snapshots);

  @override
  bool operator ==(covariant SnapshotsScreenLoaded other) {
    if (identical(this, other)) return true;

    return listEquals(other.snapshots, snapshots);
  }

  @override
  int get hashCode => snapshots.hashCode;

  @override
  String toString() => 'SnapshotsScreenLoaded(snapshots: $snapshots)';
}
