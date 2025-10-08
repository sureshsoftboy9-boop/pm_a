import '../models/photo.dart';
import '../models/duplicate_group.dart';
import '../repositories/photo_repository.dart';

class DuplicateDetectionService {
  final PhotoRepository _photoRepository;

  DuplicateDetectionService({required PhotoRepository photoRepository})
      : _photoRepository = photoRepository;

  Future<List<DuplicateGroup>> findDuplicates(String directoryPath) async {
    // Get all photos in the directory
    final photos = await _photoRepository.getPhotosInDirectory(
      directoryPath,
      recursive: true,
    );

    // Calculate MD5 hashes for all photos that don't have one
    for (final photo in photos) {
      if (photo.md5Hash == null) {
        final hash = await _photoRepository.calculateMD5(photo.path);
        await _photoRepository.updatePhoto(
          photo.copyWith(md5Hash: hash),
        );
      }
    }

    // Group photos by MD5 hash
    final Map<String, List<Photo>> groups = {};
    for (final photo in photos) {
      if (photo.md5Hash != null) {
        groups.putIfAbsent(photo.md5Hash!, () => []).add(photo);
      }
    }

    // Create duplicate groups for photos with the same hash
    final duplicateGroups = groups.entries
        .where((entry) => entry.value.length > 1)
        .map((entry) {
          final photos = entry.value;
          final totalSize = photos.fold<int>(
            0,
            (sum, photo) => sum + photo.size,
          );
          return DuplicateGroup(
            md5Hash: entry.key,
            photos: photos,
            totalSize: totalSize,
          );
        })
        .toList();

    // Sort groups by wasted space (largest duplication first)
    duplicateGroups.sort((a, b) => b.wastedSpace.compareTo(a.wastedSpace));

    return duplicateGroups;
  }

  Future<List<DuplicateGroup>> findDuplicatesInGroups(
    List<String> directoryPaths,
  ) async {
    List<Photo> allPhotos = [];
    
    // Get all photos from all directories
    for (final path in directoryPaths) {
      final photos = await _photoRepository.getPhotosInDirectory(
        path,
        recursive: true,
      );
      allPhotos.addAll(photos);
    }

    // Calculate MD5 hashes for all photos that don't have one
    for (final photo in allPhotos) {
      if (photo.md5Hash == null) {
        final hash = await _photoRepository.calculateMD5(photo.path);
        await _photoRepository.updatePhoto(
          photo.copyWith(md5Hash: hash),
        );
      }
    }

    // Group photos by MD5 hash
    final Map<String, List<Photo>> groups = {};
    for (final photo in allPhotos) {
      if (photo.md5Hash != null) {
        groups.putIfAbsent(photo.md5Hash!, () => []).add(photo);
      }
    }

    // Create duplicate groups for photos with the same hash
    final duplicateGroups = groups.entries
        .where((entry) => entry.value.length > 1)
        .map((entry) {
          final photos = entry.value;
          final totalSize = photos.fold<int>(
            0,
            (sum, photo) => sum + photo.size,
          );
          return DuplicateGroup(
            md5Hash: entry.key,
            photos: photos,
            totalSize: totalSize,
          );
        })
        .toList();

    // Sort groups by wasted space (largest duplication first)
    duplicateGroups.sort((a, b) => b.wastedSpace.compareTo(a.wastedSpace));

    return duplicateGroups;
  }

  Future<List<DuplicateGroup>> findDuplicatesByFileName(String directoryPath) async {
    final photos = await _photoRepository.getPhotosInDirectory(
      directoryPath,
      recursive: true,
    );

    // Group photos by filename
    final Map<String, List<Photo>> groups = {};
    for (final photo in photos) {
      final name = photo.name.toLowerCase();
      groups.putIfAbsent(name, () => []).add(photo);
    }

    // Create duplicate groups for photos with the same filename
    final duplicateGroups = groups.entries
        .where((entry) => entry.value.length > 1)
        .map((entry) {
          final photos = entry.value;
          final totalSize = photos.fold<int>(
            0,
            (sum, photo) => sum + photo.size,
          );
          // Use first photo's MD5 as group identifier
          final md5Hash = photos[0].md5Hash ?? 'filename-${entry.key}';
          return DuplicateGroup(
            md5Hash: md5Hash,
            photos: photos,
            totalSize: totalSize,
          );
        })
        .toList();

    // Sort groups by wasted space (largest duplication first)
    duplicateGroups.sort((a, b) => b.wastedSpace.compareTo(a.wastedSpace));

    return duplicateGroups;
  }
}
