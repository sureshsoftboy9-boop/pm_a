import 'package:equatable/equatable.dart';
import '../models/photo.dart';

class DuplicateGroup extends Equatable {
  final String md5Hash;
  final List<Photo> photos;
  final int totalSize;

  const DuplicateGroup({
    required this.md5Hash,
    required this.photos,
    required this.totalSize,
  });

  @override
  List<Object> get props => [md5Hash, photos, totalSize];

  int get duplicateCount => photos.length - 1;
  int get wastedSpace => totalSize - (photos.isEmpty ? 0 : photos[0].size);

  Photo get largestPhoto =>
      photos.reduce((a, b) => a.size > b.size ? a : b);

  Photo get smallestPhoto =>
      photos.reduce((a, b) => a.size < b.size ? a : b);

  List<Photo> get sortedBySize =>
      List.from(photos)..sort((a, b) => b.size.compareTo(a.size));
}
