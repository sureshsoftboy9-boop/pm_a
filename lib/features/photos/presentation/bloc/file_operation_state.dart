import 'package:equatable/equatable.dart';

enum OperationStatus {
  none,
  inProgress,
  completed,
  failed,
}

class FileOperationState extends Equatable {
  final OperationStatus status;
  final double progress;
  final String? currentOperation;
  final String? error;
  final bool canUndo;
  final bool canRedo;

  const FileOperationState({
    this.status = OperationStatus.none,
    this.progress = 0.0,
    this.currentOperation,
    this.error,
    this.canUndo = false,
    this.canRedo = false,
  });

  FileOperationState copyWith({
    OperationStatus? status,
    double? progress,
    String? currentOperation,
    String? error,
    bool? canUndo,
    bool? canRedo,
  }) {
    return FileOperationState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      currentOperation: currentOperation ?? this.currentOperation,
      error: error,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
    );
  }

  @override
  List<Object?> get props => [
        status,
        progress,
        currentOperation,
        error,
        canUndo,
        canRedo,
      ];
}
