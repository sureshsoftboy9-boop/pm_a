import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import '../bloc/duplicate_detection_bloc.dart';
import '../bloc/duplicate_detection_event.dart';
import '../bloc/duplicate_detection_state.dart';
import '../bloc/file_operation_bloc.dart';
import '../bloc/file_operation_event.dart';
import '../../domain/models/duplicate_group.dart';
import 'photo_viewer_screen.dart';

class DuplicateDetectionScreen extends StatelessWidget {
  const DuplicateDetectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Duplicate Photos'),
        actions: [
          BlocBuilder<DuplicateDetectionBloc, DuplicateDetectionState>(
            builder: (context, state) {
              if (state.selectedPhotos.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _confirmDelete(context, state.selectedPhotos);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<DuplicateDetectionBloc, DuplicateDetectionState>(
        builder: (context, state) {
          switch (state.status) {
            case DuplicateDetectionStatus.initial:
              return _buildInitialState(context);
            case DuplicateDetectionStatus.scanning:
              return _buildScanningState(context, state);
            case DuplicateDetectionStatus.complete:
              return _buildCompleteState(context, state);
            case DuplicateDetectionStatus.error:
              return _buildErrorState(context, state);
          }
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read<DuplicateDetectionBloc>().add(
                const ScanForDuplicates(directoryPath: '/'),
              );
        },
        child: const Text('Start Scan'),
      ),
    );
  }

  Widget _buildScanningState(
    BuildContext context,
    DuplicateDetectionState state,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Scanning for duplicates...'),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: state.progress),
        ],
      ),
    );
  }

  Widget _buildCompleteState(
    BuildContext context,
    DuplicateDetectionState state,
  ) {
    if (state.duplicateGroups.isEmpty) {
      return const Center(
        child: Text('No duplicates found'),
      );
    }

    return Column(
      children: [
        _buildSummary(state),
        Expanded(
          child: ListView.builder(
            itemCount: state.duplicateGroups.length,
            itemBuilder: (context, index) {
              return _buildDuplicateGroup(
                context,
                state,
                state.duplicateGroups[index],
                index,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(DuplicateDetectionState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                state.duplicateGroups.length.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Groups'),
            ],
          ),
          Column(
            children: [
              Text(
                state.totalDuplicates.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Duplicates'),
            ],
          ),
          Column(
            children: [
              Text(
                '${(state.totalWastedSpace / 1024 / 1024).toStringAsFixed(1)} MB',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('Wasted'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDuplicateGroup(
    BuildContext context,
    DuplicateDetectionState state,
    DuplicateGroup group,
    int index,
  ) {
    final isExpanded = state.expandedGroupIndex == index;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text('${group.photos.length} duplicates'),
            subtitle: Text(
              'Total size: ${(group.totalSize / 1024 / 1024).toStringAsFixed(1)} MB',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () {
                    context.read<DuplicateDetectionBloc>().add(
                          SelectSmallestInGroup(index),
                        );
                  },
                  tooltip: 'Keep smallest',
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: () {
                    context.read<DuplicateDetectionBloc>().add(
                          SelectLargestInGroup(index),
                        );
                  },
                  tooltip: 'Keep largest',
                ),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    context.read<DuplicateDetectionBloc>().add(
                          ToggleGroupExpansion(index),
                        );
                  },
                ),
              ],
            ),
          ),
          if (isExpanded)
            _buildDuplicateList(context, state, group.sortedBySize),
        ],
      ),
    );
  }

  Widget _buildDuplicateList(
    BuildContext context,
    DuplicateDetectionState state,
    List<Photo> photos,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return ListTile(
          leading: SizedBox(
            width: 48,
            height: 48,
            child: Image.file(
              File(photo.path),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image);
              },
            ),
          ),
          title: Text(path.basename(photo.path)),
          subtitle: Text(
            '${(photo.size / 1024 / 1024).toStringAsFixed(1)} MB',
          ),
          trailing: Checkbox(
            value: state.selectedPhotos.contains(photo.path),
            onChanged: (selected) {
              context.read<DuplicateDetectionBloc>().add(
                    SelectPhoto(
                      path: photo.path,
                      selected: selected ?? false,
                    ),
                  );
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewerScreen(
                  photos: photos,
                  initialIndex: index,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, DuplicateDetectionState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(state.error ?? 'An error occurred'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<DuplicateDetectionBloc>().add(
                    const ScanForDuplicates(directoryPath: '/'),
                  );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Set<String> files) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${files.length} files?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FileOperationBloc>().add(
                    DeleteFiles(paths: files.toList()),
                  );
              context.read<DuplicateDetectionBloc>().add(ClearSelection());
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
