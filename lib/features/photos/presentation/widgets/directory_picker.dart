import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DirectoryPicker extends StatefulWidget {
  final void Function(List<String>) onDirectoriesSelected;

  const DirectoryPicker({
    Key? key,
    required this.onDirectoriesSelected,
  }) : super(key: key);

  @override
  State<DirectoryPicker> createState() => _DirectoryPickerState();
}

class _DirectoryPickerState extends State<DirectoryPicker> {
  final List<String> _selectedDirectories = [];

  Future<void> _pickDirectory() async {
    String? directory = await FilePicker.platform.getDirectoryPath();
    if (directory != null && !_selectedDirectories.contains(directory)) {
      setState(() {
        _selectedDirectories.add(directory);
      });
      widget.onDirectoriesSelected(_selectedDirectories);
    }
  }

  void _removeDirectory(String directory) {
    setState(() {
      _selectedDirectories.remove(directory);
    });
    widget.onDirectoriesSelected(_selectedDirectories);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_selectedDirectories.isEmpty)
          const Text('No directories selected'),
        ...List.generate(
          _selectedDirectories.length,
          (index) => Card(
            child: ListTile(
              title: Text(
                _selectedDirectories[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _removeDirectory(_selectedDirectories[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _pickDirectory,
          icon: const Icon(Icons.add),
          label: const Text('Add Directory'),
        ),
      ],
    );
  }
}
