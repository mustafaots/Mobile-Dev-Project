import 'package:flutter/material.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/locations.model.dart';

class VehicleFormController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  
  String selectedPriceRate = 'day';
  String? selectedVehicleType;
  String? selectedFuelType;
  bool isAutomaticTransmission = false;
  
  final List<String> priceRates = ['hour', 'day', 'week', 'month'];
  final List<String> vehicleTypes = ['car', 'motorcycle', 'bicycle', 'boat', 'scooter'];
  final List<String> fuelTypes = ['gasoline', 'diesel', 'electric', 'hybrid'];
  
  void loadExistingData(CreatePostData? data) {
    if (data == null) {
      seatsController.text = '5';
      return;
    }
    
    titleController.text = data.title;
    descriptionController.text = data.description;
    priceController.text = data.price.toString();
    selectedPriceRate = data.priceRate;
    
    if (data.vehicleDetails != null) {
      final vehicle = data.vehicleDetails!;
      selectedVehicleType = vehicle.vehicleType;
      modelController.text = vehicle.model;
      yearController.text = vehicle.year.toString();
      selectedFuelType = vehicle.fuelType;
      isAutomaticTransmission = vehicle.transmission;
      seatsController.text = vehicle.seats.toString();
    } else {
      seatsController.text = '5';
    }
  }
  
  bool validateForm() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectedVehicleType != null &&
        modelController.text.isNotEmpty &&
        yearController.text.isNotEmpty &&
        selectedFuelType != null &&
        seatsController.text.isNotEmpty;
  }
  
  CreatePostData createPostData(CreatePostData? existingData) {
    final vehicleDetails = VehicleDetails(
      vehicleType: selectedVehicleType!,
      model: modelController.text,
      year: int.parse(yearController.text),
      fuelType: selectedFuelType!,
      transmission: isAutomaticTransmission,
      seats: int.parse(seatsController.text),
      features: null,
    );
    
    return CreatePostData(
      id: existingData?.id, // Preserve id for editing
      category: 'vehicle',
      title: titleController.text,
      description: descriptionController.text,
      price: double.parse(priceController.text),
      priceRate: selectedPriceRate,
      location: existingData?.location ?? Location(wilaya: '', city: '', address: '', latitude: 0, longitude: 0),
      availability: existingData?.availability ?? [],
      imagePaths: existingData?.imagePaths ?? [],
      stayDetails: null,
      activityDetails: null,
      vehicleDetails: vehicleDetails,
    );
  }
  
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    modelController.dispose();
    yearController.dispose();
    seatsController.dispose();
  }
}