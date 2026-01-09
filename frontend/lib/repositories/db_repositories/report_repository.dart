import 'package:sqflite/sqflite.dart';
import '../../models/reports.model.dart';

/// Repository for managing report data
class ReportRepository {
  final Database db;

  ReportRepository(this.db);

  /// Insert a new report
  Future<int> insertReport(Report report) async {
    return await db.insert('reports', report.toMap());
  }

  /// Get report by ID
  Future<Report?> getReportById(int id) async {
    final result = await db.query('reports', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Report.fromMap(result.first) : null;
  }

  /// Get all reports
  Future<List<Report>> getAllReports() async {
    final results = await db.query('reports');
    return results.map((map) => Report.fromMap(map)).toList();
  }

  /// Get reports by reporter ID
  Future<List<Report>> getReportsByReporterId(int reporterId) async {
    final results = await db.query(
      'reports',
      where: 'reporter_id = ?',
      whereArgs: [reporterId],
    );
    return results.map((map) => Report.fromMap(map)).toList();
  }

  /// Get reports for a specific post
  Future<List<Report>> getReportsByPostId(int postId) async {
    final results = await db.query(
      'reports',
      where: 'reported_post_id = ?',
      whereArgs: [postId],
    );
    return results.map((map) => Report.fromMap(map)).toList();
  }

  /// Get reports for a specific user
  Future<List<Report>> getReportsByUserId(int userId) async {
    final results = await db.query(
      'reports',
      where: 'reported_user_id = ?',
      whereArgs: [userId],
    );
    return results.map((map) => Report.fromMap(map)).toList();
  }

  /// Update report
  Future<int> updateReport(int id, Report report) async {
    final values = report.toMap();
    values.remove('id'); // Remove ID to avoid updating it
    return await db.update('reports', values, where: 'id = ?', whereArgs: [id]);
  }

  /// Delete report
  Future<int> deleteReport(int id) async {
    return await db.delete('reports', where: 'id = ?', whereArgs: [id]);
  }
}
