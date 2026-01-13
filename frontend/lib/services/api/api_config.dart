/// API Configuration for connecting to the backend server
class ApiConfig {
  // Base URL - change this to your backend server address
  // For Android emulator use: 10.0.2.2 (special alias for host machine)
  // For iOS simulator use: localhost
  // For physical device: use your computer's IP address

  // ⚠️ UPDATE THIS IP ADDRESS to your PC's current WiFi IP ⚠️
  static const String baseUrl = 'https://easyvacationbackend-a3135-0pwlsz8l.leapcell.dev/api';

  // iOS Simulator (uncomment to use)
  // static const String baseUrl = 'http://localhost:5000/api';
  
  // Android Emulator (uncomment to use)
  // static const String baseUrl = 'http://10.0.2.2:5000/api';
  
  // Alternative URLs for different environments
  static const String localUrl = 'http://localhost:5000';
  static const String emulatorUrl = 'http://10.0.2.2:5000/api';
  
  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  // API Endpoints
  static const String auth = '/auth';
  static const String listings = '/listings';
  static const String bookings = '/bookings';
  static const String reviews = '/reviews';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String users = '/users';
  static const String images = '/images';
}
