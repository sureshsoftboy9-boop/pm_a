import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/duplicate_detection_bloc.dart';
import '../bloc/duplicate_detection_event.dart';
import '../bloc/duplicate_detection_state.dart';

class DuplicateGroupActions extends StatelessWidget {
  final int groupIndex;

  const DuplicateGroupActions({
    Key? key,
    required this.groupIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DuplicateDetectionBloc, DuplicateDetectionState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8.0,
          children: [
            ActionChip(
              avatar: const Icon(Icons.photo_size_select_small),
              label: const Text('Select Smallest'),
              onPressed: () {
                context.read<DuplicateDetectionBloc>().add(
                  SelectSmallestInGroup(groupIndex),
                );
              },
            ),
            ActionChip(
              avatar: const Icon(Icons.photo_size_select_large),
              label: const Text('Select Largest'),
              onPressed: () {
                context.read<DuplicateDetectionBloc>().add(
                  SelectLargestInGroup(groupIndex),
                );
              },
            ),
            ActionChip(
              avatar: const Icon(Icons.access_time),
              label: const Text('Select Newest'),
              onPressed: () {
                context.read<DuplicateDetectionBloc>().add(
                  SelectNewestInGroup(groupIndex),
                );
              },
            ),
            ActionChip(
              avatar: const Icon(Icons.history),
              label: const Text('Select Oldest'),
              onPressed: () {
                context.read<DuplicateDetectionBloc>().add(
                  SelectOldestInGroup(groupIndex),
                );
              },
            ),
            ActionChip(
              avatar: const Icon(Icons.select_all),
              label: const Text('Select All'),
              onPressed: () {
                context.read<DuplicateDetectionBloc>().add(
                  SelectAllInGroup(groupIndex),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
