import 'db_repositories/db_repo.dart';
import '../database/db_helper.dart';
import 'db_repositories/sharedprefs_repository.dart';

class RepoFactory {
  static Map<String, dynamic>? _repositories;

  /// Get all repositories
  static Future<Map<String, dynamic>> getRepositories() async {
    if (_repositories != null) return _repositories!;
    
    _repositories = await _createAllRepos();
    return _repositories!;
  }

  /// Get a specific repository
  static Future<T> getRepository<T>(String key) async {
    final repos = await getRepositories();
    return repos[key] as T;
  }

  /// Initialize all repositories
  static Future<void> init() async {
    await getRepositories(); // This will create and cache them
  }

  /// Create all repositories (private)
  static Future<Map<String, dynamic>> _createAllRepos() async {
    // Get SQLite database
    final db = await DBHelper.getDatabase();
    
    // Initialize SharedPreferences repository
    final sharedPrefsRepo = SharedPrefsRepository.getInstance();
    await sharedPrefsRepo.init();
    
    return {
      'userRepo': UserRepository(db),
      'postRepo': PostRepository(db),
      'locationRepo': LocationRepository(db),
      'bookingRepo': BookingRepository(db),
      'reviewRepo': ReviewRepository(db),
      'subscriptionRepo': SubscriptionRepository(db),
      'reportRepo': ReportRepository(db),
      'imageRepo': ImagesRepository(db),
      'sharedprefsRepo': sharedPrefsRepo,
    };
  }

  /// Clear repositories (for testing/logout)
  static void clear() {
    _repositories = null;
  }
}