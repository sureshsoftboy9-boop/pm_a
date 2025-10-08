import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path/path.dart' as path;
import '../bloc/photo_browser_bloc.dart';
import '../bloc/photo_browser_event.dart';
import '../bloc/photo_browser_state.dart';
import '../widgets/photo_grid_item.dart';
import '../screens/exif_viewer_screen.dart';
import '../../domain/models/photo.dart';

class PhotoBrowserScreen extends StatelessWidget {
  const PhotoBrowserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoBrowserBloc, PhotoBrowserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_buildTitle(state.currentPath)),
            leading: state.pathHistory.length > 1
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      context.read<PhotoBrowserBloc>().add(NavigateBack());
                    },
                  )
                : null,
            actions: [
              BlocBuilder<FileOperationBloc, FileOperationState>(
                builder: (context, fileOpState) {
                  if (fileOpState.canUndo) {
                    return IconButton(
                      icon: const Icon(Icons.undo),
                      onPressed: () {
                        context.read<FileOperationBloc>().add(UndoOperation());
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              BlocBuilder<FileOperationBloc, FileOperationState>(
                builder: (context, fileOpState) {
                  if (fileOpState.canRedo) {
                    return IconButton(
                      icon: const Icon(Icons.redo),
                      onPressed: () {
                        context.read<FileOperationBloc>().add(RedoOperation());
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              IconButton(
                icon: Icon(
                  state.isGridView ? Icons.list : Icons.grid_view,
                ),
                onPressed: () {
                  context.read<PhotoBrowserBloc>().add(ToggleViewMode());
                },
              ),
            ],
          ),
          body: _buildBody(context, state),
          floatingActionButton: state.selectedPhotos.isNotEmpty
              ? FloatingActionButton(
                  child: const Icon(Icons.more_vert),
                  onPressed: () {
                    _showActionSheet(context, state.selectedPhotos);
                  },
                )
              : null,
        );
      },
    );
  }

  String _buildTitle(String currentPath) {
    return path.basename(currentPath).isEmpty
        ? 'Photos'
        : path.basename(currentPath);
  }

  Widget _buildBody(BuildContext context, PhotoBrowserState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context
                    .read<PhotoBrowserBloc>()
                    .add(RefreshCurrentDirectory());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.photos.isEmpty) {
      return const Center(
        child: Text('No photos in this directory'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PhotoBrowserBloc>().add(RefreshCurrentDirectory());
      },
      child: state.isGridView
          ? _buildGrid(context, state)
          : _buildList(context, state),
    );
  }

  Widget _buildGrid(BuildContext context, PhotoBrowserState state) {
    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: state.photos.length,
      itemBuilder: (context, index) {
        final photo = state.photos[index];
        return PhotoGridItem(
          photo: photo,
          isSelected: state.selectedPhotos.contains(photo.path),
          onSelect: (selected) {
            context.read<PhotoBrowserBloc>().add(
                  SelectPhoto(
                    path: photo.path,
                    selected: selected,
                  ),
                );
          },
          onTap: () {
            // TODO: Implement photo viewer
          },
        );
      },
    );
  }

  Widget _buildList(BuildContext context, PhotoBrowserState state) {
    return ListView.builder(
      itemCount: state.photos.length,
      itemBuilder: (context, index) {
        final photo = state.photos[index];
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
            '${(photo.size / 1024 / 1024).toStringAsFixed(2)} MB',
          ),
          trailing: Checkbox(
            value: state.selectedPhotos.contains(photo.path),
            onChanged: (selected) {
              context.read<PhotoBrowserBloc>().add(
                    SelectPhoto(
                      path: photo.path,
                      selected: selected ?? false,
                    ),
                  );
            },
          ),
          onTap: () {
            // TODO: Implement photo viewer
          },
        );
      },
    );
  }

  void _showActionSheet(BuildContext context, Set<String> selectedPhotos) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<FileOperationBloc, FileOperationState>(
          listener: (context, state) {
            if (state.status != OperationStatus.none) {
              Navigator.pop(context); // Close bottom sheet
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const FileOperationProgressDialog(),
              );
            }
          },
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.copy),
                  title: const Text('Copy'),
                  onTap: () async {
                    Navigator.pop(context);
                    final String? destinationPath = await _pickDirectory(context);
                    if (destinationPath != null) {
                      context.read<FileOperationBloc>().add(
                            CopyFiles(
                              sourcePaths: selectedPhotos.toList(),
                              destinationPath: destinationPath,
                            ),
                          );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cut),
                  title: const Text('Move'),
                  onTap: () async {
                    Navigator.pop(context);
                    final String? destinationPath = await _pickDirectory(context);
                    if (destinationPath != null) {
                      context.read<FileOperationBloc>().add(
                            MoveFiles(
                              sourcePaths: selectedPhotos.toList(),
                              destinationPath: destinationPath,
                            ),
                          );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(context, selectedPhotos);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _pickDirectory(BuildContext context) async {
    // TODO: Implement directory picker
    return '/tmp'; // Temporary implementation
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
