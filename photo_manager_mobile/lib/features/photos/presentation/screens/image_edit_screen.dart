import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/image_processing_service.dart';
import '../bloc/image_processing_bloc.dart';
import '../bloc/image_processing_event.dart';
import '../bloc/image_processing_state.dart';
import 'dart:io';

class ImageEditScreen extends StatelessWidget {
  final File image;

  const ImageEditScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
      ),
      body: BlocBuilder<ImageProcessingBloc, ImageProcessingState>(
        builder: (context, state) {
          if (state.isProcessing) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Image.file(state.processedImage ?? image),
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Error: ${state.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const Divider(),
                _buildEditingTools(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditingTools(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildResizeControls(context),
          const SizedBox(height: 16),
          _buildRotationControls(context),
          const SizedBox(height: 16),
          _buildAdjustmentControls(context),
          const SizedBox(height: 16),
          _buildFilterControls(context),
        ],
      ),
    );
  }

  Widget _buildResizeControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resize', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => context.read<ImageProcessingBloc>().add(
                    ResizeImage(image: image, width: 800, height: 600),
                  ),
                  child: const Text('800x600'),
                ),
                TextButton(
                  onPressed: () => context.read<ImageProcessingBloc>().add(
                    ResizeImage(image: image, width: 1024, height: 768),
                  ),
                  child: const Text('1024x768'),
                ),
                TextButton(
                  onPressed: () => context.read<ImageProcessingBloc>().add(
                    ResizeImage(image: image, width: 1920, height: 1080),
                  ),
                  child: const Text('1920x1080'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRotationControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rotate', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => context.read<ImageProcessingBloc>().add(
                    RotateImage(image: image, degrees: 90),
                  ),
                  icon: const Icon(Icons.rotate_90_degrees_ccw),
                ),
                IconButton(
                  onPressed: () => context.read<ImageProcessingBloc>().add(
                    RotateImage(image: image, degrees: 180),
                  ),
                  icon: const Icon(Icons.rotate_left),
                ),
                IconButton(
                  onPressed: () => context.read<ImageProcessingBloc>().add(
                    RotateImage(image: image, degrees: 270),
                  ),
                  icon: const Icon(Icons.rotate_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustmentControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Adjustments', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: const Text('Brightness'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => context.read<ImageProcessingBloc>().add(
                      AdjustBrightness(image: image, amount: -20),
                    ),
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    onPressed: () => context.read<ImageProcessingBloc>().add(
                      AdjustBrightness(image: image, amount: 20),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Contrast'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => context.read<ImageProcessingBloc>().add(
                      AdjustContrast(image: image, amount: -20),
                    ),
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    onPressed: () => context.read<ImageProcessingBloc>().add(
                      AdjustContrast(image: image, amount: 20),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterControls(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
              children: [
                FilterChip(
                  label: const Text('Grayscale'),
                  onSelected: (_) => context.read<ImageProcessingBloc>().add(
                    ApplyFilter(image: image, filterType: FilterType.grayscale),
                  ),
                ),
                FilterChip(
                  label: const Text('Sepia'),
                  onSelected: (_) => context.read<ImageProcessingBloc>().add(
                    ApplyFilter(image: image, filterType: FilterType.sepia),
                  ),
                ),
                FilterChip(
                  label: const Text('Invert'),
                  onSelected: (_) => context.read<ImageProcessingBloc>().add(
                    ApplyFilter(image: image, filterType: FilterType.invert),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
