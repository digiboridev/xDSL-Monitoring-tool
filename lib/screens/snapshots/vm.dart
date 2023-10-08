import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:xdslmt/data/repositories/stats_repo.dart';
import 'package:xdslmt/screens/snapshots/state.dart';

class SnapshotsScreenViewModel extends ValueNotifier<SnapshotsScreenState> {
  final StatsRepository statsRepository;
  SnapshotsScreenViewModel(this.statsRepository) : super(SnapshotsScreenState.loading()) {
    _init();
  }

  _init() async {
    value = SnapshotsScreenState.loaded(await statsRepository.snapshotIds());
    log('SnapshotsScreenViewModel: _init()');
  }

  bool get vmReady => value is SnapshotsScreenLoaded;
  List<String> get snapshots => (value as SnapshotsScreenLoaded).snapshots;
}
