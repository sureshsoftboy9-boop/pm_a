import '../models/photo.dart';

abstract class PhotoRepository {
  /// Get all photos in a directory
  Future<List<Photo>> getPhotosInDirectory(String path, {bool recursive = false});

  /// Save photo metadata to database
  Future<void> savePhoto(Photo photo);

  /// Save multiple photos metadata to database
  Future<void> savePhotos(List<Photo> photos);

  /// Get photo by path
  Future<Photo?> getPhotoByPath(String path);

  /// Delete photo metadata from database
  Future<void> deletePhoto(String path);

  /// Update photo metadata in database
  Future<void> updatePhoto(Photo photo);

  /// Calculate MD5 hash for a file
  Future<String> calculateMD5(String filePath);

  /// Get all photos with the same MD5 hash
  Future<List<Photo>> findDuplicates(String md5Hash);
  
  /// Get all photos marked as flagged
  Future<List<Photo>> getFlaggedPhotos();
}
