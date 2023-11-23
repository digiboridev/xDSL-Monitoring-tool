import 'package:equatable/equatable.dart';
import 'package:xdslmt/data/models/app_settings.dart';

sealed class SettingsScreenState {
  SettingsScreenState();
  factory SettingsScreenState.loading() => SettingsScreenLoading();
  factory SettingsScreenState.loaded(AppSettings settings) => SettingsScreenLoaded(settings);
}

final class SettingsScreenLoading extends SettingsScreenState {}

final class SettingsScreenLoaded extends SettingsScreenState with EquatableMixin {
  final AppSettings settings;
  SettingsScreenLoaded(this.settings);

  @override
  List<Object> get props => [settings];

  @override
  bool get stringify => true;
}
