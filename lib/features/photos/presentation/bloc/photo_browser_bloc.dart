import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import '../../domain/repositories/photo_repository.dart';
import '../../../data/repositories/recent_folders_repository.dart';
import 'photo_browser_event.dart';
import 'photo_browser_state.dart';

class PhotoBrowserBloc extends Bloc<PhotoBrowserEvent, PhotoBrowserState> {
  final PhotoRepository _photoRepository;
  final RecentFoldersRepository _recentFoldersRepository;

  PhotoBrowserBloc({
    required PhotoRepository photoRepository,
    required RecentFoldersRepository recentFoldersRepository,
  })  : _photoRepository = photoRepository,
        _recentFoldersRepository = recentFoldersRepository,
        super(PhotoBrowserState(
          currentPath: '/',
          pathHistory: ['/'],
          photos: [],
        )) {
    on<LoadDirectory>(_onLoadDirectory);
    on<NavigateBack>(_onNavigateBack);
    on<ToggleViewMode>(_onToggleViewMode);
    on<SelectPhoto>(_onSelectPhoto);
    on<ClearSelection>(_onClearSelection);
    on<RefreshCurrentDirectory>(_onRefreshCurrentDirectory);
  }

  Future<void> _onLoadDirectory(
    LoadDirectory event,
    Emitter<PhotoBrowserState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final photos = await _photoRepository.getPhotosInDirectory(
        event.path,
        recursive: event.recursive,
      );

      // Update recent folders
      await _recentFoldersRepository.addRecentFolder(event.path);

      // Update path history
      List<String> newHistory = List.from(state.pathHistory);
      if (event.path != state.currentPath) {
        newHistory.add(event.path);
      }

      emit(state.copyWith(
        currentPath: event.path,
        pathHistory: newHistory,
        photos: photos,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onNavigateBack(
    NavigateBack event,
    Emitter<PhotoBrowserState> emit,
  ) async {
    if (state.pathHistory.length > 1) {
      final newHistory = List<String>.from(state.pathHistory)..removeLast();
      final previousPath = newHistory.last;

      add(LoadDirectory(path: previousPath));
    }
  }

  void _onToggleViewMode(
    ToggleViewMode event,
    Emitter<PhotoBrowserState> emit,
  ) {
    emit(state.copyWith(isGridView: !state.isGridView));
  }

  void _onSelectPhoto(
    SelectPhoto event,
    Emitter<PhotoBrowserState> emit,
  ) {
    final newSelection = Set<String>.from(state.selectedPhotos);
    if (event.selected) {
      newSelection.add(event.path);
    } else {
      newSelection.remove(event.path);
    }

    emit(state.copyWith(selectedPhotos: newSelection));
  }

  void _onClearSelection(
    ClearSelection event,
    Emitter<PhotoBrowserState> emit,
  ) {
    emit(state.copyWith(selectedPhotos: {}));
  }

  Future<void> _onRefreshCurrentDirectory(
    RefreshCurrentDirectory event,
    Emitter<PhotoBrowserState> emit,
  ) async {
    add(LoadDirectory(path: state.currentPath));
  }
}
