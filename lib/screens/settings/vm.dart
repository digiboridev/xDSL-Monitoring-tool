// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xdslmt/core/app_logger.dart';
import 'package:xdslmt/data/models/app_settings.dart';
import 'package:xdslmt/data/net_unit_clients/net_unit_client.dart';
import 'package:xdslmt/data/repositories/settings_repo.dart';
import 'package:xdslmt/screens/settings/state.dart';
import 'package:xdslmt/utils/streambang.dart';

class SettingsScreenViewModel extends ValueNotifier<SettingsScreenState> with StreamBang {
  final SettingsRepository _settingsRepository;

  SettingsScreenViewModel(this._settingsRepository) : super(SettingsScreenState.loading()) {
    _init();
  }

  _init() async {
    value = SettingsScreenState.loaded(await _settingsRepository.getSettings);
    AppLogger.debug(name: 'SettingsScreenViewModel', 'init complete');

    var sub = _settingsRepository.updatesStream.listen((update) => value = SettingsScreenState.loaded(update));
    insert(sub);
  }

  Future<void> _setSettings(AppSettings settings) {
    AppLogger.debug(name: 'SettingsScreenViewModel', 'setSettings: $settings');

    return _settingsRepository.setSettings(settings);
  }

  /// Explicit state getter, to avoid repetitive cast under the main state guard
  /// Be careful and use it only deeper than state guard, otherwise it will throw
  AppSettings get _expSettings => (value as SettingsScreenLoaded).settings;

  bool get vmReady => value is SettingsScreenLoaded;

  NetworkUnitType get nuType => _expSettings.nuType;
  String get host => _expSettings.host;
  String get login => _expSettings.login;
  String get pwd => _expSettings.pwd;
  Duration get samplingInterval => _expSettings.samplingInterval;
  Duration get splitInterval => _expSettings.splitInterval;
  bool get animations => _expSettings.animations;
  bool get orientLock => _expSettings.orientLock;
  bool get wakeLock => _expSettings.wakeLock;
  bool get foregroundService => _expSettings.foregroundService;

  set setNuType(NetworkUnitType v) => _setSettings(_expSettings.copyWith(nuType: v));
  set setHost(String v) => _setSettings(_expSettings.copyWith(host: v));
  set setLogin(String v) => _setSettings(_expSettings.copyWith(login: v));
  set setPwd(String v) => _setSettings(_expSettings.copyWith(pwd: v));
  set setSamplingInterval(Duration v) => _setSettings(_expSettings.copyWith(samplingInterval: v));
  set setSplitInterval(Duration v) => _setSettings(_expSettings.copyWith(splitInterval: v));
  set setAnimations(bool v) => _setSettings(_expSettings.copyWith(animations: v));
  set setOrientLock(bool v) => _setSettings(_expSettings.copyWith(orientLock: v));
  set setWakelock(bool v) => _setSettings(_expSettings.copyWith(wakeLock: v));
  set setForegroundService(bool v) => _setSettings(_expSettings.copyWith(foregroundService: v));

  @override
  void dispose() {
    super.dispose();
    canshot();
  }
}
