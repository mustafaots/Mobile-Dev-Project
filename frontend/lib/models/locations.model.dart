// easy_vacation/lib/models/locations.model.dart
import 'package:easy_vacation/models/locations.model.dart' as details;

class Location {
  final int? id;
  final String wilaya;
  final String city;
  final String address;
  final double latitude;
  final double longitude;

  Location({
    this.id,
    required this.wilaya,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
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
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
    );
  }

  // FIXED: Add method to convert from details.Location
  factory Location.fromDetailsLocation(details.Location detailsLocation) {
    return Location(
      wilaya: detailsLocation.wilaya,
      city: detailsLocation.city,
      address: detailsLocation.address,
      latitude: detailsLocation.latitude,
      longitude: detailsLocation.longitude,
    );
  }

  // Convert to database decimal format (10,8 for latitude, 11,8 for longitude)
  Map<String, dynamic> toDatabaseMap() {
    return {
      if (id != null) 'id': id,
      'wilaya': wilaya,
      'city': city,
      'address': address,
      'latitude': latitude.toStringAsFixed(8),
      'longitude': longitude.toStringAsFixed(8),
    };
  }

  // Check if location is valid (has coordinates)
  bool get isValid => latitude != 0 && longitude != 0;

  // Get coordinates as LatLng for maps
  Map<String, double> get coordinates => {
    'latitude': latitude,
    'longitude': longitude,
  };

  // Get full address string
  String get fullAddress => '$address, $city, $wilaya';

  // Get coordinates string
  String get coordinatesString => '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
}