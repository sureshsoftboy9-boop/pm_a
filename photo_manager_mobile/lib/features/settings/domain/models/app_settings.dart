import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final bool enableDuplicateDetection;
  final bool saveExifData;
  final int maxRecentFolders;
  final bool darkMode;
  final String defaultSortOrder;
  final bool showHiddenFiles;

  const AppSettings({
    this.enableDuplicateDetection = true,
    this.saveExifData = true,
    this.maxRecentFolders = 10,
    this.darkMode = false,
    this.defaultSortOrder = 'date',
    this.showHiddenFiles = false,
  });

  AppSettings copyWith({
    bool? enableDuplicateDetection,
    bool? saveExifData,
    int? maxRecentFolders,
    bool? darkMode,
    String? defaultSortOrder,
    bool? showHiddenFiles,
  }) {
    return AppSettings(
      enableDuplicateDetection: enableDuplicateDetection ?? this.enableDuplicateDetection,
      saveExifData: saveExifData ?? this.saveExifData,
      maxRecentFolders: maxRecentFolders ?? this.maxRecentFolders,
      darkMode: darkMode ?? this.darkMode,
      defaultSortOrder: defaultSortOrder ?? this.defaultSortOrder,
      showHiddenFiles: showHiddenFiles ?? this.showHiddenFiles,
    );
  }

  @override
  List<Object?> get props => [
        enableDuplicateDetection,
        saveExifData,
        maxRecentFolders,
        darkMode,
        defaultSortOrder,
        showHiddenFiles,
      ];
}
