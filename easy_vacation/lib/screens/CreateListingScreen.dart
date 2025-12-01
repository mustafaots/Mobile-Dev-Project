import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/screens/ConfirmListingScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateListing extends StatefulWidget {
  const CreateListing({super.key});

  @override
  State<CreateListing> createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];

  String? selectedOption = 'Stay';

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await _picker.pickMultiImage();
        setState(() => _selectedImages.addAll(images));
      } else {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          setState(() => _selectedImages.add(image));
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final cardColor = context.cardColor;
        final textColor = context.textColor;
        
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
                    color: textColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.photo_library, color: AppTheme.primaryColor),
                  title: Text('Choose from Gallery', style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                  title: Text('Take a Photo', style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGrid() {
    final secondaryTextColor = context.secondaryTextColor;
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Display selected images
        ..._selectedImages.asMap().entries.map((entry) {
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
                  onTap: () => _removeImage(index),
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
        
        // Add photo button
        InkWell(
          onTap: _showImageSourceDialog,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final List<Map<String, dynamic>> listingTypes = [
      {
        'type': t.listingType_stay,
        'icon': Icons.house_outlined,
        'color': AppTheme.primaryColor,
      },
      {
        'type': t.listingType_activity,
        'icon': Icons.hiking_outlined,
        'color': AppTheme.successColor,
      },
      {
        'type': t.listingType_vehicle,
        'icon': Icons.directions_car_outlined,
        'color': AppTheme.neutralColor,
      },
    ];

    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    return Scaffold(
      appBar: App_Bar(context, t.appBar_createListing),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 0.3,
            backgroundColor: secondaryTextColor.withOpacity(0.2),
            color: AppTheme.primaryColor,
            minHeight: 3,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: AppTheme.primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t.header_createNewListing,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          t.header_fillDetails,
                          style: TextStyle(
                            fontSize: 16,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // PHOTO SECTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: secondaryTextColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.photo_library_outlined,
                                color: AppTheme.primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              t.photo_addPhotos,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            if (_selectedImages.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_selectedImages.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t.photo_addPhotosDescription,
                          style: TextStyle(
                            fontSize: 14,
                            color: secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildImageGrid(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // LISTING TYPE SECTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: secondaryTextColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.category_outlined,
                                color: AppTheme.primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              t.listingType_title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: listingTypes.map((type) {
                            final isSelected =
                                selectedOption == type['type'];

                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedOption = type['type']),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (type['color'] as Color)
                                          .withOpacity(0.1)
                                      : cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? type['color'] as Color
                                        : secondaryTextColor.withOpacity(0.3),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(type['icon'] as IconData,
                                        color: isSelected
                                            ? type['color'] as Color
                                            : secondaryTextColor,
                                        size: 24),
                                    const SizedBox(height: 8),
                                    Text(
                                      type['type'] as String,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? type['color'] as Color
                                            : textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // FORM SECTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: secondaryTextColor.withOpacity(0.2)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.description_outlined,
                                  color: AppTheme.primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                t.form_listingDetails,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          buildFormField(
                            context,
                            controller: _titleController,
                            label: t.field_title,
                            icon: Icons.title_outlined,
                            validator: (value) => value == null ||
                                    value.trim().isEmpty
                                ? t.field_title_error
                                : null,
                          ),
                          const SizedBox(height: 16),

                          buildFormField(
                            context,
                            controller: _descriptionController,
                            label: t.field_description,
                            icon: Icons.description_outlined,
                            maxLines: 3,
                            validator: (value) => value == null ||
                                    value.trim().isEmpty
                                ? t.field_description_error
                                : null,
                          ),
                          const SizedBox(height: 16),

                          buildFormField(
                            context,
                            controller: _priceController,
                            label: t.field_price,
                            icon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null ||
                                    value.trim().isEmpty
                                ? t.field_price_error
                                : null,
                          ),
                          const SizedBox(height: 16),

                          buildFormField(
                            context,
                            controller: _locationController,
                            label: t.field_location,
                            icon: Icons.location_on_outlined,
                            validator: (value) => value == null ||
                                    value.trim().isEmpty
                                ? t.field_location_error
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // CONTINUE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Upload images to backend here
                          // Example: await uploadImages(_selectedImages);
                          
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const ConfirmAndPostScreen(),
                              transitionsBuilder: (_, animation, __, child) =>
                                  FadeTransition(opacity: animation, child: child),
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t.button_continueToPayment,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// EXAMPLE: Backend integration function (add this outside the class)
// Future<List<String>> uploadImages(List<XFile> images) async {
//   List<String> imageUrls = [];
//   
//   for (var image in images) {
//     // Upload to your backend/storage service
//     // final url = await yourBackendService.uploadImage(File(image.path));
//     // imageUrls.add(url);
//   }
//   
//   return imageUrls;
// }