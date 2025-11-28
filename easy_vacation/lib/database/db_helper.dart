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
            username TEXT NOT NULL UNIQUE,
            email TEXT NOT NULL UNIQUE,
            phone_number TEXT,
            first_name TEXT,
            last_name TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            is_verified BOOLEAN DEFAULT 0,
            profile_picture_url TEXT,
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
            category TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            price REAL NOT NULL,
            location_id INTEGER NOT NULL UNIQUE,
            content_url TEXT,
            is_paid BOOLEAN DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            status TEXT DEFAULT 'active',
            FOREIGN KEY (owner_id) REFERENCES users(id),
            FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE stays (
            id INTEGER PRIMARY KEY,
            post_id INTEGER NOT NULL UNIQUE,
            stay_type TEXT,
            bedrooms INTEGER,
            bathrooms INTEGER,
            max_guests INTEGER,
            amenities TEXT,
            check_in_time TEXT,
            check_out_time TEXT,
            size_sqft INTEGER,
            FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE activities (
            id INTEGER PRIMARY KEY,
            post_id INTEGER NOT NULL UNIQUE,
            activity_type TEXT,
            duration_hours INTEGER,
            difficulty_level TEXT,
            min_age INTEGER,
            included_items TEXT,
            requirements TEXT,
            group_size_max INTEGER,
            FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE vehicles (
            id INTEGER PRIMARY KEY,
            post_id INTEGER NOT NULL UNIQUE,
            vehicle_type TEXT,
            make TEXT,
            model TEXT,
            year INTEGER,
            fuel_type TEXT,
            transmission TEXT,
            seats INTEGER,
            features TEXT,
            mileage_km INTEGER,
            FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE bookings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            post_id INTEGER NOT NULL,
            client_id INTEGER NOT NULL,
            status TEXT DEFAULT 'pending',
            booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            start_date DATE,
            end_date DATE,
            total_price REAL,
            guest_count INTEGER DEFAULT 1,
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
            reason TEXT NOT NULL,
            status TEXT DEFAULT 'pending',
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
            host_id INTEGER NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (subscriber_id) REFERENCES users(id),
            FOREIGN KEY (host_id) REFERENCES users(id)
          )
        ''');
      },
      version: _databaseVersion,
    );

    return _database!;
  }
}
