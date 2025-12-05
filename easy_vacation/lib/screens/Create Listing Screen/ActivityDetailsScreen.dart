import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/locations.model.dart';
import 'package:easy_vacation/screens/Create%20Listing%20Screen/CommonDetailsScreen.dart';
import 'package:easy_vacation/shared/themes.dart';
import 'package:easy_vacation/shared/theme_helper.dart';
import 'package:easy_vacation/shared/ui_widgets/App_Bar.dart';
import 'package:easy_vacation/shared/ui_widgets/FormField.dart';
import 'package:flutter/material.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final CreatePostData? existingData;

  const ActivityDetailsScreen({this.existingData, super.key});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _activityTypeController = TextEditingController();
  
  // Requirements controllers
  final TextEditingController _minAgeController = TextEditingController();
  final TextEditingController _equipmentController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _groupSizeController = TextEditingController();
  final List<MapEntry<String, String>> _customRequirements = [];
  final TextEditingController _customKeyController = TextEditingController();
  final TextEditingController _customValueController = TextEditingController();
  
  String _selectedPriceRate = 'hour';
  final List<String> _priceRates = ['hour', 'day', 'week', 'month'];
  
  // Equipment options
  final List<String> _equipmentOptions = [
    'provided',
    'bring your own',
    'partial',
    'not needed'
  ];
  
  // Experience level options
  final List<String> _experienceOptions = [
    'beginner',
    'intermediate',
    'advanced',
    'expert'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _loadExistingData();
    } else {
      // Set default values
      _minAgeController.text = '18';
      _equipmentController.text = 'provided';
      _experienceController.text = 'beginner';
      _durationController.text = '2';
      _groupSizeController.text = '10';
    }
  }

  // Replace the _loadExistingData() method with this fixed version:

  void _loadExistingData() {
    final data = widget.existingData!;
    _titleController.text = data.title;
    _descriptionController.text = data.description;
    _priceController.text = data.price.toString();
    _selectedPriceRate = data.priceRate;
    
    if (data.activityDetails != null) {
      _activityTypeController.text = data.activityDetails!.activityType;
      final requirements = data.activityDetails!.requirements;
      
      // Load requirements from JSON
      _minAgeController.text = requirements['min_age']?.toString() ?? '18';
      
      // FIXED: Ensure equipment value exists in options
      final equipment = requirements['equipment']?.toString().toLowerCase() ?? 'provided';
      _equipmentController.text = _equipmentOptions.contains(equipment) 
          ? equipment 
          : 'provided';
      
      // FIXED: Ensure experience value exists in options
      final experience = requirements['experience_level']?.toString().toLowerCase() ?? 'beginner';
      _experienceController.text = _experienceOptions.contains(experience) 
          ? experience 
          : 'beginner';
      
      _durationController.text = requirements['duration_hours']?.toString() ?? '2';
      _groupSizeController.text = requirements['max_group_size']?.toString() ?? '10';
      
      // Load custom requirements
      _customRequirements.clear();
      requirements.forEach((key, value) {
        if (!_isStandardRequirement(key)) {
          _customRequirements.add(MapEntry(key, value.toString()));
        }
      });
    }
  }

  // Also update _buildEquipmentDropdown() to handle null safely:

  Widget _buildEquipmentDropdown() {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    // FIXED: Ensure value is valid
    final currentValue = _equipmentOptions.contains(_equipmentController.text)
        ? _equipmentController.text
        : 'provided';

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
          value: currentValue,
          decoration: InputDecoration(
            labelText: 'Equipment',
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(Icons.build, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          items: _equipmentOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option, style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _equipmentController.text = value!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select equipment option';
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

  // And update _buildExperienceDropdown() similarly:

  Widget _buildExperienceDropdown() {
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;
    final cardColor = context.cardColor;

    // FIXED: Ensure value is valid
    final currentValue = _experienceOptions.contains(_experienceController.text)
        ? _experienceController.text
        : 'beginner';

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
          value: currentValue,
          decoration: InputDecoration(
            labelText: 'Experience Level',
            labelStyle: TextStyle(color: secondaryTextColor),
            border: InputBorder.none,
            icon: Icon(Icons.school, color: secondaryTextColor),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          items: _experienceOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option, style: TextStyle(color: textColor)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _experienceController.text = value!);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select experience level';
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

  bool _isStandardRequirement(String key) {
    return [
      'min_age', 
      'equipment', 
      'experience_level',
      'duration_hours',
      'max_group_size'
    ].contains(key);
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

  Widget _buildRequirementsSection() {
    final cardColor = context.cardColor;
    final textColor = context.textColor;
    final secondaryTextColor = context.secondaryTextColor;

    return Container(
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
              Icon(Icons.checklist, color: AppTheme.successColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Requirements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Minimum Age
          Row(
            children: [
              Expanded(
                child: buildFormField(
                  context,
                  controller: _minAgeController,
                  label: 'Minimum Age',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter minimum age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Years', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('Minimum age required', 
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Equipment
          _buildEquipmentDropdown(),
          const SizedBox(height: 16),

          // Experience Level
          _buildExperienceDropdown(),
          const SizedBox(height: 16),

          // Duration
          Row(
            children: [
              Expanded(
                child: buildFormField(
                  context,
                  controller: _durationController,
                  label: 'Duration',
                  icon: Icons.timer,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter duration';
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hours', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('Activity duration in hours', 
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Group Size
          Row(
            children: [
              Expanded(
                child: buildFormField(
                  context,
                  controller: _groupSizeController,
                  label: 'Maximum Group Size',
                  icon: Icons.group,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter group size';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Persons', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Text('Maximum participants allowed', 
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Custom Requirements
          Text(
            'Additional Requirements (Optional)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          
          ..._customRequirements.asMap().entries.map((entry) {
            final index = entry.key;
            final requirement = entry.value;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: secondaryTextColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          requirement.key,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          requirement.value,
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _customRequirements.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),

          // Add Custom Requirement
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _customKeyController,
                  decoration: InputDecoration(
                    labelText: 'Requirement Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _customValueController,
                  decoration: InputDecoration(
                    labelText: 'Value',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.add, color: AppTheme.successColor),
                onPressed: () {
                  if (_customKeyController.text.isNotEmpty && 
                      _customValueController.text.isNotEmpty) {
                    setState(() {
                      _customRequirements.add(MapEntry(
                        _customKeyController.text,
                        _customValueController.text,
                      ));
                      _customKeyController.clear();
                      _customValueController.clear();
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Example: "Insurance" = "Required", "Language" = "English"',
            style: TextStyle(
              fontSize: 12,
              color: secondaryTextColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _buildRequirementsJson() {
    final requirements = <String, dynamic>{
      'min_age': int.tryParse(_minAgeController.text) ?? 18,
      'equipment': _equipmentController.text,
      'experience_level': _experienceController.text,
      'duration_hours': double.tryParse(_durationController.text) ?? 2.0,
      'max_group_size': int.tryParse(_groupSizeController.text) ?? 10,
    };

    // Add custom requirements
    for (final req in _customRequirements) {
      requirements[req.key] = req.value;
    }

    return requirements;
  }

  bool _validateForm() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _activityTypeController.text.isNotEmpty &&
        _minAgeController.text.isNotEmpty &&
        _equipmentController.text.isNotEmpty &&
        _experienceController.text.isNotEmpty &&
        _durationController.text.isNotEmpty &&
        _groupSizeController.text.isNotEmpty;
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields correctly')),
      );
      return;
    }

    // Create ActivityDetails with auto-generated JSON
    final activityDetails = ActivityDetails(
      activityType: _activityTypeController.text,
      requirements: _buildRequirementsJson(),
    );

    // Create partial post data
    final postData = CreatePostData(
      category: 'activity',
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      priceRate: _selectedPriceRate,
      location: widget.existingData?.location ?? Location(wilaya: '', city: '', address: '', latitude: 0, longitude: 0),
      availability: widget.existingData?.availability ?? [],
      imagePaths: widget.existingData?.imagePaths ?? [],
      stayDetails: null,
      activityDetails: activityDetails,
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
      appBar: App_Bar(context, 'Activity Details'),
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
                      color: AppTheme.successColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.hiking_outlined,
                      color: AppTheme.successColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Activity Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provide details about your activity',
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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                        // Activity Type
                        buildFormField(
                          context,
                          controller: _activityTypeController,
                          label: 'Activity Type',
                          icon: Icons.hiking,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter activity type';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Requirements Section
                  _buildRequirementsSection(),

                  const SizedBox(height: 32),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _validateForm()
                            ? AppTheme.successColor
                            : AppTheme.successColor.withOpacity(0.5),
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
          ],
        ),
      ),
    );
  }
}