import 'package:xdsl_mt/data/models/app_settings.dart';

sealed class SettingsScreenState {
  SettingsScreenState();
  factory SettingsScreenState.loading() => SettingsScreenLoading();
  factory SettingsScreenState.loaded(AppSettings settings) => SettingsScreenLoaded(settings);
}

final class SettingsScreenLoading extends SettingsScreenState {}

final class SettingsScreenLoaded extends SettingsScreenState {
  final AppSettings settings;
  SettingsScreenLoaded(this.settings);

  @override
  bool operator ==(covariant SettingsScreenLoaded other) {
    if (identical(this, other)) return true;

    return other.settings == settings;
  }

  @override
  int get hashCode => settings.hashCode;

  @override
  String toString() => 'SettingsScreenLoaded(settings: $settings)';
}
