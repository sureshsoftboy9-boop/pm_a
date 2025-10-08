import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/duplicate_detection_service.dart';
import 'duplicate_detection_event.dart';
import 'duplicate_detection_state.dart';

class DuplicateDetectionBloc
    extends Bloc<DuplicateDetectionEvent, DuplicateDetectionState> {
  final DuplicateDetectionService _duplicateDetectionService;

  DuplicateDetectionBloc({
    required DuplicateDetectionService duplicateDetectionService,
  })  : _duplicateDetectionService = duplicateDetectionService,
        super(const DuplicateDetectionState()) {
    on<ScanForDuplicates>(_onScanForDuplicates);
    on<ScanMultipleDirectories>(_onScanMultipleDirectories);
    on<SelectPhoto>(_onSelectPhoto);
    on<SelectSmallestInGroup>(_onSelectSmallestInGroup);
    on<SelectLargestInGroup>(_onSelectLargestInGroup);
    on<ToggleGroupExpansion>(_onToggleGroupExpansion);
    on<ClearSelection>(_onClearSelection);
  }

  Future<void> _onScanForDuplicates(
    ScanForDuplicates event,
    Emitter<DuplicateDetectionState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: DuplicateDetectionStatus.scanning,
        progress: 0.0,
      ));

      final duplicates = await _duplicateDetectionService.findDuplicates(
        event.directoryPath,
      );

      emit(state.copyWith(
        status: DuplicateDetectionStatus.complete,
        duplicateGroups: duplicates,
        progress: 1.0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DuplicateDetectionStatus.error,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onScanMultipleDirectories(
    ScanMultipleDirectories event,
    Emitter<DuplicateDetectionState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: DuplicateDetectionStatus.scanning,
        progress: 0.0,
      ));

      final duplicates = await _duplicateDetectionService.findDuplicatesInGroups(
        event.directoryPaths,
      );

      emit(state.copyWith(
        status: DuplicateDetectionStatus.complete,
        duplicateGroups: duplicates,
        progress: 1.0,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: DuplicateDetectionStatus.error,
        error: e.toString(),
      ));
    }
  }

  void _onSelectPhoto(
    SelectPhoto event,
    Emitter<DuplicateDetectionState> emit,
  ) {
    final newSelection = Set<String>.from(state.selectedPhotos);
    if (event.selected) {
      newSelection.add(event.path);
    } else {
      newSelection.remove(event.path);
    }

    emit(state.copyWith(selectedPhotos: newSelection));
  }

  void _onSelectSmallestInGroup(
    SelectSmallestInGroup event,
    Emitter<DuplicateDetectionState> emit,
  ) {
    if (event.groupIndex >= state.duplicateGroups.length) return;

    final group = state.duplicateGroups[event.groupIndex];
    final smallestPhoto = group.smallestPhoto;
    final otherPhotos =
        group.photos.where((p) => p.path != smallestPhoto.path);

    final newSelection = Set<String>.from(state.selectedPhotos);
    for (final photo in otherPhotos) {
      newSelection.add(photo.path);
    }

    emit(state.copyWith(selectedPhotos: newSelection));
  }

  void _onSelectLargestInGroup(
    SelectLargestInGroup event,
    Emitter<DuplicateDetectionState> emit,
  ) {
    if (event.groupIndex >= state.duplicateGroups.length) return;

    final group = state.duplicateGroups[event.groupIndex];
    final largestPhoto = group.largestPhoto;
    final otherPhotos =
        group.photos.where((p) => p.path != largestPhoto.path);

    final newSelection = Set<String>.from(state.selectedPhotos);
    for (final photo in otherPhotos) {
      newSelection.add(photo.path);
    }

    emit(state.copyWith(selectedPhotos: newSelection));
  }

  void _onToggleGroupExpansion(
    ToggleGroupExpansion event,
    Emitter<DuplicateDetectionState> emit,
  ) {
    emit(state.copyWith(
      expandedGroupIndex:
          state.expandedGroupIndex == event.groupIndex ? null : event.groupIndex,
    ));
  }

  void _onClearSelection(
    ClearSelection event,
    Emitter<DuplicateDetectionState> emit,
  ) {
    emit(state.copyWith(selectedPhotos: {}));
  }
}
