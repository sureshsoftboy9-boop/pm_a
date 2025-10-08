import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/recent_folders_bloc.dart';
import '../bloc/recent_folders_event.dart';
import '../bloc/recent_folders_state.dart';
import '../widgets/recent_folders_list.dart';

class RecentFoldersScreen extends StatelessWidget {
  const RecentFoldersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Folders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<RecentFoldersBloc>().add(LoadRecentFolders());
            },
          ),
        ],
      ),
      body: BlocBuilder<RecentFoldersBloc, RecentFoldersState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RecentFoldersBloc>().add(LoadRecentFolders());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.recentFolders.isEmpty) {
            return const Center(
              child: Text('No recent folders'),
            );
          }

          return const RecentFoldersList();
        },
      ),
    );
  }
}
