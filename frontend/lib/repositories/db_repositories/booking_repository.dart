import 'package:sqflite/sqflite.dart';
import '../../models/bookings.model.dart';

/// Repository for managing booking data
class BookingRepository {
  final Database db;

  BookingRepository(this.db);

  /// Insert a new booking
  Future<int> insertBooking(Booking booking) async {
    return await db.insert('bookings', booking.toMap());
  }

  /// Get booking by ID
  Future<Booking?> getBookingById(int id) async {
    final result = await db.query('bookings', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Booking.fromMap(result.first) : null;
  }

  /// Get all bookings
  Future<List<Booking>> getAllBookings() async {
    final results = await db.query('bookings');
    return results.map((map) => Booking.fromMap(map)).toList();
  }

  /// Get bookings by post ID
  Future<List<Booking>> getBookingsByPostId(int postId) async {
    final results = await db.query(
      'bookings',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return results.map((map) => Booking.fromMap(map)).toList();
  }

  /// Get bookings by client ID
  Future<List<Booking>> getBookingsByClientId(int clientId) async {
    final results = await db.query(
      'bookings',
      where: 'client_id = ?',
      whereArgs: [clientId],
    );
    return results.map((map) => Booking.fromMap(map)).toList();
  }

  /// Get bookings by status
  Future<List<Booking>> getBookingsByStatus(String status) async {
    final results = await db.query(
      'bookings',
      where: 'status = ?',
      whereArgs: [status],
    );
    return results.map((map) => Booking.fromMap(map)).toList();
  }

  /// Update booking
  Future<int> updateBooking(int id, Booking booking) async {
    final values = booking.toMap();
    values.remove('id'); // Remove ID to avoid updating it
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
