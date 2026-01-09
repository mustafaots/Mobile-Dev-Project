import 'dart:async';
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
  
  /// All 58 Algerian wilayas in English (sorted alphabetically)
  final List<String> wilayas = [
    'Adrar',
    'Ain Defla',
    'Ain Temouchent',
    'Algiers',
    'Annaba',
    'Batna',
    'Bechar',
    'Bejaia',
    'Biskra',
    'Blida',
    'Bordj Bou Arreridj',
    'Bouira',
    'Boumerdes',
    'Chlef',
    'Constantine',
    'Djelfa',
    'El Bayadh',
    'El Meghaier',
    'El Meniaa',
    'El Oued',
    'El Tarf',
    'Ghardaia',
    'Guelma',
    'Illizi',
    'In Guezzam',
    'In Salah',
    'Jijel',
    'Khenchela',
    'Laghouat',
    'Mascara',
    'Medea',
    'Mila',
    'Mostaganem',
    'Msila',
    'Naama',
    'Oran',
    'Ouargla',
    'Oum El Bouaghi',
    'Ouled Djellal',
    'Relizane',
    'Saida',
    'Setif',
    'Sidi Bel Abbes',
    'Skikda',
    'Souk Ahras',
    'Tamanrasset',
    'Tebessa',
    'Tiaret',
    'Timimoun',
    'Tindouf',
    'Tipaza',
    'Tissemsilt',
    'Tizi Ouzou',
    'Tlemcen',
    'Touggourt',
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

    if (source == ImageSource.gallery) {
      final List<XFile> images = await picker.pickMultiImage();
      selectedImages.addAll(images);
    } else {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        selectedImages.add(image);
      }
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
      id: originalPostData.id, // Preserve id for editing
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