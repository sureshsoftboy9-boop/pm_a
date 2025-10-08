import 'package:equatable/equatable.dart';
import 'dart:io';
import '../services/image_processing_service.dart';

abstract class ImageProcessingEvent extends Equatable {
  const ImageProcessingEvent();

  @override
  List<Object> get props => [];
}

class ResizeImage extends ImageProcessingEvent {
  final File image;
  final int width;
  final int height;

  const ResizeImage({
    required this.image,
    required this.width,
    required this.height,
  });

  @override
  List<Object> get props => [image, width, height];
}

class CropImage extends ImageProcessingEvent {
  final File image;
  final int x;
  final int y;
  final int width;
  final int height;

  const CropImage({
    required this.image,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  @override
  List<Object> get props => [image, x, y, width, height];
}

class RotateImage extends ImageProcessingEvent {
  final File image;
  final int degrees;

  const RotateImage({
    required this.image,
    required this.degrees,
  });

  @override
  List<Object> get props => [image, degrees];
}

class AdjustBrightness extends ImageProcessingEvent {
  final File image;
  final int amount;

  const AdjustBrightness({
    required this.image,
    required this.amount,
  });

  @override
  List<Object> get props => [image, amount];
}

class AdjustContrast extends ImageProcessingEvent {
  final File image;
  final int amount;

  const AdjustContrast({
    required this.image,
    required this.amount,
  });

  @override
  List<Object> get props => [image, amount];
}

class ApplyFilter extends ImageProcessingEvent {
  final File image;
  final FilterType filterType;

  const ApplyFilter({
    required this.image,
    required this.filterType,
  });

  @override
  List<Object> get props => [image, filterType];
}
