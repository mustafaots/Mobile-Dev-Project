class Location {
  final int? id;
  final String wilaya;
  final String city;
  final String address;
  final double? latitude;
  final double? longitude;

  Location({
    this.id,
    required this.wilaya,
    required this.city,
    required this.address,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'wilaya': wilaya,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'],
      wilaya: map['wilaya'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
    );
  }
}

class StayDetails {
  final String stayType;
  final double area;
  final int bedrooms;

  StayDetails({
    required this.stayType,
    required this.area,
    required this.bedrooms,
  });

  Map<String, dynamic> toMap() {
    return {
      'stay_type': stayType,
      'area': area,
      'bedrooms': bedrooms,
    };
  }

  factory StayDetails.fromMap(Map<String, dynamic> map) {
    return StayDetails(
      stayType: map['stay_type'] ?? 'apartment',
      area: (map['area'] ?? 0).toDouble(),
      bedrooms: map['bedrooms'] ?? 1,
    );
  }
}

class ActivityDetails {
  final String activityType;
  final Map<String, dynamic> requirements;

  ActivityDetails({
    required this.activityType,
    required this.requirements,
  });

  Map<String, dynamic> toMap() {
    return {
      'activity_type': activityType,
      'requirements': requirements,
    };
  }

  factory ActivityDetails.fromMap(Map<String, dynamic> map) {
    return ActivityDetails(
      activityType: map['activity_type'] ?? '',
      requirements: Map<String, dynamic>.from(map['requirements'] ?? {}),
    );
  }
}

class VehicleDetails {
  final String vehicleType;
  final String model;
  final int year;
  final String fuelType;
  final bool transmission; // true: automatic, false: manual
  final int seats;
  final Map<String, dynamic>? features;

  VehicleDetails({
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
      'vehicle_type': vehicleType,
      'model': model,
      'year': year,
      'fuel_type': fuelType,
      'transmission': transmission,
      'seats': seats,
      'features': features,
    };
  }

  factory VehicleDetails.fromMap(Map<String, dynamic> map) {
    return VehicleDetails(
      vehicleType: map['vehicle_type'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? DateTime.now().year,
      fuelType: map['fuel_type'] ?? 'gasoline',
      transmission: map['transmission'] ?? false,
      seats: map['seats'] ?? 5,
      features: map['features'] != null 
          ? Map<String, dynamic>.from(map['features']!)
          : null,
    );
  }
}

class AvailabilityInterval {
  final DateTime start;
  final DateTime end;

  AvailabilityInterval({
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toMap() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }

  factory AvailabilityInterval.fromMap(Map<String, dynamic> map) {
    return AvailabilityInterval(
      start: DateTime.parse(map['start']),
      end: DateTime.parse(map['end']),
    );
  }
}

class CreatePostData {
  final String category;
  final String title;
  final String description;
  final double price;
  final String priceRate; // 'day', 'week', 'month', 'hour'
  final Location location;
  final List<AvailabilityInterval> availability;
  
  // Category-specific data
  final StayDetails? stayDetails;
  final ActivityDetails? activityDetails;
  final VehicleDetails? vehicleDetails;
  
  // Images
  final List<String> imagePaths;

  CreatePostData({
    required this.category,
    required this.title,
    required this.description,
    required this.price,
    required this.priceRate,
    required this.location,
    required this.availability,
    this.stayDetails,
    this.activityDetails,
    this.vehicleDetails,
    required this.imagePaths,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'description': description,
      'price': price,
      'price_rate': priceRate,
      'location': location.toMap(),
      'availability': availability.map((a) => a.toMap()).toList(),
      'stay_details': stayDetails?.toMap(),
      'activity_details': activityDetails?.toMap(),
      'vehicle_details': vehicleDetails?.toMap(),
      'image_paths': imagePaths,
    };
  }
}