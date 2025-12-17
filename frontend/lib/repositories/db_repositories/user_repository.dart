import 'package:sqflite/sqflite.dart';
import '../../models/users.model.dart';

/// Repository for managing user data
class UserRepository {
  final Database db;

  UserRepository(this.db);

  /// Insert a new user
  Future<int> insertUser(User user) async {
    return await db.insert('users', user.toMap());
  }

  /// Get user by ID
  Future<User?> getUserById(int id) async {
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  /// Get user by email
  Future<User?> getUserByEmail(String email) async {
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  /// Get user by phone number
  Future<User?> getUserByPhoneNumber(String phone) async {
    final result = await db.query(
      'users',
      where: 'phone_number = ?',
      whereArgs: [phone],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  /// Get user by username
  Future<User?> getUserByUsername(String username) async {
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : null;
  }

  /// Get all users
  Future<List<User>> getAllUsers() async {
    final results = await db.query('users');
    return results.map((map) => User.fromMap(map)).toList();
  }

  /// Update user
  Future<int> updateUser(int id, User user) async {
    final values = user.toMap();
    values.remove('id'); // Remove ID to avoid updating it
    return await db.update('users', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete user
  Future<int> deleteUser(int id) async {
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
