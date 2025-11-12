import 'base_repository.dart';

/// Repository for managing admin data
class AdminRepository extends BaseRepository {
  /// Insert a new admin
  Future<int> insertAdmin({required int userId, required String role}) async {
    return await db.insert('admins', {'user_id': userId, 'role': role});
  }

  /// Get admin by ID
  Future<Map<String, dynamic>?> getAdminById(int id) async {
    final result = await db.query('admins', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  /// Get admin by user ID
  Future<Map<String, dynamic>?> getAdminByUserId(int userId) async {
    final result = await db.query(
      'admins',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all admins
  Future<List<Map<String, dynamic>>> getAllAdmins() async {
    return await db.query('admins');
  }

  /// Update admin
  Future<int> updateAdmin(int id, Map<String, dynamic> values) async {
    return await db.update('admins', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete admin
  Future<int> deleteAdmin(int id) async {
    return await db.delete('admins', where: 'id = ?', whereArgs: [id]);
  }
}
