import 'package:flutter/material.dart';
import '../../domain/services/exif_service.dart';

class ExifViewerScreen extends StatelessWidget {
  final String imagePath;
  final ExifService _exifService;

  const ExifViewerScreen({
    Key? key,
    required this.imagePath,
    ExifService? exifService,
  })  : _exifService = exifService ?? const ExifService(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Details'),
      ),
      body: FutureBuilder<ExifData?>(
        future: _exifService.readExif(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final exifData = snapshot.data;
          if (exifData == null) {
            return const Center(child: Text('No EXIF data available'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection(
                'Camera Information',
                [
                  if (exifData.make != null)
                    _buildInfoRow('Make', exifData.make!),
                  if (exifData.model != null)
                    _buildInfoRow('Model', exifData.model!),
                  if (exifData.lens != null)
                    _buildInfoRow('Lens', exifData.lens!),
                ],
              ),
              const Divider(),
              _buildSection(
                'Photo Details',
                [
                  if (exifData.dateTaken != null)
                    _buildInfoRow(
                      'Date Taken',
                      exifData.dateTaken!.toString(),
                    ),
                  if (exifData.width != null && exifData.height != null)
                    _buildInfoRow(
                      'Dimensions',
                      '${exifData.width}×${exifData.height}',
                    ),
                ],
              ),
              const Divider(),
              _buildSection(
                'Camera Settings',
                [
                  if (exifData.focalLength != null)
                    _buildInfoRow(
                      'Focal Length',
                      '${exifData.focalLength}mm',
                    ),
                  if (exifData.aperture != null)
                    _buildInfoRow('Aperture', 'f/${exifData.aperture}'),
                  if (exifData.exposureTime != null)
                    _buildInfoRow(
                      'Exposure Time',
                      exifData.exposureTime!,
                    ),
                  if (exifData.iso != null)
                    _buildInfoRow('ISO', exifData.iso!.toString()),
                ],
              ),
              if (exifData.latitude != null && exifData.longitude != null) ...[
                const Divider(),
                _buildSection(
                  'Location',
                  [
                    _buildInfoRow(
                      'Coordinates',
                      '${exifData.latitude}, ${exifData.longitude}',
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDateEditDialog(context);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDateEditDialog(BuildContext context) async {
    final exifData = await _exifService.readExif(imagePath);
    if (exifData?.dateTaken == null) return;

    if (!context.mounted) return;

    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: exifData!.dateTaken!,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (newDate == null || !context.mounted) return;

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(exifData.dateTaken!),
    );

    if (newTime == null || !context.mounted) return;

    final DateTime newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    try {
      final success = await _exifService.updateImageDate(
        imagePath,
        newDateTime,
      );

      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Date updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update date')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
