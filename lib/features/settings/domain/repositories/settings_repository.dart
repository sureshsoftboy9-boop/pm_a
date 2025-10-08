import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  static const String _keyDuplicateDetection = 'enableDuplicateDetection';
  static const String _keyExifData = 'saveExifData';
  static const String _keyMaxRecentFolders = 'maxRecentFolders';
  static const String _keyDarkMode = 'darkMode';
  static const String _keyDefaultSortOrder = 'defaultSortOrder';
  static const String _keyShowHiddenFiles = 'showHiddenFiles';

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    return AppSettings(
      enableDuplicateDetection: prefs.getBool(_keyDuplicateDetection) ?? true,
      saveExifData: prefs.getBool(_keyExifData) ?? true,
      maxRecentFolders: prefs.getInt(_keyMaxRecentFolders) ?? 10,
      darkMode: prefs.getBool(_keyDarkMode) ?? false,
      defaultSortOrder: prefs.getString(_keyDefaultSortOrder) ?? 'date',
      showHiddenFiles: prefs.getBool(_keyShowHiddenFiles) ?? false,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setBool(_keyDuplicateDetection, settings.enableDuplicateDetection);
    await prefs.setBool(_keyExifData, settings.saveExifData);
    await prefs.setInt(_keyMaxRecentFolders, settings.maxRecentFolders);
    await prefs.setBool(_keyDarkMode, settings.darkMode);
    await prefs.setString(_keyDefaultSortOrder, settings.defaultSortOrder);
    await prefs.setBool(_keyShowHiddenFiles, settings.showHiddenFiles);
  }
}
