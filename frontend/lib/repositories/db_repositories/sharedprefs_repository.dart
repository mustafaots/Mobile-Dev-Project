import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing app preferences (theme and language)
class SharedPrefsRepository {
  static SharedPrefsRepository? _instance;
  late SharedPreferences _prefs;

  // Keys for storage
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';
  static const String _isFirstLaunchKey = 'is_first_launch';

  // Default values
  static const String _defaultTheme = 'light'; // 'light' or 'dark'
  static const String _defaultLanguage = 'en'; // 'en', 'ar', 'fr'
  static const bool _defaultFirstLaunch = true;

  // Private constructor
  SharedPrefsRepository._();

  /// Factory constructor to get singleton instance
  factory SharedPrefsRepository.getInstance() {
    _instance ??= SharedPrefsRepository._();
    return _instance!;
  }

  /// Initialize the repository (must be called before use)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// ============= THEME METHODS =============

  /// Get current theme
  String getTheme() {
    return _prefs.getString(_themeKey) ?? _defaultTheme;
  }

  /// Set theme
  Future<bool> setTheme(String theme) {
    return _prefs.setString(_themeKey, theme);
  }

  /// Toggle between light and dark theme
  Future<bool> toggleTheme() {
    final currentTheme = getTheme();
    final newTheme = currentTheme == 'light' ? 'dark' : 'light';
    return setTheme(newTheme);
  }

  /// Check if dark theme is enabled
  bool isDarkTheme() {
    return getTheme() == 'dark';
  }

  /// ============= LANGUAGE METHODS =============

  /// Get current language
  String getLanguage() {
    return _prefs.getString(_languageKey) ?? _defaultLanguage;
  }

  /// Set language
  Future<bool> setLanguage(String languageCode) {
    return _prefs.setString(_languageKey, languageCode);
  }

  /// Get language name from code
  String getLanguageName() {
    final code = getLanguage();
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  /// Get all available languages
  Map<String, String> getAvailableLanguages() {
    return {
      'en': 'English',
      'ar': 'العربية',
      'fr': 'Français',
    };
  }

  /// ============= APP STATE METHODS =============

  /// Check if this is the first app launch
  bool isFirstLaunch() {
    return _prefs.getBool(_isFirstLaunchKey) ?? _defaultFirstLaunch;
  }

  /// Mark first launch as completed
  Future<bool> setFirstLaunchCompleted() {
    return _prefs.setBool(_isFirstLaunchKey, false);
  }

  /// ============= UTILITY METHODS =============

  /// Clear all preferences
  Future<bool> clearAll() {
    return _prefs.clear();
  }

  /// Clear specific preference
  Future<bool> clear(String key) {
    return _prefs.remove(key);
  }

  /// Get all stored preferences (for debugging)
  Map<String, dynamic> getAllPreferences() {
    return {
      'theme': getTheme(),
      'language': getLanguage(),
      'language_name': getLanguageName(),
      'is_first_launch': isFirstLaunch(),
    };
  }

  /// Check if preference exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}