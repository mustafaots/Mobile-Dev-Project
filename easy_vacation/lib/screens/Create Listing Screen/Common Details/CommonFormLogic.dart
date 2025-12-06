import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_vacation/models/details.model.dart';
import 'package:easy_vacation/models/locations.model.dart';

class CommonFormController {
  final TextEditingController wilayaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  
  final ImagePicker picker = ImagePicker();
  List<XFile> selectedImages = [];
  
  double? selectedLatitude;
  double? selectedLongitude;
  List<AvailabilityInterval> availabilityIntervals = [];
  
  final List<String> wilayas = [
    'Alger', 'Oran', 'Constantine', 'Annaba', 'Blida', 'Batna', 'Sétif',
    'Chlef', 'Djelfa', 'Tébessa', 'Ouargla', 'Béjaïa', 'Skikda', 'Tizi Ouzou',
    'Algiers', 'Sidi Bel Abbès', 'Biskra', 'Tébessa', 'Tiaret', 'Guelma',
    'Mostaganem', 'M\'Sila', 'Saïda', 'El Oued', 'Tlemcen', 'Laghouat',
  ];
  
  void loadExistingData(CreatePostData postData) {
    if (postData.location.wilaya.isNotEmpty) {
      wilayaController.text = postData.location.wilaya;
      cityController.text = postData.location.city;
      addressController.text = postData.location.address;
      selectedLatitude = postData.location.latitude;
      selectedLongitude = postData.location.longitude;
    }
    
    availabilityIntervals = List.from(postData.availability);
    selectedImages = postData.imagePaths
        .map((path) => XFile(path))
        .toList();
  }
  
  Future<void> pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await picker.pickMultiImage();
        selectedImages.addAll(images);
      } else {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          selectedImages.add(image);
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
  
  void removeImage(int index) {
    selectedImages.removeAt(index);
  }
  
  void removeAvailabilityInterval(int index) {
    availabilityIntervals.removeAt(index);
  }
  
  bool validateForm() {
    return wilayaController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        selectedLatitude != null &&
        selectedLongitude != null &&
        availabilityIntervals.isNotEmpty &&
        selectedImages.isNotEmpty;
  }
  
  CreatePostData updatePostData(CreatePostData originalPostData) {
    return CreatePostData(
      category: originalPostData.category,
      title: originalPostData.title,
      description: originalPostData.description,
      price: originalPostData.price,
      priceRate: originalPostData.priceRate,
      location: Location(
        wilaya: wilayaController.text,
        city: cityController.text,
        address: addressController.text,
        latitude: selectedLatitude ?? 0,
        longitude: selectedLongitude ?? 0,
      ),
      availability: availabilityIntervals,
      imagePaths: selectedImages.map((xfile) => xfile.path).toList(),
      stayDetails: originalPostData.stayDetails,
      activityDetails: originalPostData.activityDetails,
      vehicleDetails: originalPostData.vehicleDetails,
    );
  }
  
  void dispose() {
    wilayaController.dispose();
    cityController.dispose();
    addressController.dispose();
  }
}