import 'base_repository.dart';

/// Repository for managing location data
class LocationRepository extends BaseRepository {
  /// Insert a new location
  Future<int> insertLocation({
    required String wilaya,
    required String city,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    return await db.insert('locations', {
      'wilaya': wilaya,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  /// Get location by ID
  Future<Map<String, dynamic>?> getLocationById(int id) async {
    final result = await db.query(
      'locations',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all locations
  Future<List<Map<String, dynamic>>> getAllLocations() async {
    return await db.query('locations');
  }

  /// Get locations by wilaya (province)
  Future<List<Map<String, dynamic>>> getLocationsByWilaya(String wilaya) async {
    return await db.query(
      'locations',
      where: 'wilaya = ?',
      whereArgs: [wilaya],
    );
  }

  /// Update location
  Future<int> updateLocation(int id, Map<String, dynamic> values) async {
    return await db.update(
      'locations',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete location
  Future<int> deleteLocation(int id) async {
    return await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }
}
