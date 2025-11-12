import 'base_repository.dart';

/// Repository for managing user data
class UserRepository extends BaseRepository {
  /// Insert a new user
  Future<int> insertUser({
    required String username,
    required String email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    bool isVerified = false,
    String? profilePicture,
    String? status,
  }) async {
    return await db.insert('users', {
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'created_at': DateTime.now().toIso8601String(),
      'is_verified': isVerified ? 1 : 0,
      'profile_picture': profilePicture,
      'status': status,
    });
  }

  /// Get user by ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  /// Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await db.query('users');
  }

  /// Update user
  Future<int> updateUser(int id, Map<String, dynamic> values) async {
    values['updated_at'] = DateTime.now().toIso8601String();
    return await db.update('users', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete user
  Future<int> deleteUser(int id) async {
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
