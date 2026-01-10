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
    // Parse features - can be a JSON string (from SQLite), a Map, a List, or null
    Map<String, dynamic>? parsedFeatures;
    if (map['features'] != null) {
      final featuresData = map['features'];
      if (featuresData is String) {
        // From SQLite - stored as JSON string
        try {
          final decoded = jsonDecode(featuresData);
          if (decoded is Map) {
            parsedFeatures = Map<String, dynamic>.from(decoded);
          } else if (decoded is List) {
            // Convert list to map with index keys
            parsedFeatures = {for (int i = 0; i < decoded.length; i++) i.toString(): decoded[i]};
          }
        } catch (_) {
          parsedFeatures = null;
        }
      } else if (featuresData is Map) {
        // From API - already a Map
        parsedFeatures = Map<String, dynamic>.from(featuresData);
      } else if (featuresData is List) {
        // From API - as a List, convert to map
        parsedFeatures = {for (int i = 0; i < featuresData.length; i++) i.toString(): featuresData[i]};
      }
    }

    return Vehicle(
      postId: map['post_id'] ?? 0,
      vehicleType: map['vehicle_type'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? DateTime.now().year,
      fuelType: map['fuel_type'] ?? 'gasoline',
      transmission: map['transmission'] == 1 || map['transmission'] == true,
      seats: map['seats'] ?? 5,
      features: parsedFeatures,
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