import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DBHelper {
  static const _databaseName = "easy_vacation.db";
  static const _databaseVersion = 1;
  static Database? _database;
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) async {
        // Create users table
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT,
            phone_number TEXT,
            first_name TEXT,
            last_name TEXT,
            created_at TIMESTAMP,
            is_verified BOOLEAN,
            profile_picture BLOB,
            status TEXT
          )
        ''');

        // Create locations table
        await db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            wilaya TEXT,
            city TEXT,
            address TEXT,
            latitude REAL,
            longitude REAL
          )
        ''');

        // Create posts table
        await db.execute('''
          CREATE TABLE posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            owner INTEGER,
            title TEXT,
            description TEXT,
            category TEXT,
            location_id INTEGER,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            is_paid BOOLEAN,
            FOREIGN KEY (owner) REFERENCES users(id),
            FOREIGN KEY (location_id) REFERENCES locations(id)
          )
        ''');

        // Create stays table
        await db.execute('''
          CREATE TABLE stays (
            id INTEGER PRIMARY KEY,
            price REAL,
            content BLOB,
            FOREIGN KEY (id) REFERENCES posts(id)
          )
        ''');

        // Create activities table
        await db.execute('''
          CREATE TABLE activities (
            id INTEGER PRIMARY KEY,
            price REAL,
            content BLOB,
            FOREIGN KEY (id) REFERENCES posts(id)
          )
        ''');

        // Create vehicles table
        await db.execute('''
          CREATE TABLE vehicles (
            id INTEGER PRIMARY KEY,
            price REAL,
            content BLOB,
            FOREIGN KEY (id) REFERENCES posts(id)
          )
        ''');

        // Create bookings table
        await db.execute('''
          CREATE TABLE bookings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            post_id INTEGER,
            client_id INTEGER,
            status TEXT,
            booked_at TIMESTAMP,
            FOREIGN KEY (post_id) REFERENCES posts(id),
            FOREIGN KEY (client_id) REFERENCES users(id)
          )
        ''');

        // Create reviews table
        await db.execute('''
          CREATE TABLE reviews (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            post_id INTEGER,
            reviewer_id INTEGER,
            rating INTEGER,
            comment TEXT,
            created_at TIMESTAMP,
            FOREIGN KEY (post_id) REFERENCES posts(id),
            FOREIGN KEY (reviewer_id) REFERENCES users(id)
          )
        ''');

        // Create verification_codes table
        await db.execute('''
          CREATE TABLE verification_codes (
            code TEXT PRIMARY KEY,
            owner INTEGER,
            FOREIGN KEY (owner) REFERENCES users(id)
          )
        ''');

        // Create subscriptions table
        await db.execute('''
          CREATE TABLE subscriptions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            subscriber INTEGER,
            plan TEXT,
            created_at TIMESTAMP,
            expires_at TIMESTAMP,
            is_active BOOLEAN,
            FOREIGN KEY (subscriber) REFERENCES users(id)
          )
        ''');

        // Create notifications table
        await db.execute('''
          CREATE TABLE notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            message TEXT,
            type TEXT,
            is_read BOOLEAN,
            created_at TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');

        // Create admins table
        await db.execute('''
          CREATE TABLE admins (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            role TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');

        // Create reports table
        await db.execute('''
          CREATE TABLE reports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reporter_id INTEGER,
            reported_post INTEGER,
            reported_user INTEGER,
            reason TEXT,
            status TEXT,
            created_at TIMESTAMP,
            resolved_by INTEGER,
            FOREIGN KEY (reporter_id) REFERENCES users(id),
            FOREIGN KEY (reported_post) REFERENCES posts(id),
            FOREIGN KEY (reported_user) REFERENCES users(id),
            FOREIGN KEY (resolved_by) REFERENCES admins(id)
          )
        ''');
      },
      version: _databaseVersion,
    );

    return _database!;
  }
}
