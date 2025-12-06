import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/Common%20Post%20Widgets/ImageGrid.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/CommonFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_vacation/shared/themes.dart';

class PhotosSection extends StatelessWidget {
  final CommonFormController formController;
  final Color textColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final Color categoryColor;
  final VoidCallback onUpdate;
  
  const PhotosSection({
    Key? key,
    required this.formController,
    required this.textColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.categoryColor,
    required this.onUpdate,
  }) : super(key: key);
  
  Future<void> _showImageSourceBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.photo_library, color: AppTheme.primaryColor),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await formController.pickImage(ImageSource.gallery);
                    onUpdate();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                  title: const Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    await formController.pickImage(ImageSource.camera);
                    onUpdate();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryTextColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_library_outlined,
                  color: categoryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Photos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              if (formController.selectedImages.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${formController.selectedImages.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: categoryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Add photos to make your listing more attractive',
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          ImageGrid(
            selectedImages: formController.selectedImages,
            onRemoveImage: (index) {
              formController.removeImage(index);
              onUpdate();
            },
            onAddImage: () => _showImageSourceBottomSheet(context),
            categoryColor: categoryColor,
          ),
        ],
      ),
    );
  }
}