import 'package:easy_vacation/services/api/api_services.dart';
import 'package:easy_vacation/services/sharedprefs.services.dart';
import 'package:easy_vacation/services/api/notification_service.dart';

/// Service locator and initializer for all API services
/// 
/// This class manages the initialization and provides easy access
/// to all API services throughout the application.
class ApiServiceLocator {
  static bool _isInitialized = false;

  // Service instances (singleton access)
  static AuthService get auth => AuthService.instance;
  static ListingService get listings => ListingService.instance;
  static BookingService get bookings => BookingService.instance;
  static ReviewService get reviews => ReviewService.instance;
  static ProfileService get profile => ProfileService.instance;
  static SearchService get search => SearchService.instance;
  static NotificationService get notificationService => NotificationService.instance;

  /// Initialize all API services
  /// Should be called in main() before runApp()
  static Future<void> init() async {
    if (_isInitialized) return;

    // Try to restore auth token from shared preferences
    await _restoreAuthSession();

    _isInitialized = true;
  }

  /// Restore authentication session from stored token
  static Future<void> _restoreAuthSession() async {
    try {
      // Make sure SharedPrefsService is initialized first
      if (!SharedPrefsService.isInitialized) {
        await SharedPrefsService.init();
      }

      // Get stored token (you'll need to add this to SharedPrefsService)
      // For now, we'll skip this - you can implement token storage later
      
    } catch (e) {
      // Silently fail - user will need to login again
      print('Failed to restore auth session: $e');
    }
  }

  /// Check if user is authenticated
  static bool get isAuthenticated => auth.isLoggedIn;

  /// Logout user and clear session
  static Future<void> logout() async {
    auth.logout();
    // Clear stored token from shared preferences if implemented
  }

  /// Get API client for advanced usage
  static ApiClient get client => ApiClient.instance;

  /// Update base URL (useful for switching environments)
  static void setBaseUrl(String url) {
    // This would require modifying ApiConfig to be mutable
    // For now, change the baseUrl in api_config.dart directly
  }
}
