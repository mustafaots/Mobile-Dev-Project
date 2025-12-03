// lib/services/shared_prefs_service.dart
import 'package:easy_vacation/repositories/db_repositories/sharedprefs_repository.dart';
import 'package:easy_vacation/repositories/repo_factory.dart';

/// Service class for easy access to SharedPreferences throughout the app
class SharedPrefsService {
  static SharedPrefsRepository? _repository;
  static bool _isInitialized = false;

  /// Initialize the service (must be called before any other methods)
  static Future<void> init() async {
    if (_isInitialized) return;
    
    // Initialize through RepoFactory
    await RepoFactory.init();
    _repository = await RepoFactory.getRepository<SharedPrefsRepository>('sharedprefsRepo');
    _isInitialized = true;
  }

  /// Get the repository instance
  static SharedPrefsRepository get _repo {
    if (!_isInitialized || _repository == null) {
      throw Exception(
        'SharedPrefsService not initialized. '
        'Call SharedPrefsService.init() in main() before using.'
      );
    }
    return _repository!;
  }

  /// ============= THEME METHODS =============
  static String getTheme() => _repo.getTheme();
  static Future<bool> setTheme(String theme) => _repo.setTheme(theme);
  static Future<bool> toggleTheme() => _repo.toggleTheme();
  static bool isDarkTheme() => _repo.isDarkTheme();

  /// ============= LANGUAGE METHODS =============
  static String getLanguage() => _repo.getLanguage();
  static Future<bool> setLanguage(String languageCode) => _repo.setLanguage(languageCode);
  static String getLanguageName() => _repo.getLanguageName();
  static Map<String, String> getAvailableLanguages() => _repo.getAvailableLanguages();

  /// ============= APP STATE METHODS =============
  static bool isFirstLaunch() => _repo.isFirstLaunch();
  static Future<bool> setFirstLaunchCompleted() => _repo.setFirstLaunchCompleted();

  /// ============= UTILITY METHODS =============
  static Map<String, dynamic> getAllPreferences() => _repo.getAllPreferences();
  static Future<bool> clearAll() => _repo.clearAll();
  static Future<bool> clear(String key) => _repo.clear(key);
  
  /// Check if service is initialized
  static bool get isInitialized => _isInitialized;
}