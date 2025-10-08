import 'package:flutter/material.dart';
import '../widgets/directory_picker.dart';

class ScanOptionsDialog extends StatefulWidget {
  const ScanOptionsDialog({Key? key}) : super(key: key);

  @override
  State<ScanOptionsDialog> createState() => _ScanOptionsDialogState();
}

class _ScanOptionsDialogState extends State<ScanOptionsDialog> {
  final List<String> _selectedDirectories = [];
  bool _recursive = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scan Options'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select directories to scan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DirectoryPicker(
            onDirectoriesSelected: (directories) {
              setState(() {
                _selectedDirectories
                  ..clear()
                  ..addAll(directories);
              });
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Include subdirectories'),
            value: _recursive,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _recursive = value;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedDirectories.isEmpty
              ? null
              : () {
                  Navigator.pop(context, {
                    'directories': _selectedDirectories,
                    'recursive': _recursive,
                  });
                },
          child: const Text('Start Scan'),
        ),
      ],
    );
  }
}
