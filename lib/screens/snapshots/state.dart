import 'package:equatable/equatable.dart';

sealed class SnapshotsScreenState {
  SnapshotsScreenState();
  factory SnapshotsScreenState.loading() => SnapshotsScreenLoading();
  factory SnapshotsScreenState.loaded(List<String> snapshots) => SnapshotsScreenLoaded(snapshots);
}

final class SnapshotsScreenLoading extends SnapshotsScreenState {}

final class SnapshotsScreenLoaded extends SnapshotsScreenState with EquatableMixin {
  final List<String> snapshots;
  SnapshotsScreenLoaded(this.snapshots);

  @override
  List<Object> get props => [snapshots];

  @override
  bool get stringify => true;
}
