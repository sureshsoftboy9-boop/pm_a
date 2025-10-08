import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/image_processing_service.dart';
import 'image_processing_event.dart';
import 'image_processing_state.dart';

class ImageProcessingBloc extends Bloc<ImageProcessingEvent, ImageProcessingState> {
  final ImageProcessingService service;

  ImageProcessingBloc({required this.service}) : super(const ImageProcessingState()) {
    on<ResizeImage>(_onResizeImage);
    on<CropImage>(_onCropImage);
    on<RotateImage>(_onRotateImage);
    on<AdjustBrightness>(_onAdjustBrightness);
    on<AdjustContrast>(_onAdjustContrast);
    on<ApplyFilter>(_onApplyFilter);
  }

  Future<void> _onResizeImage(
    ResizeImage event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      emit(state.copyWith(isProcessing: true));
      final processedImage = await service.resizeImage(
        event.image,
        event.width,
        event.height,
      );
      emit(state.copyWith(
        processedImage: processedImage,
        isProcessing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isProcessing: false,
      ));
    }
  }

  Future<void> _onCropImage(
    CropImage event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      emit(state.copyWith(isProcessing: true));
      final processedImage = await service.cropImage(
        event.image,
        event.x,
        event.y,
        event.width,
        event.height,
      );
      emit(state.copyWith(
        processedImage: processedImage,
        isProcessing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isProcessing: false,
      ));
    }
  }

  Future<void> _onRotateImage(
    RotateImage event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      emit(state.copyWith(isProcessing: true));
      final processedImage = await service.rotateImage(
        event.image,
        event.degrees,
      );
      emit(state.copyWith(
        processedImage: processedImage,
        isProcessing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isProcessing: false,
      ));
    }
  }

  Future<void> _onAdjustBrightness(
    AdjustBrightness event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      emit(state.copyWith(isProcessing: true));
      final processedImage = await service.adjustBrightness(
        event.image,
        event.amount,
      );
      emit(state.copyWith(
        processedImage: processedImage,
        isProcessing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isProcessing: false,
      ));
    }
  }

  Future<void> _onAdjustContrast(
    AdjustContrast event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      emit(state.copyWith(isProcessing: true));
      final processedImage = await service.adjustContrast(
        event.image,
        event.amount,
      );
      emit(state.copyWith(
        processedImage: processedImage,
        isProcessing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isProcessing: false,
      ));
    }
  }

  Future<void> _onApplyFilter(
    ApplyFilter event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      emit(state.copyWith(isProcessing: true));
      final processedImage = await service.applyFilter(
        event.image,
        event.filterType,
      );
      emit(state.copyWith(
        processedImage: processedImage,
        isProcessing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isProcessing: false,
      ));
    }
  }
}
