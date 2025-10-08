import 'package:equatable/equatable.dart';

class PhotoBrowserState extends Equatable {
  final String currentPath;
  final List<String> pathHistory;
  final List<Photo> photos;
  final bool isLoading;
  final bool isGridView;
  final String? error;
  final Set<String> selectedPhotos;

  const PhotoBrowserState({
    required this.currentPath,
    required this.pathHistory,
    required this.photos,
    this.isLoading = false,
    this.isGridView = true,
    this.error,
    this.selectedPhotos = const {},
  });

  PhotoBrowserState copyWith({
    String? currentPath,
    List<String>? pathHistory,
    List<Photo>? photos,
    bool? isLoading,
    bool? isGridView,
    String? error,
    Set<String>? selectedPhotos,
  }) {
    return PhotoBrowserState(
      currentPath: currentPath ?? this.currentPath,
      pathHistory: pathHistory ?? this.pathHistory,
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      isGridView: isGridView ?? this.isGridView,
      error: error,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
    );
  }

  @override
  List<Object?> get props => [
        currentPath,
        pathHistory,
        photos,
        isLoading,
        isGridView,
        error,
        selectedPhotos,
      ];
}
