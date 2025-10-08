import 'package:equatable/equatable.dart';
import '../../domain/models/duplicate_group.dart';

enum DuplicateDetectionStatus {
  initial,
  scanning,
  complete,
  error,
}

class DuplicateDetectionState extends Equatable {
  final DuplicateDetectionStatus status;
  final List<DuplicateGroup> duplicateGroups;
  final double progress;
  final String? error;
  final Set<String> selectedPhotos;
  final int? expandedGroupIndex;

  const DuplicateDetectionState({
    this.status = DuplicateDetectionStatus.initial,
    this.duplicateGroups = const [],
    this.progress = 0.0,
    this.error,
    this.selectedPhotos = const {},
    this.expandedGroupIndex,
  });

  int get totalDuplicates =>
      duplicateGroups.fold(0, (sum, group) => sum + group.duplicateCount);

  int get totalWastedSpace =>
      duplicateGroups.fold(0, (sum, group) => sum + group.wastedSpace);

  DuplicateDetectionState copyWith({
    DuplicateDetectionStatus? status,
    List<DuplicateGroup>? duplicateGroups,
    double? progress,
    String? error,
    Set<String>? selectedPhotos,
    int? expandedGroupIndex,
  }) {
    return DuplicateDetectionState(
      status: status ?? this.status,
      duplicateGroups: duplicateGroups ?? this.duplicateGroups,
      progress: progress ?? this.progress,
      error: error,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      expandedGroupIndex: expandedGroupIndex,
    );
  }

  @override
  List<Object?> get props => [
        status,
        duplicateGroups,
        progress,
        error,
        selectedPhotos,
        expandedGroupIndex,
      ];
}
