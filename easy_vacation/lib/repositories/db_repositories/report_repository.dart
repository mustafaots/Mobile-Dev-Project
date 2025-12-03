import 'package:sqflite/sqflite.dart';

/// Repository for managing report data
class ReportRepository {
  final Database db;

  ReportRepository(this.db);

  /// Insert a new report
  Future<int> insertReport({
    required int reporterId,
    int? reportedPostId,
    int? reportedUserId,
    required String reason,
    String? additionalDetails
  }) async {
    return await db.insert('reports', {
      'reporter_id': reporterId,
      'reported_post_id': reportedPostId,
      'reported_user_id': reportedUserId,
      'reason': reason,
      'additional_details': additionalDetails,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get report by ID
  Future<Map<String, dynamic>?> getReportById(int id) async {
    final result = await db.query('reports', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  /// Get all reports
  Future<List<Map<String, dynamic>>> getAllReports() async {
    return await db.query('reports');
  }

  /// Get reports by reporter ID
  Future<List<Map<String, dynamic>>> getReportsByReporterId(
    int reporterId,
  ) async {
    return await db.query(
      'reports',
      where: 'reporter_id = ?',
      whereArgs: [reporterId],
    );
  }

  /// Get reports for a specific post
  Future<List<Map<String, dynamic>>> getReportsByPostId(int postId) async {
    return await db.query(
      'reports',
      where: 'reported_post_id = ?',
      whereArgs: [postId],
    );
  }

  /// Get reports for a specific user
  Future<List<Map<String, dynamic>>> getReportsByUserId(int userId) async {
    return await db.query(
      'reports',
      where: 'reported_user_id = ?',
      whereArgs: [userId],
    );
  }

  /// Update report
  Future<int> updateReport(int id, Map<String, dynamic> values) async {
    return await db.update('reports', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete report
  Future<int> deleteReport(int id) async {
    return await db.delete('reports', where: 'id = ?', whereArgs: [id]);
  }
}
