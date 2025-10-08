import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({required this.repository}) : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSettings>(_onUpdateSettings);
    on<ToggleDuplicateDetection>(_onToggleDuplicateDetection);
    on<ToggleExifData>(_onToggleExifData);
    on<UpdateMaxRecentFolders>(_onUpdateMaxRecentFolders);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<UpdateDefaultSortOrder>(_onUpdateDefaultSortOrder);
    on<ToggleShowHiddenFiles>(_onToggleShowHiddenFiles);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final settings = await repository.loadSettings();
      emit(state.copyWith(
        settings: settings,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onUpdateSettings(
    UpdateSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await repository.saveSettings(event.settings);
      emit(state.copyWith(settings: event.settings));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onToggleDuplicateDetection(
    ToggleDuplicateDetection event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(
      enableDuplicateDetection: event.enable,
    );
    add(UpdateSettings(newSettings));
  }

  Future<void> _onToggleExifData(
    ToggleExifData event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(
      saveExifData: event.enable,
    );
    add(UpdateSettings(newSettings));
  }

  Future<void> _onUpdateMaxRecentFolders(
    UpdateMaxRecentFolders event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(
      maxRecentFolders: event.count,
    );
    add(UpdateSettings(newSettings));
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkMode event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(
      darkMode: event.enable,
    );
    add(UpdateSettings(newSettings));
  }

  Future<void> _onUpdateDefaultSortOrder(
    UpdateDefaultSortOrder event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(
      defaultSortOrder: event.sortOrder,
    );
    add(UpdateSettings(newSettings));
  }

  Future<void> _onToggleShowHiddenFiles(
    ToggleShowHiddenFiles event,
    Emitter<SettingsState> emit,
  ) async {
    final newSettings = state.settings.copyWith(
      showHiddenFiles: event.enable,
    );
    add(UpdateSettings(newSettings));
  }
}
