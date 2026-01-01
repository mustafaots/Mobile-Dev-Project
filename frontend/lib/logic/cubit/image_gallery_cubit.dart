import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/models/post_images.model.dart';
import 'package:easy_vacation/repositories/db_repositories/images_repository.dart';
import 'package:easy_vacation/services/sync/sync_manager.dart';
import 'image_gallery_state.dart';

class ImageGalleryCubit extends Cubit<ImageGalleryState> {
  final PostImagesRepository imagesRepository;

  ImageGalleryCubit({required this.imagesRepository})
    : super(const ImageGalleryInitial());

  /// Load images for a specific post
  Future<void> loadImages(int postId) async {
    emit(const ImageGalleryLoading());
    try {
      // First try to fetch from local database
      final imageDataList = await imagesRepository.getAllImagesByPostId(postId);

      if (imageDataList.isNotEmpty) {
        // Convert raw image data to PostImage objects with Base64 encoding
        final images = imageDataList
            .map((imageData) => PostImage.fromMap(imageData))
            .toList();

        emit(ImageGalleryLoaded(images: images));
        return;
      }

      // If no local images, try to fetch from API
      try {
        final listingSyncService = SyncManager.instance.listings;
        final listing = await listingSyncService.getListingById(postId, forceRefresh: true);
        
        if (listing != null && listing.images.isNotEmpty) {
          print('ImageGalleryCubit: Loaded ${listing.images.length} images from API for post $postId');
          emit(ImageGalleryLoaded(imageUrls: listing.images));
          return;
        }
      } catch (e) {
        // API fetch failed, continue with empty images
        print('ImageGalleryCubit: Failed to fetch from API: $e');
      }

      // No images found anywhere
      emit(const ImageGalleryLoaded(images: [], imageUrls: []));
    } catch (e) {
      emit(ImageGalleryError('Failed to load images: ${e.toString()}'));
    }
  }

  /// Load images directly from URLs (for when we already have the URLs)
  void loadImageUrls(List<String> urls) {
    emit(ImageGalleryLoaded(imageUrls: urls));
  }

  /// Get images as list
  List<PostImage> getImages() {
    if (state is! ImageGalleryLoaded) return [];
    final currentState = state as ImageGalleryLoaded;
    return currentState.images;
  }

  /// Get image URLs
  List<String> getImageUrls() {
    if (state is! ImageGalleryLoaded) return [];
    final currentState = state as ImageGalleryLoaded;
    return currentState.imageUrls;
  }

  /// Get image count
  int getImageCount() {
    if (state is! ImageGalleryLoaded) return 0;
    final currentState = state as ImageGalleryLoaded;
    return currentState.imageCount;
  }

  /// Get first image
  PostImage? getFirstImage() {
    if (state is! ImageGalleryLoaded) return null;
    final currentState = state as ImageGalleryLoaded;
    return currentState.images.isNotEmpty ? currentState.images.first : null;
  }

  /// Get first image URL
  String? getFirstImageUrl() {
    if (state is! ImageGalleryLoaded) return null;
    final currentState = state as ImageGalleryLoaded;
    return currentState.imageUrls.isNotEmpty ? currentState.imageUrls.first : null;
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
    return currentState.hasImages;
  }
}
