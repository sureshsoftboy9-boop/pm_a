import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return ListView(
            children: [
              _buildSwitchTile(
                context,
                title: 'Enable Duplicate Detection',
                value: state.settings.enableDuplicateDetection,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        ToggleDuplicateDetection(value),
                      );
                },
              ),
              _buildSwitchTile(
                context,
                title: 'Save EXIF Data',
                value: state.settings.saveExifData,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        ToggleExifData(value),
                      );
                },
              ),
              _buildSwitchTile(
                context,
                title: 'Dark Mode',
                value: state.settings.darkMode,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        ToggleDarkMode(value),
                      );
                },
              ),
              _buildSwitchTile(
                context,
                title: 'Show Hidden Files',
                value: state.settings.showHiddenFiles,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        ToggleShowHiddenFiles(value),
                      );
                },
              ),
              _buildSliderTile(
                context,
                title: 'Max Recent Folders',
                value: state.settings.maxRecentFolders.toDouble(),
                min: 5,
                max: 20,
                divisions: 3,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateMaxRecentFolders(value.round()),
                      );
                },
              ),
              _buildSortOrderTile(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSliderTile(
    BuildContext context, {
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: value.round().toString(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSortOrderTile(BuildContext context, SettingsState state) {
    return ListTile(
      title: const Text('Default Sort Order'),
      trailing: DropdownButton<String>(
        value: state.settings.defaultSortOrder,
        items: const [
          DropdownMenuItem(value: 'date', child: Text('Date')),
          DropdownMenuItem(value: 'name', child: Text('Name')),
          DropdownMenuItem(value: 'size', child: Text('Size')),
        ],
        onChanged: (value) {
          if (value != null) {
            context.read<SettingsBloc>().add(
                  UpdateDefaultSortOrder(value),
                );
          }
        },
      ),
    );
  }
}
