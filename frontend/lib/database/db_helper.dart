import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DBHelper {
  static const _databaseName = "easy_vacation.db";
  static const _databaseVersion = 2; // INCREMENTED VERSION
  static Database? _database;
  
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Migration: Remove UNIQUE constraint from post_images.post_id
          await db.execute('DROP TABLE IF EXISTS post_images');
          await db.execute('''
            CREATE TABLE post_images (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              post_id INTEGER NOT NULL,
              image BLOB NOT NULL,
              FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
            )
          ''');
        }
      },
      version: _databaseVersion,
    );

    return _database!;
  }

  static Future<void> _createTables(Database db) async {
    // Enable foreign key constraints
    await db.execute('PRAGMA foreign_keys = ON');
    
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        phone_number TEXT,
        first_name TEXT,
        last_name TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        is_verified BOOLEAN DEFAULT 0,
        user_type TEXT,
        is_suspended BOOLEAN
      )
    ''');

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

    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        owner_id INTEGER NOT NULL,
        category TEXT NOT NULL CHECK(category IN ('activity', 'vehicle', 'stay')),
        title TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        location_id INTEGER NOT NULL,
        content_url TEXT,
        is_paid BOOLEAN DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT DEFAULT 'active' CHECK(status IN ('active', 'draft')),
        availability TEXT,
        FOREIGN KEY (owner_id) REFERENCES users(id),
        FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE
      )
    ''');

    // FIXED: Removed UNIQUE constraint from post_id
    await db.execute('''
      CREATE TABLE post_images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER NOT NULL,
        image BLOB NOT NULL,
        FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE stays (
        post_id INTEGER PRIMARY KEY NOT NULL,
        stay_type TEXT,
        area REAL,
        bedrooms INTEGER,
        FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE activities (
        post_id INTEGER PRIMARY KEY NOT NULL,
        activity_type TEXT,
        requirements TEXT,
        FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE vehicles (
        post_id INTEGER PRIMARY KEY NOT NULL,
        vehicle_type TEXT,
        model TEXT,
        year INTEGER,
        fuel_type TEXT,
        transmission BOOLEAN,
        seats INTEGER,
        features TEXT,
        FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER NOT NULL,
        client_id INTEGER NOT NULL,
        status TEXT DEFAULT 'pending' CHECK(status IN ('confirmed', 'rejected', 'pending')),
        booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        end_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (post_id) REFERENCES posts(id),
        FOREIGN KEY (client_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE reviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        post_id INTEGER NOT NULL,
        reviewer_id INTEGER NOT NULL,
        rating INTEGER NOT NULL,
        comment TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (post_id) REFERENCES posts(id),
        FOREIGN KEY (reviewer_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reporter_id INTEGER NOT NULL,
        reported_post_id INTEGER,
        reported_user_id INTEGER,
        reason TEXT NOT NULL CHECK(reason IN ('inappropriate_content', 'scam_spam', 'misleading_info', 'safety_concerns', 'other')),
        additional_details TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (reporter_id) REFERENCES users(id),
        FOREIGN KEY (reported_post_id) REFERENCES posts(id),
        FOREIGN KEY (reported_user_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subscriber_id INTEGER NOT NULL,
        plan TEXT DEFAULT 'free' CHECK(plan IN ('free', 'monthly', 'yearly')),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (subscriber_id) REFERENCES users(id)
      )
    ''');
  }
}