import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:photo_manager/photo_manager.dart';
import '../../../../core/database/database_helper.dart';
import '../../domain/models/photo.dart';
import '../../domain/repositories/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final DatabaseHelper _databaseHelper;

  PhotoRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  @override
  Future<List<Photo>> getPhotosInDirectory(String dirPath, {bool recursive = false}) async {
    final directory = Directory(dirPath);
    if (!directory.existsSync()) {
      throw Exception('Directory not found');
    }

    List<Photo> photos = [];
    await for (final entity in directory.list(recursive: recursive)) {
      if (entity is File && _isImageFile(entity.path)) {
        try {
          final photo = await _createPhotoFromFile(entity as File);
          photos.add(photo);
        } catch (e) {
          print('Error processing file ${entity.path}: $e');
          continue;
        }
      }
    }

    return photos;
  }

  bool _isImageFile(String path) {
    final extension = path.toLowerCase().split('.').last;
    return [
      'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'tiff',
      'cr2', 'nef', 'arw', 'dng', 'raf', 'rw2', 'pef', 'srw', 'orf',
      'heic', 'heif'
    ].contains(extension);
  }

  Future<Photo> _createPhotoFromFile(File file) async {
    final stats = await file.stat();
    final md5Hash = await calculateMD5(file.path);
    
    // Get image dimensions using photo_manager
    final asset = await AssetEntity.fromFile(file);
    final size = await asset?.size;
    
    return Photo(
      path: file.path,
      name: path.basename(file.path),
      size: stats.size,
      width: size?.width.toInt() ?? 0,
      height: size?.height.toInt() ?? 0,
      dateAdded: stats.modified,
      md5Hash: md5Hash,
    );
  }

  @override
  Future<void> savePhoto(Photo photo) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'photos',
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> savePhotos(List<Photo> photos) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();
    
    for (final photo in photos) {
      batch.insert(
        'photos',
        photo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
  }

  @override
  Future<Photo?> getPhotoByPath(String path) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'photos',
      where: 'path = ?',
      whereArgs: [path],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Photo.fromMap(maps.first);
  }

  @override
  Future<void> deletePhoto(String path) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'photos',
      where: 'path = ?',
      whereArgs: [path],
    );
  }

  @override
  Future<void> updatePhoto(Photo photo) async {
    final db = await _databaseHelper.database;
    await db.update(
      'photos',
      photo.toMap(),
      where: 'id = ?',
      whereArgs: [photo.id],
    );
  }

  @override
  Future<String> calculateMD5(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    return md5.convert(bytes).toString();
  }

  @override
  Future<List<Photo>> findDuplicates(String md5Hash) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'photos',
      where: 'md5_hash = ?',
      whereArgs: [md5Hash],
    );

    return List.generate(maps.length, (i) {
      return Photo.fromMap(maps[i]);
    });
  }

  @override
  Future<List<Photo>> getFlaggedPhotos() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'photos',
      where: 'is_flagged = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Photo.fromMap(maps[i]);
    });
  }
}
