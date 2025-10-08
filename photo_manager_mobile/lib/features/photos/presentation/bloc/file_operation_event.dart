import 'package:equatable/equatable.dart';

abstract class FileOperationEvent extends Equatable {
  const FileOperationEvent();

  @override
  List<Object> get props => [];
}

class CopyFiles extends FileOperationEvent {
  final List<String> sourcePaths;
  final String destinationPath;

  const CopyFiles({
    required this.sourcePaths,
    required this.destinationPath,
  });

  @override
  List<Object> get props => [sourcePaths, destinationPath];
}

class MoveFiles extends FileOperationEvent {
  final List<String> sourcePaths;
  final String destinationPath;

  const MoveFiles({
    required this.sourcePaths,
    required this.destinationPath,
  });

  @override
  List<Object> get props => [sourcePaths, destinationPath];
}

class DeleteFiles extends FileOperationEvent {
  final List<String> paths;

  const DeleteFiles({required this.paths});

  @override
  List<Object> get props => [paths];
}

class UndoOperation extends FileOperationEvent {}

class RedoOperation extends FileOperationEvent {}

class ClearOperationHistory extends FileOperationEvent {}
