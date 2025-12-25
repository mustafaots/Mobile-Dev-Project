/// API Configuration for connecting to the backend server
class ApiConfig {
  // Base URL - change this to your backend server address
  // For local development on Android emulator use: 10.0.2.2
  // For local development on iOS simulator use: localhost

  // For physical device with ADB reverse: use localhost (adb reverse tcp:5000 tcp:5000)
  static const String baseUrl = 'http://localhost:5000/api';

  // For physical device on same network: use your computer's IP address
  // static const String baseUrl = 'http://10.175.244.199:5000/api';
  
  // Alternative URLs for different environments
  static const String localUrl = 'http://localhost:5000';
  static const String emulatorUrl = 'http://10.0.2.2:5000/api';
  
  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
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
