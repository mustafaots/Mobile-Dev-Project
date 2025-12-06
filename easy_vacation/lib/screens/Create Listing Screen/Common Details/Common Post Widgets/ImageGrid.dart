import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageGrid extends StatelessWidget {
  final List<XFile> selectedImages;
  final Function(int) onRemoveImage;
  final VoidCallback onAddImage;
  final Color categoryColor;
  
  const ImageGrid({
    Key? key,
    required this.selectedImages,
    required this.onRemoveImage,
    required this.onAddImage,
    required this.categoryColor,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ...selectedImages.asMap().entries.map((entry) {
          final index = entry.key;
          final image = entry.value;
          
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(image.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => onRemoveImage(index),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        
        InkWell(
          onTap: onAddImage,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: categoryColor.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo,
                  color: categoryColor,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 12,
                    color: categoryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}