import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "photo_manager.db";
  static const _databaseVersion = 1;

  // singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create photos table
    await db.execute('''
      CREATE TABLE photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        name TEXT NOT NULL,
        size INTEGER NOT NULL,
        width INTEGER NOT NULL,
        height INTEGER NOT NULL,
        date_taken TEXT,
        date_added TEXT NOT NULL,
        md5_hash TEXT,
        is_flagged INTEGER DEFAULT 0
      )
    ''');

    // Create recent_folders table
    await db.execute('''
      CREATE TABLE recent_folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        last_accessed TEXT NOT NULL
      )
    ''');

    // Create indices
    await db.execute('CREATE INDEX idx_photos_md5 ON photos(md5_hash)');
    await db.execute('CREATE INDEX idx_photos_path ON photos(path)');
    await db.execute('CREATE UNIQUE INDEX idx_recent_folders_path ON recent_folders(path)');
  }
}
