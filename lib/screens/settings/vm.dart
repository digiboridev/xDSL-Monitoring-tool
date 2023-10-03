// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xdsl_mt/data/model/app_settings.dart';
import 'package:xdsl_mt/data/model/nu_parsers.dart';
import 'package:xdsl_mt/data/repository/settings_repo.dart';
import 'package:xdsl_mt/screens/settings/state.dart';
import 'package:xdsl_mt/utils/streambang.dart';

class SettingsScreenViewModel extends ValueNotifier<SettingsScreenState> with StreamBang {
  final SettingsRepository settingsRepository;

  SettingsScreenViewModel({required this.settingsRepository}) : super(SettingsScreenState.loading()) {
    _init();
  }

  _init() async {
    value = SettingsScreenState.loaded(await settingsRepository.getSettings);
    var sub = settingsRepository.updatesStream.listen((update) => value = SettingsScreenState.loaded(update));
    insert(sub);
  }

  Future<void> _setSettings(AppSettings settings) => settingsRepository.setSettings(settings);

  /// Explicit state getter, to avoid repetitive cast under the main state guard
  /// Be careful and use it only deeper than state guard, otherwise it will throw
  AppSettings get _expSettings => (value as SettingsScreenLoaded).settings;

  bool get vmReady => value is SettingsScreenLoaded;

  NUParsers get nuParser => _expSettings.nuParser;
  String get host => _expSettings.host;
  String get login => _expSettings.login;
  String get pwd => _expSettings.pwd;
  Duration get samplingInterval => _expSettings.samplingInterval;
  Duration get splitInterval => _expSettings.splitInterval;
  String get externalHost => _expSettings.externalHost;
  bool get animations => _expSettings.animations;
  bool get orientLock => _expSettings.orientLock;

  set setNuParser(NUParsers v) => _setSettings(_expSettings.copyWith(nuParser: v));
  set setHost(String v) => _setSettings(_expSettings.copyWith(host: v));
  set setLogin(String v) => _setSettings(_expSettings.copyWith(login: v));
  set setPwd(String v) => _setSettings(_expSettings.copyWith(pwd: v));
  set setSamplingInterval(Duration v) => _setSettings(_expSettings.copyWith(samplingInterval: v));
  set setSplitInterval(Duration v) => _setSettings(_expSettings.copyWith(splitInterval: v));
  set setExternalHost(String v) => _setSettings(_expSettings.copyWith(externalHost: v));
  set setAnimations(bool v) => _setSettings(_expSettings.copyWith(animations: v));
  set setOrientLock(bool v) => _setSettings(_expSettings.copyWith(orientLock: v));

  @override
  void dispose() {
    super.dispose();
    canshot();
  }
}
