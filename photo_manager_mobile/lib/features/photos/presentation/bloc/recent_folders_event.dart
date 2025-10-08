import 'package:equatable/equatable.dart';

abstract class RecentFoldersEvent extends Equatable {
  const RecentFoldersEvent();

  @override
  List<Object> get props => [];
}

class LoadRecentFolders extends RecentFoldersEvent {}

class AddRecentFolder extends RecentFoldersEvent {
  final String path;

  const AddRecentFolder(this.path);

  @override
  List<Object> get props => [path];
}

class RemoveRecentFolder extends RecentFoldersEvent {
  final String path;

  const RemoveRecentFolder(this.path);

  @override
  List<Object> get props => [path];
}
