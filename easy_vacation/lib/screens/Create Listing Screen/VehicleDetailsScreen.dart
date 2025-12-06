import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/locations.model.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/CommonDetailsScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:flutter/material.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final CreatePostData? existingData;

  const VehicleDetailsScreen({this.existingData, super.key});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  
  String _selectedPriceRate = 'day';
  String? _selectedVehicleType;
  String? _selectedFuelType;
  bool _isAutomaticTransmission = false;
  
  final List<String> _priceRates = ['hour', 'day', 'week', 'month'];
  final List<String> _vehicleTypes = ['car', 'motorcycle', 'bicycle', 'boat', 'scooter'];
  final List<String> _fuelTypes = ['gasoline', 'diesel', 'electric', 'hybrid'];

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _loadExistingData();
    }
    _seatsController.text = '5';
  }

  void _loadExistingData() {
    final data = widget.existingData!;
    _titleController.text = data.title;
    _descriptionController.text = data.description;
    _priceController.text = data.price.toString();
    _selectedPriceRate = data.priceRate;
    
    if (data.vehicleDetails != null) {
      final vehicle = data.vehicleDetails!;
      _selectedVehicleType = vehicle.vehicleType;
      _modelController.text = vehicle.model;
      _yearController.text = vehicle.year.toString();
      _selectedFuelType = vehicle.fuelType;
      _isAutomaticTransmission = vehicle.transmission;
      _seatsController.text = vehicle.seats.toString();
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
            labelText: AppLocalizations.of(context)!.rate_label,
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
              return AppLocalizations.of(context)!.rate_error;
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

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
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
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(icon, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item.capitalize(), style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
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
        _selectedVehicleType != null &&
        _modelController.text.isNotEmpty &&
        _yearController.text.isNotEmpty &&
        _selectedFuelType != null &&
        _seatsController.text.isNotEmpty;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.form_error_fill_all)),
      );
      return;
    }

    // Create VehicleDetails
    final vehicleDetails = VehicleDetails(
      vehicleType: _selectedVehicleType!,
      model: _modelController.text,
      year: int.parse(_yearController.text),
      fuelType: _selectedFuelType!,
      transmission: _isAutomaticTransmission,
      seats: int.parse(_seatsController.text),
      features: null,
    );

    // Create partial post data
    final postData = CreatePostData(
      category: 'vehicle',
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      priceRate: _selectedPriceRate,
      location: widget.existingData?.location ?? Location(wilaya: '', city: '', address: '', latitude: 0, longitude: 0),
      availability: widget.existingData?.availability ?? [],
      imagePaths: widget.existingData?.imagePaths ?? [],
      stayDetails: null,
      activityDetails: null,
      vehicleDetails: vehicleDetails,
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
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: App_Bar(context, loc.vehicle_details_title),
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
                      color: AppTheme.neutralColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.directions_car_outlined,
                      color: AppTheme.neutralColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.vehicle_details_title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.vehicle_details_subtitle,
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
                            label: loc.price_label,
                            icon: Icons.money,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return loc.price_error_required;
                              }
                              if (double.tryParse(value) == null) {
                                return loc.price_error_invalid;
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

                    // Vehicle Type
                    _buildDropdownField(
                      label: loc.vehicle_type_label,
                      icon: Icons.directions_car,
                      items: _vehicleTypes,
                      value: _selectedVehicleType,
                      onChanged: (value) {
                        setState(() => _selectedVehicleType = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.vehicle_type_error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Model
                    buildFormField(
                      context,
                      controller: _modelController,
                      label: loc.model_label,
                      icon: Icons.badge,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.model_error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Year
                    buildFormField(
                      context,
                      controller: _yearController,
                      label: loc.year_label,
                      icon: Icons.calendar_today,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.year_error_empty;
                        }
                        if (int.tryParse(value) == null) {
                          return loc.year_error_invalid;
                        }
                        final year = int.parse(value);
                        if (year < 1900 || year > DateTime.now().year + 1) {
                          return loc.year_error_range(DateTime.now().year + 1);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Fuel Type
                    _buildDropdownField(
                      label: loc.fuel_type_label,
                      icon: Icons.local_gas_station,
                      items: _fuelTypes,
                      value: _selectedFuelType,
                      onChanged: (value) {
                        setState(() => _selectedFuelType = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.fuel_type_error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Transmission
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.neutralColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.settings, color: AppTheme.neutralColor, size: 20),
                              SizedBox(width: 8),
                              Text(
                                loc.transmission_label,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ChoiceChip(
                                label: Text(loc.transmission_manual),
                                selected: !_isAutomaticTransmission,
                                selectedColor: AppTheme.neutralColor,
                                onSelected: (selected) {
                                  setState(() {
                                    _isAutomaticTransmission = !selected;
                                  });
                                },
                              ),
                              ChoiceChip(
                                label: Text(loc.transmission_automatic),
                                selected: _isAutomaticTransmission,
                                selectedColor: AppTheme.neutralColor,
                                onSelected: (selected) {
                                  setState(() {
                                    _isAutomaticTransmission = selected;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Number of Seats
                    buildFormField(
                      context,
                      controller: _seatsController,
                      label: loc.seats_label,
                      icon: Icons.airline_seat_recline_normal,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return loc.seats_error_empty;
                        }
                        if (int.tryParse(value) == null) {
                          return loc.seats_error_invalid;
                        }
                        final seats = int.parse(value);
                        if (seats < 1 || seats > 100) {
                          return loc.seats_error_range;
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
                      ? AppTheme.neutralColor
                      : AppTheme.neutralColor.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _validateForm() ? _submitForm : null,
                child: Text(
                  loc.continue_button,
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