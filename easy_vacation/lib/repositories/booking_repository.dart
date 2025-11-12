import 'base_repository.dart';

/// Repository for managing booking data
class BookingRepository extends BaseRepository {
  /// Insert a new booking
  Future<int> insertBooking({
    required int postId,
    required int clientId,
    String? status,
  }) async {
    return await db.insert('bookings', {
      'post_id': postId,
      'client_id': clientId,
      'status': status ?? 'pending',
      'booked_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get booking by ID
  Future<Map<String, dynamic>?> getBookingById(int id) async {
    final result = await db.query('bookings', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all bookings
  Future<List<Map<String, dynamic>>> getAllBookings() async {
    return await db.query('bookings');
  }

  /// Get bookings by post ID
  Future<List<Map<String, dynamic>>> getBookingsByPostId(int postId) async {
    return await db.query(
      'bookings',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Get bookings by client ID
  Future<List<Map<String, dynamic>>> getBookingsByClientId(int clientId) async {
    return await db.query(
      'bookings',
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
  }

  /// Get bookings by status
  Future<List<Map<String, dynamic>>> getBookingsByStatus(String status) async {
    return await db.query('bookings', where: 'status = ?', whereArgs: [status]);
  }

  /// Update booking
  Future<int> updateBooking(int id, Map<String, dynamic> values) async {
    return await db.update(
      'bookings',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete booking
  Future<int> deleteBooking(int id) async {
    return await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }
}
