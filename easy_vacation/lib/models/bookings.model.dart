class Booking {
  final int? id;
  final int postId;
  final int clientId;
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

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      postId: map['post_id'] ?? 0,
      clientId: map['client_id'] ?? 0,
      status: map['status'] ?? 'pending',
      bookedAt: map['booked_at'] != null 
          ? DateTime.parse(map['booked_at']) 
          : DateTime.now(),
      startTime: map['start_time'] != null 
          ? DateTime.parse(map['start_time']) 
          : DateTime.now(),
      endTime: map['end_time'] != null 
          ? DateTime.parse(map['end_time']) 
          : DateTime.now(),
    );
  }
}