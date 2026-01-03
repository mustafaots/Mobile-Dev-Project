class User {
  final String? id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final DateTime createdAt;
  final bool isVerified;
  final String userType; // "tourist", "host", or "both"
  final bool isSuspended;
  final bool phoneVerified;

  User({
    this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    required this.createdAt,
    this.isVerified = false,
    this.userType = 'tourist',
    this.isSuspended = false,
    this.phoneVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'created_at': createdAt.toIso8601String(),
      'is_verified': isVerified ? 1 : 0,
      'user_type': userType,
      'is_suspended': isSuspended ? 1 : 0,
      // Note: phone_verified is not stored locally, it comes from the API
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      // Handle both 'id' and 'user_id' from backend
      id: (map['id'] ?? map['user_id'])?.toString(),
      username: map['username'] ?? map['email']?.toString().split('@').first ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? map['phone'],
      firstName: map['first_name'] ?? map['user_metadata']?['first_name'],
      lastName: map['last_name'] ?? map['user_metadata']?['last_name'],
      createdAt: _parseDateTime(map['created_at']),
      isVerified: map['is_verified'] == 1 || map['is_verified'] == true || map['email_confirmed_at'] != null,
      userType: map['user_type'] ?? 'tourist',
      isSuspended: map['is_suspended'] == 1 || map['is_suspended'] == true,
      phoneVerified: map['phone_verified'] == 1 || map['phone_verified'] == true,
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}