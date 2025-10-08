import '../../../../core/database/database_helper.dart';

class RecentFoldersRepository {
  final DatabaseHelper _databaseHelper;
  static const int _maxRecentFolders = 10;

  RecentFoldersRepository({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  Future<void> addRecentFolder(String path) async {
    final db = await _databaseHelper.database;
    final now = DateTime.now().toIso8601String();

    // First, try to update existing entry
    final count = await db.update(
      'recent_folders',
      {'last_accessed': now},
      where: 'path = ?',
      whereArgs: [path],
    );

    // If no existing entry was updated, insert new one
    if (count == 0) {
      await db.insert(
        'recent_folders',
        {
          'path': path,
          'last_accessed': now,
        },
      );

      // Keep only the most recent folders
      await _cleanupOldFolders();
    }
  }

  Future<void> _cleanupOldFolders() async {
    final db = await _databaseHelper.database;
    await db.rawDelete('''
      DELETE FROM recent_folders 
      WHERE id NOT IN (
        SELECT id FROM recent_folders 
        ORDER BY last_accessed DESC 
        LIMIT ?
      )
    ''', [_maxRecentFolders]);
  }

  Future<List<String>> getRecentFolders() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recent_folders',
      orderBy: 'last_accessed DESC',
    );

    return List.generate(maps.length, (i) => maps[i]['path'] as String);
  }

  Future<void> removeRecentFolder(String path) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'recent_folders',
      where: 'path = ?',
      whereArgs: [path],
    );
  }
}
