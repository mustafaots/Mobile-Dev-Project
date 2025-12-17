import 'dart:io';
import 'dart:typed_data';
import 'package:easy_vacation/screens/Listings%20History/PostHelpers.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? imagePath;
  final String category;

  const PostImage({
    super.key,
    this.imageBytes,
    this.imagePath,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final postHelpers = PostHelpers(context);
    
    // Try to show image from bytes first
    if (imageBytes != null && imageBytes!.isNotEmpty) {
      return _buildImageFromBytes();
    }
    
    // Try to show image from file path
    if (imagePath != null && imagePath!.isNotEmpty) {
      return _buildImageFromFile();
    }
    
    // If no image available, show placeholder
    return postHelpers.buildImagePlaceholder(category);
  }

  Widget _buildImageFromBytes() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Image.memory(
        imageBytes!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('❌ Error displaying image from bytes: $error');
          return _buildErrorPlaceholder();
        },
      ),
    );
  }

  Widget _buildImageFromFile() {
    final file = File(imagePath!);
    if (file.existsSync()) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: Image.file(
          file,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('❌ Error displaying image from file: $error');
            return _buildErrorPlaceholder();
          },
        ),
      );
    }
    return _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.neutralColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.broken_image,
          size: 48,
          color: AppTheme.neutralColor,
        ),
      ),
    );
  }
}