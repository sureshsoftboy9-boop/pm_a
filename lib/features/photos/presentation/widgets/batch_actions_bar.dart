import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/duplicate_detection_bloc.dart';
import '../bloc/duplicate_detection_event.dart';
import '../bloc/duplicate_detection_state.dart';

class BatchActionsBar extends StatelessWidget {
  const BatchActionsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DuplicateDetectionBloc, DuplicateDetectionState>(
      builder: (context, state) {
        final selectedCount = state.selectedPaths.length;
        
        if (selectedCount == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedCount items selected',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        context.read<DuplicateDetectionBloc>().add(ClearSelection());
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear Selection'),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Selected Files'),
                            content: Text(
                              'Are you sure you want to delete $selectedCount selected files? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  context.read<DuplicateDetectionBloc>().add(
                                    BatchDeleteSelected(),
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete Selected'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
