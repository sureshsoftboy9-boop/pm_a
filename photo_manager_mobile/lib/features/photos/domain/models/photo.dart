import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final int? id;
  final String path;
  final String name;
  final int size;
  final int width;
  final int height;
  final DateTime? dateTaken;
  final DateTime dateAdded;
  final String? md5Hash;
  final bool isFlagged;

  const Photo({
    this.id,
    required this.path,
    required this.name,
    required this.size,
    required this.width,
    required this.height,
    this.dateTaken,
    required this.dateAdded,
    this.md5Hash,
    this.isFlagged = false,
  });

  @override
  List<Object?> get props => [
        id,
        path,
        name,
        size,
        width,
        height,
        dateTaken,
        dateAdded,
        md5Hash,
        isFlagged,
      ];

  Photo copyWith({
    int? id,
    String? path,
    String? name,
    int? size,
    int? width,
    int? height,
    DateTime? dateTaken,
    DateTime? dateAdded,
    String? md5Hash,
    bool? isFlagged,
  }) {
    return Photo(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      size: size ?? this.size,
      width: width ?? this.width,
      height: height ?? this.height,
      dateTaken: dateTaken ?? this.dateTaken,
      dateAdded: dateAdded ?? this.dateAdded,
      md5Hash: md5Hash ?? this.md5Hash,
      isFlagged: isFlagged ?? this.isFlagged,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'size': size,
      'width': width,
      'height': height,
      'date_taken': dateTaken?.toIso8601String(),
      'date_added': dateAdded.toIso8601String(),
      'md5_hash': md5Hash,
      'is_flagged': isFlagged ? 1 : 0,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'] as int?,
      path: map['path'] as String,
      name: map['name'] as String,
      size: map['size'] as int,
      width: map['width'] as int,
      height: map['height'] as int,
      dateTaken: map['date_taken'] != null
          ? DateTime.parse(map['date_taken'] as String)
          : null,
      dateAdded: DateTime.parse(map['date_added'] as String),
      md5Hash: map['md5_hash'] as String?,
      isFlagged: map['is_flagged'] == 1,
    );
  }
}
