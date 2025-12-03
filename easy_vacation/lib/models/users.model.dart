class User {
  final int? id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final DateTime createdAt;
  final bool isVerified;
  final String? profilePicture; // Store as base64 string or file path
  final String userType; // "tourist", "host", or "both"
  final bool isSuspended;

  User({
    this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    required this.createdAt,
    this.isVerified = false,
    this.profilePicture,
    this.userType = 'tourist',
    this.isSuspended = false,
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
      'profile_picture': profilePicture,
      'user_type': userType,
      'is_suspended': isSuspended ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
      isVerified: map['is_verified'] == 1,
      profilePicture: map['profile_picture'],
      userType: map['user_type'] ?? 'tourist',
      isSuspended: map['is_suspended'] == 1,
    );
  }
}