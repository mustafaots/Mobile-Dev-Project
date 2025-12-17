import 'dart:convert';

class Post {
  final int? id;
  final int ownerId;
  final String category; // 'activity', 'vehicle', 'stay'
  final String title;
  final String? description;
  final double price;
  final int locationId;
  final String? contentUrl;
  final bool isPaid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status; // 'active', 'draft'
  final List<Map<String, DateTime>> availability;

  Post({
    this.id,
    required this.ownerId,
    required this.category,
    required this.title,
    this.description,
    required this.price,
    required this.locationId,
    this.contentUrl,
    this.isPaid = false,
    required this.createdAt,
    required this.updatedAt,
    this.status = 'active',
    this.availability = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'owner_id': ownerId,
      'category': category,
      'title': title,
      'description': description,
      'price': price,
      'location_id': locationId,
      'content_url': contentUrl,
      'is_paid': isPaid ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
      'availability': jsonEncode(
        availability
            .map(
              (interval) => interval.map(
                (key, value) => MapEntry(key, value.toIso8601String()),
              ),
            )
            .toList(),
      ),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      ownerId: map['owner_id'] ?? 0,
      category: map['category'] ?? 'stay',
      title: map['title'] ?? '',
      description: map['description'],
      price: (map['price'] ?? 0).toDouble(),
      locationId: map['location_id'] ?? 0,
      contentUrl: map['content_url'],
      isPaid: map['is_paid'] == 1,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : DateTime.now(),
      status: map['status'] ?? 'active',
      availability: _decodeAvailability(map['availability']),
    );
  }

  static List<Map<String, DateTime>> _decodeAvailability(dynamic raw) {
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
            final startValue = map['startDate'] ?? map['start'] ?? map['start_date'];
            final endValue = map['endDate'] ?? map['end'] ?? map['end_date'];

            final startDate = _parseDate(startValue);
            final endDate = _parseDate(endValue);

            if (startDate == null || endDate == null) {
              return null;
            }

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

  static DateTime? _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // FIX: Add copyWith method for easier updates
  Post copyWith({
    int? id,
    int? ownerId,
    String? category,
    String? title,
    String? description,
    double? price,
    int? locationId,
    String? contentUrl,
    bool? isPaid,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    List<Map<String, DateTime>>? availability,
  }) {
    return Post(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      locationId: locationId ?? this.locationId,
      contentUrl: contentUrl ?? this.contentUrl,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      availability: availability ?? this.availability,
    );
  }
}