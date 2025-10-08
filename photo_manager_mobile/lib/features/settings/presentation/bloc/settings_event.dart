import 'package:equatable/equatable.dart';
import '../../domain/models/app_settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateSettings extends SettingsEvent {
  final AppSettings settings;

  const UpdateSettings(this.settings);

  @override
  List<Object> get props => [settings];
}

class ToggleDuplicateDetection extends SettingsEvent {
  final bool enable;

  const ToggleDuplicateDetection(this.enable);

  @override
  List<Object> get props => [enable];
}

class ToggleExifData extends SettingsEvent {
  final bool enable;

  const ToggleExifData(this.enable);

  @override
  List<Object> get props => [enable];
}

class UpdateMaxRecentFolders extends SettingsEvent {
  final int count;

  const UpdateMaxRecentFolders(this.count);

  @override
  List<Object> get props => [count];
}

class ToggleDarkMode extends SettingsEvent {
  final bool enable;

  const ToggleDarkMode(this.enable);

  @override
  List<Object> get props => [enable];
}

class UpdateDefaultSortOrder extends SettingsEvent {
  final String sortOrder;

  const UpdateDefaultSortOrder(this.sortOrder);

  @override
  List<Object> get props => [sortOrder];
}

class ToggleShowHiddenFiles extends SettingsEvent {
  final bool enable;

  const ToggleShowHiddenFiles(this.enable);

  @override
  List<Object> get props => [enable];
}
