import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:xdslmt/data/repositories/line_stats_repo.dart';
import 'package:xdslmt/screens/snapshots/state.dart';

class SnapshotsScreenViewModel extends ValueNotifier<SnapshotsScreenState> {
  final LineStatsRepository lineStatsRepository;
  SnapshotsScreenViewModel(this.lineStatsRepository) : super(SnapshotsScreenState.loading()) {
    _init();
  }

  _init() async {
    value = SnapshotsScreenState.loaded(await lineStatsRepository.getSessions());
    log('SnapshotsScreenViewModel: _init()');
  }

  bool get vmReady => value is SnapshotsScreenLoaded;
  List<String> get snapshots => (value as SnapshotsScreenLoaded).snapshots;
}
