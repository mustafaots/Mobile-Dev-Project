import 'package:sqflite/sqflite.dart';
import '../database/db_helper.dart';

/// Base repository class that provides database initialization
/// All specific repositories extend this class
class BaseRepository {
  late Database db;

  /// Initialize the database connection
  Future<void> initialize() async {
    db = await DBHelper.getDatabase();
  }

  /// Close the database connection
  Future<void> close() async {
    await db.close();
  }
}
