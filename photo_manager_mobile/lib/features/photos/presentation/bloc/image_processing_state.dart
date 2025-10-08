import 'package:equatable/equatable.dart';
import 'dart:io';

class ImageProcessingState extends Equatable {
  final File? processedImage;
  final bool isProcessing;
  final String? error;

  const ImageProcessingState({
    this.processedImage,
    this.isProcessing = false,
    this.error,
  });

  ImageProcessingState copyWith({
    File? processedImage,
    bool? isProcessing,
    String? error,
  }) {
    return ImageProcessingState(
      processedImage: processedImage ?? this.processedImage,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
    );
  }

  @override
  List<Object?> get props => [processedImage, isProcessing, error];
}
