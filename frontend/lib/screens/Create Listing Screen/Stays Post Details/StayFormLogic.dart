import 'package:flutter/material.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/locations.model.dart';

class StayFormController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController bedroomsController = TextEditingController();
  
  String selectedPriceRate = 'day';
  String? selectedStayType;
  
  final List<String> priceRates = ['hour', 'day', 'week', 'month'];
  final List<String> stayTypes = ['apartment', 'villa', 'house', 'room', 'chalet'];
  
  void loadExistingData(CreatePostData? data) {
    if (data == null) return;
    
    titleController.text = data.title;
    descriptionController.text = data.description;
    priceController.text = data.price.toString();
    selectedPriceRate = data.priceRate;
    
    if (data.stayDetails != null) {
      selectedStayType = data.stayDetails!.stayType;
      areaController.text = data.stayDetails!.area.toString();
      bedroomsController.text = data.stayDetails!.bedrooms.toString();
    }
  }
  
  bool validateForm() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectedStayType != null &&
        areaController.text.isNotEmpty &&
        bedroomsController.text.isNotEmpty;
  }
  
  CreatePostData createPostData(CreatePostData? existingData) {
    final stayDetails = StayDetails(
      stayType: selectedStayType!,
      area: double.parse(areaController.text),
      bedrooms: int.parse(bedroomsController.text),
    );
    
    return CreatePostData(
      id: existingData?.id, // Preserve id for editing
      category: 'stay',
      title: titleController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      priceRate: selectedPriceRate,
      location: existingData?.location ?? Location(wilaya: '', city: '', address: '', latitude: 0, longitude: 0),
      availability: existingData?.availability ?? [],
      imagePaths: existingData?.imagePaths ?? [],
      stayDetails: stayDetails,
      activityDetails: null,
      vehicleDetails: null,
    );
  }
  
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    areaController.dispose();
    bedroomsController.dispose();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}