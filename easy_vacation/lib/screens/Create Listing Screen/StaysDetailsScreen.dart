import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/locations.model.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/CommonDetailsScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:flutter/material.dart';

class StayDetailsScreen extends StatefulWidget {
  final CreatePostData? existingData;

  const StayDetailsScreen({this.existingData, super.key});

  @override
  State<StayDetailsScreen> createState() => _StayDetailsScreenState();
}

class _StayDetailsScreenState extends State<StayDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  
  String _selectedPriceRate = 'day';
  String? _selectedStayType;
  
  final List<String> _priceRates = ['hour', 'day', 'week', 'month'];
  final List<String> _stayTypes = ['apartment', 'villa', 'house', 'room', 'chalet'];

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final data = widget.existingData!;
    _titleController.text = data.title;
    _descriptionController.text = data.description;
    _priceController.text = data.price.toString();
    _selectedPriceRate = data.priceRate;
    
    if (data.stayDetails != null) {
      _selectedStayType = data.stayDetails!.stayType;
      _areaController.text = data.stayDetails!.area.toString();
      _bedroomsController.text = data.stayDetails!.bedrooms.toString();
    }
  }

  Widget _buildRateDropdown() {
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
          value: _selectedPriceRate,
          decoration: InputDecoration(
            labelText: 'Rate',
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(Icons.schedule, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          items: _priceRates.map((rate) {
            return DropdownMenuItem<String>(
              value: rate,
              child: Text('/$rate', style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedPriceRate = value!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select rate';
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

  Widget _buildStayTypeDropdown() {
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
          value: _selectedStayType,
          decoration: InputDecoration(
            labelText: 'Stay Type',
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(Icons.home_work_outlined, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          items: _stayTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type.capitalize(), style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedStayType = value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select stay type';
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

  bool _validateForm() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _selectedStayType != null &&
        _areaController.text.isNotEmpty &&
        _bedroomsController.text.isNotEmpty;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields correctly')),
      );
      return;
    }

    // Create StayDetails
    final stayDetails = StayDetails(
      stayType: _selectedStayType!,
      area: double.parse(_areaController.text),
      bedrooms: int.parse(_bedroomsController.text),
    );

    // Create partial post data
    final postData = CreatePostData(
      category: 'stay',
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      priceRate: _selectedPriceRate,
      location: widget.existingData?.location ?? Location(wilaya: '', city: '', address: '', latitude: 0, longitude: 0),
      availability: widget.existingData?.availability ?? [],
      imagePaths: widget.existingData?.imagePaths ?? [],
      stayDetails: stayDetails,
      activityDetails: null,
      vehicleDetails: null,
    );

    // Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommonDetailsScreen(postData: postData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final backgroundColor = context.scaffoldBackgroundColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    return Scaffold(
      appBar: App_Bar(context, 'Stay Details'),
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
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.house_outlined,
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Stay Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provide details about your stay',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Form
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
                    buildFormField(
                      context,
                      controller: _titleController,
                      label: t.field_title,
                      icon: Icons.title_outlined,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? t.field_title_error
                          : null,
                    ),
                    const SizedBox(height: 16),

                    buildFormField(
                      context,
                      controller: _descriptionController,
                      label: t.field_description,
                      icon: Icons.description_outlined,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? t.field_description_error
                          : null,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Price and Rate
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: buildFormField(
                            context,
                            controller: _priceController,
                            label: 'Price (DA)',
                            icon: Icons.money,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter price';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: _buildRateDropdown(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Stay Type
                    _buildStayTypeDropdown(),
                    const SizedBox(height: 16),

                    // Area
                    buildFormField(
                      context,
                      controller: _areaController,
                      label: 'Area (m²)',
                      icon: Icons.square_foot,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter area';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Bedrooms
                    buildFormField(
                      context,
                      controller: _bedroomsController,
                      label: 'Number of Bedrooms',
                      icon: Icons.bed,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter number of bedrooms';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _validateForm()
                      ? AppTheme.primaryColor
                      : AppTheme.primaryColor.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _validateForm() ? _submitForm : null,
                child: Text(
                  'Continue to Location',
                  style: const TextStyle(
                    fontSize: 18,
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
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}