import 'dart:convert';
import 'package:easy_vacation/models/details.model.dart';

// extends vehicle details

class Vehicle {
  final int postId;
  final String vehicleType; // "car", "bike", "boat", etc.
  final String model;
  final int year;
  final String fuelType;
  final bool transmission; // true: automatic, false: manual
  final int seats;
  final Map<String, dynamic>? features;

  Vehicle({
    required this.postId,
    required this.vehicleType,
    required this.model,
    required this.year,
    required this.fuelType,
    required this.transmission,
    required this.seats,
    this.features,
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'vehicle_type': vehicleType,
      'model': model,
      'year': year,
      'fuel_type': fuelType,
      'transmission': transmission ? 1 : 0,
      'seats': seats,
      'features': features != null ? jsonEncode(features) : null,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      postId: map['post_id'] ?? 0,
      vehicleType: map['vehicle_type'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? DateTime.now().year,
      fuelType: map['fuel_type'] ?? 'gasoline',
      transmission: map['transmission'] == 1,
      seats: map['seats'] ?? 5,
      features: map['features'] != null
          ? Map<String, dynamic>.from(jsonDecode(map['features']!))
          : null,
    );
  }

  factory Vehicle.fromVehicleDetails(int postId, VehicleDetails details) {
    return Vehicle(
      postId: postId,
      vehicleType: details.vehicleType,
      model: details.model,
      year: details.year,
      fuelType: details.fuelType,
      transmission: details.transmission,
      seats: details.seats,
      features: details.features,
    );
  }
}