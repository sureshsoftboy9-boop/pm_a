import 'dart:io';
import 'package:exif/exif.dart';
import 'package:path/path.dart' as path;

class ExifData {
  final String? make;
  final String? model;
  final DateTime? dateTaken;
  final double? focalLength;
  final double? aperture;
  final String? exposureTime;
  final int? iso;
  final String? lens;
  final double? latitude;
  final double? longitude;
  final int? width;
  final int? height;

  ExifData({
    this.make,
    this.model,
    this.dateTaken,
    this.focalLength,
    this.aperture,
    this.exposureTime,
    this.iso,
    this.lens,
    this.latitude,
    this.longitude,
    this.width,
    this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'make': make,
      'model': model,
      'dateTaken': dateTaken?.toIso8601String(),
      'focalLength': focalLength,
      'aperture': aperture,
      'exposureTime': exposureTime,
      'iso': iso,
      'lens': lens,
      'latitude': latitude,
      'longitude': longitude,
      'width': width,
      'height': height,
    };
  }

  static ExifData fromMap(Map<String, dynamic> map) {
    return ExifData(
      make: map['make'],
      model: map['model'],
      dateTaken: map['dateTaken'] != null
          ? DateTime.parse(map['dateTaken'])
          : null,
      focalLength: map['focalLength'],
      aperture: map['aperture'],
      exposureTime: map['exposureTime'],
      iso: map['iso'],
      lens: map['lens'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      width: map['width'],
      height: map['height'],
    );
  }
}

class ExifService {
  Future<ExifData?> readExif(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final data = await readExifFromBytes(bytes);

      DateTime? dateTaken;
      try {
        final dateStr = data['EXIF DateTimeOriginal']?.printable;
        if (dateStr != null) {
          // Parse date in format "YYYY:MM:DD HH:MM:SS"
          final parts = dateStr.split(' ');
          final dateParts = parts[0].split(':');
          final timeParts = parts[1].split(':');
          dateTaken = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
            int.parse(timeParts[2]),
          );
        }
      } catch (e) {
        print('Error parsing date: $e');
      }

      double? focalLength;
      try {
        final focalLengthStr = data['EXIF FocalLength']?.values[0].toString();
        if (focalLengthStr != null) {
          final parts = focalLengthStr.split('/');
          if (parts.length == 2) {
            focalLength = int.parse(parts[0]) / int.parse(parts[1]);
          }
        }
      } catch (e) {
        print('Error parsing focal length: $e');
      }

      double? aperture;
      try {
        final apertureStr = data['EXIF FNumber']?.values[0].toString();
        if (apertureStr != null) {
          final parts = apertureStr.split('/');
          if (parts.length == 2) {
            aperture = int.parse(parts[0]) / int.parse(parts[1]);
          }
        }
      } catch (e) {
        print('Error parsing aperture: $e');
      }

      return ExifData(
        make: data['Image Make']?.printable,
        model: data['Image Model']?.printable,
        dateTaken: dateTaken,
        focalLength: focalLength,
        aperture: aperture,
        exposureTime: data['EXIF ExposureTime']?.printable,
        iso: int.tryParse(data['EXIF ISOSpeedRatings']?.printable ?? ''),
        lens: data['EXIF LensModel']?.printable,
        width: int.tryParse(data['EXIF PixelXDimension']?.printable ?? ''),
        height: int.tryParse(data['EXIF PixelYDimension']?.printable ?? ''),
      );
    } catch (e) {
      print('Error reading EXIF: $e');
      return null;
    }
  }

  Future<bool> writeExif(String imagePath, ExifData exifData) async {
    // Note: The exif package currently doesn't support writing EXIF data
    // This is a placeholder for future implementation
    // You might want to use platform-specific code or a different package
    // to implement EXIF writing functionality
    throw UnimplementedError('Writing EXIF data is not yet supported');
  }

  Future<bool> updateImageDate(String imagePath, DateTime newDate) async {
    // Note: This is a placeholder for actual implementation
    // You'll need to use platform-specific code or a different package
    // to implement date modification
    throw UnimplementedError('Updating image date is not yet supported');
  }

  Future<bool> copyExif(String sourcePath, String destinationPath) async {
    try {
      final exifData = await readExif(sourcePath);
      if (exifData != null) {
        return await writeExif(destinationPath, exifData);
      }
      return false;
    } catch (e) {
      print('Error copying EXIF: $e');
      return false;
    }
  }
}
