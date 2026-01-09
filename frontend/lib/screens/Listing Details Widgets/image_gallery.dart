import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_cubit.dart';
import 'package:easy_vacation/shared/ui_widgets/app_progress_indicator.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_state.dart';
import 'package:easy_vacation/utils/error_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'dart:typed_data';

class ImageGallery extends StatelessWidget {
  final int? postId;
  final ImageGalleryCubit? cubit;

  const ImageGallery({super.key, this.postId, this.cubit});

  @override
  Widget build(BuildContext context) {
    // If cubit is provided, use BlocBuilder to listen to state changes
    if (cubit != null) {
      return BlocBuilder<ImageGalleryCubit, ImageGalleryState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is ImageGalleryLoading) {
            return SizedBox(
              height: 200,
              child: Center(child: AppProgressIndicator()),
            );
          }

          if (state is ImageGalleryError) {
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 40, color: Colors.red),
                    SizedBox(height: 8),
                    Text(
                      ErrorHelper.getLocalizedMessageFromString(state.message, context),
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ImageGalleryLoaded) {
            // Check if we have URL images (from API)
            if (state.imageUrls.isNotEmpty) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.imageUrls.length,
                  itemBuilder: (context, index) {
                    final imageUrl = state.imageUrls[index];
                    return _buildNetworkImageCard(
                      context,
                      imageUrl,
                      index,
                      state.imageUrls,
                    );
                  },
                ),
              );
            }

            // Check if we have local Base64 images
            if (state.images.isNotEmpty) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.images.length,
                  itemBuilder: (context, index) {
                    final image = state.images[index];
                    return _buildBase64ImageCard(
                      context,
                      image,
                      index,
                      state.images,
                    );
                  },
                ),
              );
            }

            // No images available
            return SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text('No images available'),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      );
    }

    // Fallback: Display placeholder images
    return _buildPlaceholderGallery();
  }

  Widget _buildNetworkImageCard(BuildContext context, String imageUrl, int index, List<String> allImageUrls) {
    return Builder(
      builder: (innerContext) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            showDialog(
              context: innerContext,
              barrierColor: Colors.black.withOpacity(0.9),
              barrierDismissible: true,
              useRootNavigator: true,
              builder: (dialogContext) {
                return _ImageOverlay(
                  imageUrls: allImageUrls,
                  imageBytesList: null,
                  initialIndex: index,
                );
              },
            );
          },
          child: Container(
            width: 300,
            margin: EdgeInsets.only(right: index < allImageUrls.length - 1 ? 12 : 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: Center(child: AppProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                  // Image count badge at top-right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${index + 1}/${allImageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBase64ImageCard(context, image, int index, List<dynamic> allImages) {
    // Try to decode Base64 image data
    ImageProvider imageProvider;
    Uint8List? decodedBytes;
    try {
      if (image.imageData.isEmpty) {
        imageProvider = AssetImage('assets/images/placeholder.png');
      } else {
        decodedBytes = base64Decode(image.imageData);
        imageProvider = MemoryImage(decodedBytes);
      }
    } catch (e) {
      // If decoding fails, use placeholder
      imageProvider = AssetImage('assets/images/placeholder.png');
    }

    // Pre-decode all images for the overlay
    List<Uint8List> allDecodedBytes = [];
    for (var img in allImages) {
      try {
        if (img.imageData.isNotEmpty) {
          allDecodedBytes.add(base64Decode(img.imageData));
        }
      } catch (e) {
        // Skip failed decodes
      }
    }

    return Builder(
      builder: (innerContext) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            showDialog(
              context: innerContext,
              barrierColor: Colors.black.withOpacity(0.9),
              barrierDismissible: true,
              useRootNavigator: true,
              builder: (dialogContext) {
                return _ImageOverlay(
                  imageUrls: null,
                  imageBytesList: allDecodedBytes,
                  initialIndex: index,
                );
              },
            );
          },
          child: Container(
            width: 300,
            margin: EdgeInsets.only(right: index < allImages.length - 1 ? 12 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
            child: Stack(
              children: [
                // Image count badge at top-right
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}/${allImages.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderGallery() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          final images = const [
            {
              'path': 'assets/images/beachfront_cottage.jpg',
              'alt': 'A beautiful beachfront cottage with a porch',
            },
            {
              'path': 'assets/images/living_room.jpg',
              'alt': 'The cozy living room of the cottage with a fireplace',
            },
            {
              'path': 'assets/images/bedroom_ocean_view.jpg',
              'alt': 'A bedroom with a view of the ocean',
            },
          ];
          return Container(
            width: 300,
            margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(images[index]['path']!),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ImageOverlay extends StatefulWidget {
  final List<String>? imageUrls;
  final List<Uint8List>? imageBytesList;
  final int initialIndex;

  const _ImageOverlay({
    this.imageUrls,
    this.imageBytesList,
    required this.initialIndex,
  });

  @override
  State<_ImageOverlay> createState() => _ImageOverlayState();
}

class _ImageOverlayState extends State<_ImageOverlay> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalImages {
    if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) {
      return widget.imageUrls!.length;
    } else if (widget.imageBytesList != null && widget.imageBytesList!.isNotEmpty) {
      return widget.imageBytesList!.length;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // PageView for swiping between images
          PageView.builder(
            controller: _pageController,
            itemCount: _totalImages,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: _buildImageAt(index),
                  ),
                ),
              );
            },
          ),
          // Close button at top-right
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          // Image count badge at bottom
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1} / $_totalImages',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageAt(int index) {
    if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.imageUrls![index],
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: AppProgressIndicator(color: Colors.white),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          color: Colors.red,
          size: 48,
        ),
      );
    } else if (widget.imageBytesList != null && widget.imageBytesList!.isNotEmpty) {
      return Image.memory(
        widget.imageBytesList![index],
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.contain,
      );
    }
  }
}
