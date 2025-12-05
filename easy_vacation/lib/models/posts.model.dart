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
  final List<Map<String, dynamic>> availability;

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
    this.availability = const [], // FIX: Default empty list
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
      'availability': jsonEncode(availability),
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
      availability: map['availability'] != null
          ? List<Map<String, dynamic>>.from(jsonDecode(map['availability']))
          : [],
    );
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
    List<Map<String, dynamic>>? availability,
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