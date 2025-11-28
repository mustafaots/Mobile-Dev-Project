import 'db_repositories/db_repo.dart';
import '../database/db_helper.dart';

class RepoFactory {
  static Future<Map<String, dynamic>> createAllRepos() async {
    final db = await DBHelper.getDatabase();
    //add your shared preferences instance here

    return {
      'userRepo': UserRepository(db),
      'postRepo': PostRepository(db),
      'locationRepo': LocationRepository(db),
      'bookingRepo': BookingRepository(db),
      'reviewRepo': ReviewRepository(db),
      'subscriptionRepo': SubscriptionRepository(db),
      'reportRepo': ReportRepository(db),
      //add your shared preferences initializations here
    };
  }
}
