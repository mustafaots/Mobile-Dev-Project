import 'package:easy_vacation/models/post_images.model.dart';

abstract class ImageGalleryState {
  const ImageGalleryState();
}

class ImageGalleryInitial extends ImageGalleryState {
  const ImageGalleryInitial();
}

class ImageGalleryLoading extends ImageGalleryState {
  const ImageGalleryLoading();
}

class ImageGalleryLoaded extends ImageGalleryState {
  final List<PostImage> images;
  final List<String> imageUrls; // For remote Cloudinary URLs

  const ImageGalleryLoaded({
    this.images = const [],
    this.imageUrls = const [],
  });

  bool get hasImages => images.isNotEmpty || imageUrls.isNotEmpty;
  int get imageCount => imageUrls.isNotEmpty ? imageUrls.length : images.length;

  ImageGalleryLoaded copyWith({
    List<PostImage>? images,
    List<String>? imageUrls,
  }) {
    return ImageGalleryLoaded(
      images: images ?? this.images,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

class ImageGalleryError extends ImageGalleryState {
  final String message;

  const ImageGalleryError(this.message);
}
