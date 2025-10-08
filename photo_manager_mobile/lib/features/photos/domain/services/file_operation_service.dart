import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/photo.dart';

enum FileOperationType {
  move,
  copy,
  delete,
}

class FileOperation {
  final String sourcePath;
  final String? destinationPath;
  final FileOperationType type;
  final DateTime timestamp;

  FileOperation({
    required this.sourcePath,
    this.destinationPath,
    required this.type,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class FileOperationService {
  final List<FileOperation> _undoStack = [];
  final List<FileOperation> _redoStack = [];
  
  Future<bool> copyFile(String sourcePath, String destinationPath, {
    Function(double)? onProgress,
  }) async {
    try {
      final sourceFile = File(sourcePath);
      final destFile = File(destinationPath);
      
      // Create destination directory if it doesn't exist
      final destDir = destFile.parent;
      if (!await destDir.exists()) {
        await destDir.create(recursive: true);
      }

      // Get file size for progress calculation
      final totalBytes = await sourceFile.length();
      var copiedBytes = 0;

      // Copy the file with progress tracking
      final inputStream = sourceFile.openRead();
      final outputStream = destFile.openWrite();

      await for (var chunk in inputStream) {
        await outputStream.add(chunk);
        copiedBytes += chunk.length;
        onProgress?.call(copiedBytes / totalBytes);
      }

      await outputStream.close();

      // Add operation to undo stack
      _undoStack.add(FileOperation(
        sourcePath: sourcePath,
        destinationPath: destinationPath,
        type: FileOperationType.copy,
      ));
      _redoStack.clear();

      return true;
    } catch (e) {
      print('Error copying file: $e');
      return false;
    }
  }

  Future<bool> moveFile(String sourcePath, String destinationPath, {
    Function(double)? onProgress,
  }) async {
    try {
      // First copy the file
      final success = await copyFile(sourcePath, destinationPath, onProgress: onProgress);
      if (!success) return false;

      // Then delete the original
      final sourceFile = File(sourcePath);
      await sourceFile.delete();

      // Update undo stack
      _undoStack.removeLast(); // Remove the copy operation
      _undoStack.add(FileOperation(
        sourcePath: sourcePath,
        destinationPath: destinationPath,
        type: FileOperationType.move,
      ));
      _redoStack.clear();

      return true;
    } catch (e) {
      print('Error moving file: $e');
      return false;
    }
  }

  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      await file.delete();

      _undoStack.add(FileOperation(
        sourcePath: filePath,
        type: FileOperationType.delete,
      ));
      _redoStack.clear();

      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  Future<bool> undo() async {
    if (_undoStack.isEmpty) return false;

    final operation = _undoStack.removeLast();
    try {
      switch (operation.type) {
        case FileOperationType.copy:
          // Delete the copied file
          if (operation.destinationPath != null) {
            await File(operation.destinationPath!).delete();
          }
          break;

        case FileOperationType.move:
          // Move the file back to its original location
          if (operation.destinationPath != null) {
            await moveFile(operation.destinationPath!, operation.sourcePath);
          }
          break;

        case FileOperationType.delete:
          // Can't undo deletion without backup
          return false;
      }

      _redoStack.add(operation);
      return true;
    } catch (e) {
      print('Error undoing operation: $e');
      return false;
    }
  }

  Future<bool> redo() async {
    if (_redoStack.isEmpty) return false;

    final operation = _redoStack.removeLast();
    try {
      switch (operation.type) {
        case FileOperationType.copy:
          if (operation.destinationPath != null) {
            await copyFile(operation.sourcePath, operation.destinationPath!);
          }
          break;

        case FileOperationType.move:
          if (operation.destinationPath != null) {
            await moveFile(operation.sourcePath, operation.destinationPath!);
          }
          break;

        case FileOperationType.delete:
          await deleteFile(operation.sourcePath);
          break;
      }

      _undoStack.add(operation);
      return true;
    } catch (e) {
      print('Error redoing operation: $e');
      return false;
    }
  }

  bool canUndo() => _undoStack.isNotEmpty;
  bool canRedo() => _redoStack.isNotEmpty;

  void clearHistory() {
    _undoStack.clear();
    _redoStack.clear();
  }
}
