import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class ImageProcessingService {
  Future<File> resizeImage(File imageFile, int width, int height) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) throw Exception('Failed to decode image');

    final resized = img.copyResize(image, width: width, height: height);
    
    final outputPath = _generateOutputPath(imageFile.path, 'resized');
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodeJpg(resized));
    
    return outputFile;
  }

  Future<File> cropImage(File imageFile, int x, int y, int width, int height) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) throw Exception('Failed to decode image');

    final cropped = img.copyCrop(image, x: x, y: y, width: width, height: height);
    
    final outputPath = _generateOutputPath(imageFile.path, 'cropped');
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodeJpg(cropped));
    
    return outputFile;
  }

  Future<File> rotateImage(File imageFile, int degrees) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) throw Exception('Failed to decode image');

    final rotated = img.copyRotate(image, angle: degrees);
    
    final outputPath = _generateOutputPath(imageFile.path, 'rotated');
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodeJpg(rotated));
    
    return outputFile;
  }

  Future<File> adjustBrightness(File imageFile, int amount) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) throw Exception('Failed to decode image');

    final adjusted = img.brightness(image, amount);
    
    final outputPath = _generateOutputPath(imageFile.path, 'brightness');
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodeJpg(adjusted));
    
    return outputFile;
  }

  Future<File> adjustContrast(File imageFile, int amount) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) throw Exception('Failed to decode image');

    final adjusted = img.contrast(image, amount);
    
    final outputPath = _generateOutputPath(imageFile.path, 'contrast');
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodeJpg(adjusted));
    
    return outputFile;
  }

  Future<File> applyFilter(File imageFile, FilterType filterType) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) throw Exception('Failed to decode image');

    late img.Image filtered;
    switch (filterType) {
      case FilterType.grayscale:
        filtered = img.grayscale(image);
        break;
      case FilterType.sepia:
        filtered = img.sepia(image);
        break;
      case FilterType.invert:
        filtered = img.invert(image);
        break;
    }
    
    final outputPath = _generateOutputPath(imageFile.path, filterType.toString().split('.').last);
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(img.encodeJpg(filtered));
    
    return outputFile;
  }

  String _generateOutputPath(String originalPath, String modification) {
    final dir = path.dirname(originalPath);
    final filename = path.basenameWithoutExtension(originalPath);
    final extension = path.extension(originalPath);
    return path.join(dir, '${filename}_$modification$extension');
  }
}

enum FilterType {
  grayscale,
  sepia,
  invert,
}
