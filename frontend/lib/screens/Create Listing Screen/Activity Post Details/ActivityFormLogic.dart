import 'package:flutter/material.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/locations.model.dart';

class ActivityFormController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String? selectedActivityType;

  final TextEditingController minAgeController = TextEditingController();
  final TextEditingController equipmentController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController groupSizeController = TextEditingController();

  // Static rate for activities - always per person
  final String priceRate = 'person';

  final List<String> activityTypes = [
    'cultural',
    'sport',
    'entertainment',
    'educational',
    'adventure',
    'other',
  ];
  final List<String> equipmentOptions = [
    'provided',
    'bring your own',
    'partial',
    'not needed',
  ];
  final List<String> experienceOptions = [
    'beginner',
    'intermediate',
    'advanced',
    'expert',
  ];

  void loadExistingData(CreatePostData? data) {
    if (data == null) {
      // Don't set any defaults - let user fill everything
      return;
    }

    titleController.text = data.title;
    descriptionController.text = data.description;
    priceController.text = data.price.toString();
    
    if (data.activityDetails != null) {
      final activityType = data.activityDetails!.activityType.toLowerCase();
      selectedActivityType = activityTypes.contains(activityType)
          ? activityType
          : null;
      final requirements = data.activityDetails!.requirements;

      minAgeController.text = requirements['min_age']?.toString() ?? '';

      final equipment =
          requirements['equipment']?.toString().toLowerCase() ?? '';
      equipmentController.text = equipmentOptions.contains(equipment)
          ? equipment
          : '';

      final experience =
          requirements['experience_level']?.toString().toLowerCase() ?? '';
      experienceController.text = experienceOptions.contains(experience)
          ? experience
          : '';

      durationController.text =
          requirements['duration_hours']?.toString() ?? '';
      groupSizeController.text =
          requirements['max_group_size']?.toString() ?? '';
    }
  }

  Map<String, dynamic> buildRequirementsJson() {
    return <String, dynamic>{
      'min_age': int.tryParse(minAgeController.text) ?? 18,
      'equipment': equipmentController.text,
      'experience_level': experienceController.text,
      'duration_hours': double.tryParse(durationController.text) ?? 2.0,
      'max_group_size': int.tryParse(groupSizeController.text) ?? 10,
    };
  }

  bool validateForm() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectedActivityType != null &&
        minAgeController.text.isNotEmpty &&
        equipmentController.text.isNotEmpty &&
        experienceController.text.isNotEmpty &&
        durationController.text.isNotEmpty &&
        groupSizeController.text.isNotEmpty;
  }

  CreatePostData createPostData(CreatePostData? existingData) {
    final activityDetails = ActivityDetails(
      activityType: selectedActivityType!,
      requirements: buildRequirementsJson(),
    );

    return CreatePostData(
      id: existingData?.id, // Preserve id for editing
      category: 'activity',
      title: titleController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      priceRate: priceRate, // Static 'person' for activities
      location:
          existingData?.location ??
          Location(
            wilaya: '',
            city: '',
            address: '',
            latitude: 0,
            longitude: 0,
          ),
      availability: existingData?.availability ?? [],
      imagePaths: existingData?.imagePaths ?? [],
      stayDetails: null,
      activityDetails: activityDetails,
      vehicleDetails: null,
    );
  }

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    minAgeController.dispose();
    equipmentController.dispose();
    experienceController.dispose();
    durationController.dispose();
    groupSizeController.dispose();
  }
}
