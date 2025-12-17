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

  const ImageGalleryLoaded({required this.images});

  ImageGalleryLoaded copyWith({List<PostImage>? images}) {
    return ImageGalleryLoaded(images: images ?? this.images);
  }
}

class ImageGalleryError extends ImageGalleryState {
  final String message;

  const ImageGalleryError(this.message);
}
