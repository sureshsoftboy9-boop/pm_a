import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recent_folders_bloc.dart';
import '../bloc/recent_folders_event.dart';
import '../bloc/recent_folders_state.dart';

class RecentFoldersList extends StatelessWidget {
  const RecentFoldersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentFoldersBloc, RecentFoldersState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }

        if (state.recentFolders.isEmpty) {
          return const Center(child: Text('No recent folders'));
        }

        return ListView.builder(
          itemCount: state.recentFolders.length,
          itemBuilder: (context, index) {
            final folder = state.recentFolders[index];
            return ListTile(
              leading: const Icon(Icons.folder),
              title: Text(folder),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.read<RecentFoldersBloc>().add(
                    RemoveRecentFolder(folder),
                  );
                },
              ),
              onTap: () {
                // Handle folder selection
                // You can navigate to the folder contents or trigger other actions
              },
            );
          },
        );
      },
    );
  }
}
