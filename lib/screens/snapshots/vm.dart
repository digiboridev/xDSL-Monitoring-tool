import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/screens/snapshots/state.dart';

class SnapshotsScreenViewModel extends ValueNotifier<SnapshotsScreenState> {
  final StatsRepository statsRepository;
  SnapshotsScreenViewModel(this.statsRepository) : super(SnapshotsScreenState.loading()) {
    _init();
  }

  _init() async {
    value = SnapshotsScreenState.loaded(await statsRepository.snapshotIds());
    Logger.root.fine('SnapshotsScreenViewModel: init complete');
  }

  refresh() async {
    value = SnapshotsScreenState.loaded(await statsRepository.snapshotIds());
    Logger.root.fine('SnapshotsScreenViewModel: refresh complete');
  }

  bool get vmReady => value is SnapshotsScreenLoaded;
  List<String> get snapshots => vmReady ? (value as SnapshotsScreenLoaded).snapshots : [];
}
