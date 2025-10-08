import 'package:equatable/equatable.dart';

abstract class DuplicateDetectionEvent extends Equatable {
  const DuplicateDetectionEvent();

  @override
  List<Object> get props => [];
}

class ScanForDuplicates extends DuplicateDetectionEvent {
  final String directoryPath;
  final bool recursive;

  const ScanForDuplicates({
    required this.directoryPath,
    this.recursive = true,
  });

  @override
  List<Object> get props => [directoryPath, recursive];
}

class ScanMultipleDirectories extends DuplicateDetectionEvent {
  final List<String> directoryPaths;

  const ScanMultipleDirectories({
    required this.directoryPaths,
  });

  @override
  List<Object> get props => [directoryPaths];
}

class SelectPhoto extends DuplicateDetectionEvent {
  final String path;
  final bool selected;

  const SelectPhoto({
    required this.path,
    required this.selected,
  });

  @override
  List<Object> get props => [path, selected];
}

class SelectSmallestInGroup extends DuplicateDetectionEvent {
  final int groupIndex;

  const SelectSmallestInGroup(this.groupIndex);

  @override
  List<Object> get props => [groupIndex];
}

class SelectLargestInGroup extends DuplicateDetectionEvent {
  final int groupIndex;

  const SelectLargestInGroup(this.groupIndex);

  @override
  List<Object> get props => [groupIndex];
}

class ToggleGroupExpansion extends DuplicateDetectionEvent {
  final int? groupIndex;

  const ToggleGroupExpansion(this.groupIndex);

  @override
  List<Object?> get props => [groupIndex];
}

class ClearSelection extends DuplicateDetectionEvent {}

class SelectAllInGroup extends DuplicateDetectionEvent {
  final int groupIndex;

  const SelectAllInGroup(this.groupIndex);

  @override
  List<Object> get props => [groupIndex];
}

class SelectNewestInGroup extends DuplicateDetectionEvent {
  final int groupIndex;

  const SelectNewestInGroup(this.groupIndex);

  @override
  List<Object> get props => [groupIndex];
}

class SelectOldestInGroup extends DuplicateDetectionEvent {
  final int groupIndex;

  const SelectOldestInGroup(this.groupIndex);

  @override
  List<Object> get props => [groupIndex];
}

class BatchDeleteSelected extends DuplicateDetectionEvent {}
