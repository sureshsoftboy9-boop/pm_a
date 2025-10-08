import 'package:equatable/equatable.dart';

class RecentFoldersState extends Equatable {
  final List<String> recentFolders;
  final bool isLoading;
  final String? error;

  const RecentFoldersState({
    this.recentFolders = const [],
    this.isLoading = false,
    this.error,
  });

  RecentFoldersState copyWith({
    List<String>? recentFolders,
    bool? isLoading,
    String? error,
  }) {
    return RecentFoldersState(
      recentFolders: recentFolders ?? this.recentFolders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [recentFolders, isLoading, error];
}
