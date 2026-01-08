import 'dart:convert';

class Booking {
  final int? id;
  final int postId;
  final String clientId; // Changed to String for UUID support
  final String status; // 'confirmed', 'rejected', 'pending'
  final DateTime bookedAt;
  final DateTime startTime;
  final DateTime endTime;

  Booking({
    this.id,
    required this.postId,
    required this.clientId,
    this.status = 'pending',
    required this.bookedAt,
    required this.startTime,
    required this.endTime,
  });

  /// For local SQLite database (keeps start_time/end_time columns)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'post_id': postId,
      'client_id': clientId,
      'status': status,
      'booked_at': bookedAt.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };
  }

  /// For Supabase API (uses reservation JSON column like availability)
  Map<String, dynamic> toApiMap() {
    // Normalize dates to noon UTC to avoid timezone day-boundary issues
    final normalizedStart = DateTime.utc(
      startTime.year,
      startTime.month,
      startTime.day,
      12,
      0,
      0,
    );
    final normalizedEnd = DateTime.utc(
      endTime.year,
      endTime.month,
      endTime.day,
      12,
      0,
      0,
    );
    final reservation = jsonEncode([
      {
        'startDate': normalizedStart.toIso8601String(),
        'endDate': normalizedEnd.toIso8601String(),
      },
    ]);
    return {
      if (id != null) 'id': id,
      'post_id': postId,
      'client_id': clientId,
      'status': status,
      'reservation': reservation,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    // Try to parse from reservation JSON first (Supabase format)
    DateTime startTime = DateTime.now();
    DateTime endTime = DateTime.now();

    if (map['reservation'] != null) {
      final dates = _parseReservation(map['reservation']);
      if (dates.isNotEmpty) {
        startTime = dates.first['startDate'] ?? DateTime.now();
        endTime = dates.first['endDate'] ?? DateTime.now();
      }
    } else {
      // Fallback for local SQLite format
      startTime = map['start_time'] != null
          ? DateTime.parse(map['start_time'])
          : DateTime.now();
      endTime = map['end_time'] != null
          ? DateTime.parse(map['end_time'])
          : DateTime.now();
    }

    return Booking(
      id: map['id'],
      postId: map['post_id'] ?? 0,
      clientId: map['client_id']?.toString() ?? '',
      status: map['status'] ?? 'pending',
      bookedAt: map['booked_at'] != null
          ? DateTime.parse(map['booked_at'])
          : DateTime.now(),
      startTime: startTime,
      endTime: endTime,
    );
  }

  /// Parse reservation JSON (same format as availability)
  static List<Map<String, DateTime>> _parseReservation(dynamic raw) {
    if (raw == null) return [];

    List<dynamic> decoded;
    try {
      if (raw is String) {
        decoded = jsonDecode(raw) as List<dynamic>;
      } else if (raw is List) {
        decoded = raw;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }

    return decoded
        .map((entry) {
          try {
            final map = Map<String, dynamic>.from(entry as Map);
            final startValue =
                map['startDate'] ?? map['start_date'] ?? map['start'];
            final endValue = map['endDate'] ?? map['end_date'] ?? map['end'];

            DateTime? startDate;
            DateTime? endDate;

            if (startValue is DateTime) {
              startDate = startValue;
            } else if (startValue is String && startValue.isNotEmpty) {
              startDate = DateTime.tryParse(startValue);
            }

            if (endValue is DateTime) {
              endDate = endValue;
            } else if (endValue is String && endValue.isNotEmpty) {
              endDate = DateTime.tryParse(endValue);
            }

            if (startDate == null || endDate == null) return null;

            return <String, DateTime>{
              'startDate': startDate,
              'endDate': endDate,
            };
          } catch (_) {
            return null;
          }
        })
        .whereType<Map<String, DateTime>>()
        .toList();
  }
}
