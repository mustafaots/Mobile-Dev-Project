import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/post_images.model.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'image_gallery_state.dart';

class ImageGalleryCubit extends Cubit<ImageGalleryState> {
  final PostImagesRepository imagesRepository;

  ImageGalleryCubit({required this.imagesRepository})
    : super(const ImageGalleryInitial());

  /// Load images for a specific post
  Future<void> loadImages(int postId) async {
    emit(const ImageGalleryLoading());
    try {
      // Fetch all images for the post
      final imageDataList = await imagesRepository.getAllImagesByPostId(postId);

      if (imageDataList.isEmpty) {
        // If no images found, emit loaded with empty list
        emit(const ImageGalleryLoaded(images: []));
        return;
      }

      // Convert raw image data to PostImage objects with Base64 encoding
      final images = imageDataList
          .map((imageData) => PostImage.fromMap(imageData))
          .toList();

      emit(ImageGalleryLoaded(images: images));
    } catch (e) {
      emit(ImageGalleryError('Failed to load images: ${e.toString()}'));
    }
  }

  /// Get images as list
  List<PostImage> getImages() {
    if (state is! ImageGalleryLoaded) return [];
    final currentState = state as ImageGalleryLoaded;
    return currentState.images;
  }

  /// Get image count
  int getImageCount() {
    if (state is! ImageGalleryLoaded) return 0;
    final currentState = state as ImageGalleryLoaded;
    return currentState.images.length;
  }

  /// Get first image
  PostImage? getFirstImage() {
    if (state is! ImageGalleryLoaded) return null;
    final currentState = state as ImageGalleryLoaded;
    return currentState.images.isNotEmpty ? currentState.images.first : null;
  }

  /// Get image by index
  PostImage? getImageByIndex(int index) {
    if (state is! ImageGalleryLoaded) return null;
    final currentState = state as ImageGalleryLoaded;
    if (index >= 0 && index < currentState.images.length) {
      return currentState.images[index];
    }
    return null;
  }

  /// Check if images are available
  bool hasImages() {
    if (state is! ImageGalleryLoaded) return false;
    final currentState = state as ImageGalleryLoaded;
    return currentState.images.isNotEmpty;
  }
}
