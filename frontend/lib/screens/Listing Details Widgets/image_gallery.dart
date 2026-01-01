import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_cubit.dart';
import 'package:easy_vacation/logic/cubit/image_gallery_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

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
              child: Center(child: CircularProgressIndicator()),
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
                      'Error: ${state.message}',
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
                      state.imageUrls.length,
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
                      state.images.length,
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

  Widget _buildNetworkImageCard(BuildContext context, String imageUrl, int index, int totalImages) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(right: index < totalImages - 1 ? 12 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
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
                child: Center(child: CircularProgressIndicator()),
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
                  '${index + 1}/$totalImages',
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
  }

  Widget _buildBase64ImageCard(context, image, int index, int totalImages) {
    // Try to decode Base64 image data
    ImageProvider imageProvider;
    try {
      if (image.imageData.isEmpty) {
        imageProvider = AssetImage('assets/images/placeholder.png');
      } else {
        final decodedBytes = base64Decode(image.imageData);
        imageProvider = MemoryImage(decodedBytes);
      }
    } catch (e) {
      // If decoding fails, use placeholder
      imageProvider = AssetImage('assets/images/placeholder.png');
    }

    return Container(
      width: 300,
      margin: EdgeInsets.only(right: index < totalImages - 1 ? 12 : 0),
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
                '${index + 1}/$totalImages',
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
