import 'dart:async';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/screens/ConfirmListingScreen.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/MapLocationPicker.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class CommonDetailsScreen extends StatefulWidget {
  final CreatePostData postData;

  const CommonDetailsScreen({required this.postData, super.key});

  @override
  State<CommonDetailsScreen> createState() => _CommonDetailsScreenState();
}

class _CommonDetailsScreenState extends State<CommonDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _wilayaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];
  
  double? _selectedLatitude;
  double? _selectedLongitude;
  List<AvailabilityInterval> _availabilityIntervals = [];

  // Lists
  final List<String> _wilayas = [
    'Alger', 'Oran', 'Constantine', 'Annaba', 'Blida', 'Batna', 'Sétif',
    'Chlef', 'Djelfa', 'Tébessa', 'Ouargla', 'Béjaïa', 'Skikda', 'Tizi Ouzou',
    'Algiers', 'Sidi Bel Abbès', 'Biskra', 'Tébessa', 'Tiaret', 'Guelma',
    'Mostaganem', 'M\'Sila', 'Saïda', 'El Oued', 'Tlemcen', 'Laghouat',
  ];

  @override
  void initState() {
    super.initState();
    // Load existing data if available
    if (widget.postData.location.wilaya.isNotEmpty) {
      _wilayaController.text = widget.postData.location.wilaya;
      _cityController.text = widget.postData.location.city;
      _addressController.text = widget.postData.location.address;
      _selectedLatitude = widget.postData.location.latitude;
      _selectedLongitude = widget.postData.location.longitude;
    }
    
    _availabilityIntervals = List.from(widget.postData.availability);
    _selectedImages = widget.postData.imagePaths
        .map((path) => XFile(path))
        .toList();
  }

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

  Future<void> _selectLocationOnMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapLocationPicker(
          initialLatitude: _selectedLatitude,
          initialLongitude: _selectedLongitude,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLatitude = result['latitude'];
        _selectedLongitude = result['longitude'];
      });
    }
  }

  Future<void> _addAvailabilityInterval() async {
    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      helpText: 'Select availability period',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.primaryColor,
            colorScheme: ColorScheme.light(primary: AppTheme.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (range != null) {
      final TimeOfDay? startTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppTheme.primaryColor,
              colorScheme: ColorScheme.light(primary: AppTheme.primaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

      final TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 17, minute: 0),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppTheme.primaryColor,
              colorScheme: ColorScheme.light(primary: AppTheme.primaryColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

      if (startTime != null && endTime != null) {
        final startDateTime = DateTime(
          range.start.year,
          range.start.month,
          range.start.day,
          startTime.hour,
          startTime.minute,
        );
        
        final endDateTime = DateTime(
          range.end.year,
          range.end.month,
          range.end.day,
          endTime.hour,
          endTime.minute,
        );

        if (endDateTime.isAfter(startDateTime)) {
          setState(() {
            _availabilityIntervals.add(AvailabilityInterval(
              start: startDateTime,
              end: endDateTime,
            ));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('End time must be after start time')),
          );
        }
      }
    }
  }

  void _removeAvailabilityInterval(int index) {
    setState(() {
      _availabilityIntervals.removeAt(index);
    });
  }

  Widget _buildImageGrid() {
    final secondaryTextColor = context.secondaryTextColor;
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
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
        
        InkWell(
          onTap: () {
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
                          title: Text('Choose from Gallery'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage(ImageSource.gallery);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                          title: Text('Take a Photo'),
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
          },
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

  Widget _buildLocationPreview() {
    final cardColor = context.cardColor;
    final primaryColor = AppTheme.primaryColor;

    return GestureDetector(
      onTap: _selectLocationOnMap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primaryColor.withOpacity(_selectedLatitude == null ? 0.3 : 1.0),
            width: 2,
          ),
          boxShadow: _selectedLatitude != null
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _selectedLatitude == null ? Icons.map : Icons.location_on,
              color: primaryColor,
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              _selectedLatitude == null ? 'Select\nLocation' : 'Location\nSelected',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWilayaDropdown() {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: secondaryTextColor.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButtonFormField<String>(
          value: _wilayaController.text.isNotEmpty ? _wilayaController.text : null,
          decoration: InputDecoration(
            labelText: 'Wilaya',
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(Icons.location_city, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          items: _wilayas.map((wilaya) {
            return DropdownMenuItem<String>(
              value: wilaya,
              child: Text(wilaya, style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _wilayaController.text = value!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select wilaya';
            }
            return null;
          },
          style: TextStyle(color: textColor),
          dropdownColor: cardColor,
          icon: Icon(Icons.arrow_drop_down, color: secondaryTextColor),
        ),
      ),
    );
  }

  Widget _buildAvailabilityList() {
    if (_availabilityIntervals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.secondaryTextColor.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: Text(
            'No availability periods added',
            style: TextStyle(
              color: context.secondaryTextColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _availabilityIntervals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final interval = _availabilityIntervals[index];
        final format = DateFormat('MMM dd, yyyy HH:mm');
        
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${format.format(interval.start)} - ${format.format(interval.end)}',
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: ${interval.end.difference(interval.start).inDays} days',
                      style: TextStyle(
                        color: context.secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeAvailabilityInterval(index),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _validateForm() {
    return _wilayaController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _selectedLatitude != null &&
        _selectedLongitude != null &&
        _availabilityIntervals.isNotEmpty &&
        _selectedImages.isNotEmpty;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields correctly')),
      );
      return;
    }

    // Update post data with common details
    final updatedPostData = CreatePostData(
      category: widget.postData.category,
      title: widget.postData.title,
      description: widget.postData.description,
      price: widget.postData.price,
      priceRate: widget.postData.priceRate,
      location: Location(
        wilaya: _wilayaController.text,
        city: _cityController.text,
        address: _addressController.text,
        latitude: _selectedLatitude,
        longitude: _selectedLongitude,
      ),
      availability: _availabilityIntervals,
      imagePaths: _selectedImages.map((xfile) => xfile.path).toList(),
      stayDetails: widget.postData.stayDetails,
      activityDetails: widget.postData.activityDetails,
      vehicleDetails: widget.postData.vehicleDetails,
    );

    // Navigate to confirmation screen
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmAndPostScreen(//postData: updatedPostData),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    // Determine color based on category
    Color categoryColor;
    switch (widget.postData.category) {
      case 'stay':
        categoryColor = AppTheme.primaryColor;
        break;
      case 'activity':
        categoryColor = AppTheme.successColor;
        break;
      case 'vehicle':
        categoryColor = AppTheme.neutralColor;
        break;
      default:
        categoryColor = AppTheme.primaryColor;
    }

    return Scaffold(
      appBar: App_Bar(context, 'Complete Listing'),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(),
                      color: categoryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Complete Your Listing',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add location, photos, and availability',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // PHOTOS SECTION
            Container(
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
                      if (_selectedImages.isNotEmpty) ...[
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
                            '${_selectedImages.length}',
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
                  _buildImageGrid(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // LOCATION SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: secondaryTextColor.withOpacity(0.2)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: categoryColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Location',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Map Preview
                        _buildLocationPreview(),
                        SizedBox(width: 16),
                        // Location Fields
                        Expanded(
                          child: Column(
                            children: [
                              // Wilaya Dropdown
                              _buildWilayaDropdown(),
                              const SizedBox(height: 16),

                              // City
                              buildFormField(
                                context,
                                controller: _cityController,
                                label: 'City',
                                icon: Icons.location_city,
                                validator: (value) => value == null || value.trim().isEmpty
                                    ? 'Please enter city'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // Address
                              buildFormField(
                                context,
                                controller: _addressController,
                                label: 'Address',
                                icon: Icons.home,
                                validator: (value) => value == null || value.trim().isEmpty
                                    ? 'Please enter address'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Map Selection Button
                    ElevatedButton.icon(
                      onPressed: _selectLocationOnMap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.white,
                        foregroundColor: categoryColor,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: categoryColor.withOpacity(0.3),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.map),
                      label: Text(
                        _selectedLatitude == null
                            ? 'Select Location on Map'
                            : 'Location Selected (${_selectedLatitude!.toStringAsFixed(4)}, ${_selectedLongitude!.toStringAsFixed(4)})',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // AVAILABILITY SECTION
            Container(
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
                      Icon(Icons.calendar_today,
                          color: categoryColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Availability',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add time periods when your listing is available',
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAvailabilityList(),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addAvailabilityInterval,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.white,
                      foregroundColor: categoryColor,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: categoryColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    icon: Icon(Icons.add),
                    label: Text('Add Availability Period'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _validateForm()
                      ? categoryColor
                      : categoryColor.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _validateForm() ? _submitForm : null,
                child: Text(
                  'Review and Submit',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (widget.postData.category) {
      case 'stay':
        return Icons.house_outlined;
      case 'activity':
        return Icons.hiking_outlined;
      case 'vehicle':
        return Icons.directions_car_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}