import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import '../../domain/services/file_operation_service.dart';
import 'file_operation_event.dart';
import 'file_operation_state.dart';

class FileOperationBloc extends Bloc<FileOperationEvent, FileOperationState> {
  final FileOperationService _fileOperationService;

  FileOperationBloc({
    required FileOperationService fileOperationService,
  })  : _fileOperationService = fileOperationService,
        super(const FileOperationState()) {
    on<CopyFiles>(_onCopyFiles);
    on<MoveFiles>(_onMoveFiles);
    on<DeleteFiles>(_onDeleteFiles);
    on<UndoOperation>(_onUndo);
    on<RedoOperation>(_onRedo);
    on<ClearOperationHistory>(_onClearHistory);
  }

  Future<void> _onCopyFiles(
    CopyFiles event,
    Emitter<FileOperationState> emit,
  ) async {
    emit(state.copyWith(
      status: OperationStatus.inProgress,
      progress: 0.0,
      currentOperation: 'Copying files...',
    ));

    try {
      int completed = 0;
      final total = event.sourcePaths.length;

      for (final sourcePath in event.sourcePaths) {
        final fileName = path.basename(sourcePath);
        final destPath = path.join(event.destinationPath, fileName);

        final success = await _fileOperationService.copyFile(
          sourcePath,
          destPath,
          onProgress: (progress) {
            emit(state.copyWith(
              progress: (completed + progress) / total,
              currentOperation: 'Copying $fileName...',
            ));
          },
        );

        if (!success) {
          emit(state.copyWith(
            status: OperationStatus.failed,
            error: 'Failed to copy $fileName',
            canUndo: _fileOperationService.canUndo(),
            canRedo: _fileOperationService.canRedo(),
          ));
          return;
        }
        completed++;
      }

      emit(state.copyWith(
        status: OperationStatus.completed,
        progress: 1.0,
        currentOperation: 'Copied ${event.sourcePaths.length} files',
        canUndo: _fileOperationService.canUndo(),
        canRedo: _fileOperationService.canRedo(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OperationStatus.failed,
        error: e.toString(),
        canUndo: _fileOperationService.canUndo(),
        canRedo: _fileOperationService.canRedo(),
      ));
    }
  }

  Future<void> _onMoveFiles(
    MoveFiles event,
    Emitter<FileOperationState> emit,
  ) async {
    emit(state.copyWith(
      status: OperationStatus.inProgress,
      progress: 0.0,
      currentOperation: 'Moving files...',
    ));

    try {
      int completed = 0;
      final total = event.sourcePaths.length;

      for (final sourcePath in event.sourcePaths) {
        final fileName = path.basename(sourcePath);
        final destPath = path.join(event.destinationPath, fileName);

        final success = await _fileOperationService.moveFile(
          sourcePath,
          destPath,
          onProgress: (progress) {
            emit(state.copyWith(
              progress: (completed + progress) / total,
              currentOperation: 'Moving $fileName...',
            ));
          },
        );

        if (!success) {
          emit(state.copyWith(
            status: OperationStatus.failed,
            error: 'Failed to move $fileName',
            canUndo: _fileOperationService.canUndo(),
            canRedo: _fileOperationService.canRedo(),
          ));
          return;
        }
        completed++;
      }

      emit(state.copyWith(
        status: OperationStatus.completed,
        progress: 1.0,
        currentOperation: 'Moved ${event.sourcePaths.length} files',
        canUndo: _fileOperationService.canUndo(),
        canRedo: _fileOperationService.canRedo(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OperationStatus.failed,
        error: e.toString(),
        canUndo: _fileOperationService.canUndo(),
        canRedo: _fileOperationService.canRedo(),
      ));
    }
  }

  Future<void> _onDeleteFiles(
    DeleteFiles event,
    Emitter<FileOperationState> emit,
  ) async {
    emit(state.copyWith(
      status: OperationStatus.inProgress,
      progress: 0.0,
      currentOperation: 'Deleting files...',
    ));

    try {
      int completed = 0;
      final total = event.paths.length;

      for (final path in event.paths) {
        final fileName = path.basename(path);
        final success = await _fileOperationService.deleteFile(path);

        if (!success) {
          emit(state.copyWith(
            status: OperationStatus.failed,
            error: 'Failed to delete $fileName',
            canUndo: _fileOperationService.canUndo(),
            canRedo: _fileOperationService.canRedo(),
          ));
          return;
        }

        completed++;
        emit(state.copyWith(
          progress: completed / total,
          currentOperation: 'Deleting files ($completed/$total)...',
        ));
      }

      emit(state.copyWith(
        status: OperationStatus.completed,
        progress: 1.0,
        currentOperation: 'Deleted ${event.paths.length} files',
        canUndo: _fileOperationService.canUndo(),
        canRedo: _fileOperationService.canRedo(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OperationStatus.failed,
        error: e.toString(),
        canUndo: _fileOperationService.canUndo(),
        canRedo: _fileOperationService.canRedo(),
      ));
    }
  }

  Future<void> _onUndo(
    UndoOperation event,
    Emitter<FileOperationState> emit,
  ) async {
    try {
      final success = await _fileOperationService.undo();
      if (success) {
        emit(state.copyWith(
          status: OperationStatus.completed,
          currentOperation: 'Undo successful',
          canUndo: _fileOperationService.canUndo(),
          canRedo: _fileOperationService.canRedo(),
        ));
      } else {
        emit(state.copyWith(
          status: OperationStatus.failed,
          error: 'Failed to undo operation',
          canUndo: _fileOperationService.canUndo(),
          canRedo: _fileOperationService.canRedo(),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: OperationStatus.failed,
        error: e.toString(),
        canUndo: _fileOperationService.canUndo(),
        canRedo: _fileOperationService.canRedo(),
      ));
    }
  }

  Future<void> _onRedo(
    RedoOperation event,
    Emitter<FileOperationState> emit,
  ) async {
    try {
      final success = await _fileOperationService.redo();
      if (success) {
        emit(state.copyWith(
          status: OperationStatus.completed,
          currentOperation: 'Redo successful',
          canUndo: _fileOperationService.canUndo(),
          canRedo: _fileOperationService.canRedo(),
        ));
      } else {
        emit(state.copyWith(
          status: OperationStatus.failed,
          error: 'Failed to redo operation',
          canUndo: _fileOperationService.canUndo(),
          canRedo: _fileOperationService.canRedo(),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: OperationStatus.failed,
        error: e.toString(),
        canUndo: _fileOperationService.canUndo(),
        canRedo: _fileOperationService.canRedo(),
      ));
    }
  }

  void _onClearHistory(
    ClearOperationHistory event,
    Emitter<FileOperationState> emit,
  ) {
    _fileOperationService.clearHistory();
    emit(state.copyWith(
      canUndo: false,
      canRedo: false,
    ));
  }
}
