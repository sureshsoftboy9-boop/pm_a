import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager_mobile/features/photos/domain/repositories/recent_folders_repository.dart';
import 'recent_folders_event.dart';
import 'recent_folders_state.dart';

class RecentFoldersBloc extends Bloc<RecentFoldersEvent, RecentFoldersState> {
  final RecentFoldersRepository repository;

  RecentFoldersBloc({required this.repository}) : super(RecentFoldersState()) {
    on<LoadRecentFolders>(_onLoadRecentFolders);
    on<AddRecentFolder>(_onAddRecentFolder);
    on<RemoveRecentFolder>(_onRemoveRecentFolder);
  }

  Future<void> _onLoadRecentFolders(
    LoadRecentFolders event,
    Emitter<RecentFoldersState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final folders = await repository.getRecentFolders();
      emit(state.copyWith(
        recentFolders: folders,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onAddRecentFolder(
    AddRecentFolder event,
    Emitter<RecentFoldersState> emit,
  ) async {
    try {
      await repository.addRecentFolder(event.path);
      final folders = await repository.getRecentFolders();
      emit(state.copyWith(recentFolders: folders));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onRemoveRecentFolder(
    RemoveRecentFolder event,
    Emitter<RecentFoldersState> emit,
  ) async {
    try {
      await repository.removeRecentFolder(event.path);
      final folders = await repository.getRecentFolders();
      emit(state.copyWith(recentFolders: folders));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
