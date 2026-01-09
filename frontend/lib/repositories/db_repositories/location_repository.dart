import 'package:sqflite/sqflite.dart';
import '../../models/locations.model.dart';

/// Repository for managing location data
class LocationRepository {
  final Database db;

  LocationRepository(this.db);

  /// Insert a new location
  Future<int> insertLocation(Location location) async {
    return await db.insert('locations', location.toMap());
  }

  /// Get location by ID
  Future<Location?> getLocationById(int id) async {
    final result = await db.query(
      'locations',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Location.fromMap(result.first) : null;
  }

  /// Get all locations
  Future<List<Location>> getAllLocations() async {
    final results = await db.query('locations');
    return results.map((map) => Location.fromMap(map)).toList();
  }

  /// Get locations by wilaya (province)
  Future<List<Location>> getLocationsByWilaya(String wilaya) async {
    final results = await db.query(
      'locations',
      where: 'wilaya = ?',
      whereArgs: [wilaya],
    );
    return results.map((map) => Location.fromMap(map)).toList();
  }

  /// Get locations by city
  Future<List<Location>> getLocationsByCity(String city) async {
    final results = await db.query(
      'locations',
      where: 'city = ?',
      whereArgs: [city],
    );
    return results.map((map) => Location.fromMap(map)).toList();
  }

  /// Get location by full address (wilaya, city, address)
  Future<Location?> getLocationByAddress(String wilaya, String city, String address) async {
    final results = await db.query(
      'locations',
      where: 'wilaya = ? AND city = ? AND address = ?',
      whereArgs: [wilaya, city, address],
    );
    return results.isNotEmpty ? Location.fromMap(results.first) : null;
  }

  /// Update location
  Future<int> updateLocation(int id, Location location) async {
    final values = location.toMap();
    values.remove('id'); // Remove ID to avoid updating it
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
