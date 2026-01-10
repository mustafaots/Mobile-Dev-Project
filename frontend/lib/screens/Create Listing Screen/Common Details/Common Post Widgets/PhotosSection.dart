import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/Common%20Post%20Widgets/ImageGrid.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/Common%20Details/CommonFormLogic.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_vacation/shared/themes.dart';

class PhotosSection extends StatefulWidget {
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

  @override
  State<PhotosSection> createState() => _PhotosSectionState();
}

class _PhotosSectionState extends State<PhotosSection> {
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
                  leading: Icon(
                    Icons.photo_library,
                    color: AppTheme.primaryColor,
                  ),
                  title: Text(AppLocalizations.of(context)!.gallery_option),
                  onTap: () async {
                    Navigator.pop(context);
                    await widget.formController.pickImage(ImageSource.gallery);
                    widget.onUpdate();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                  title: Text(AppLocalizations.of(context)!.camera_option),
                  onTap: () async {
                    Navigator.pop(context);
                    await widget.formController.pickImage(ImageSource.camera);
                    widget.onUpdate();
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
    final loc = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.secondaryTextColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.photo_library_outlined,
                color: widget.categoryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                loc.photos_section_title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                ),
              ),
              if (widget.formController.selectedImages.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.formController.selectedImages.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.categoryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            loc.photos_description,
            style: TextStyle(fontSize: 14, color: widget.secondaryTextColor),
          ),
          const SizedBox(height: 16),
          ImageGrid(
            key: ValueKey(widget.formController.selectedImages.length),
            selectedImages: widget.formController.selectedImages,
            onRemoveImage: (index) {
              widget.formController.removeImage(index);
              setState(() {});
              widget.onUpdate();
            },
            onAddImage: () => _showImageSourceBottomSheet(context),
            categoryColor: widget.categoryColor,
          ),
        ],
      ),
    );
  }
}
