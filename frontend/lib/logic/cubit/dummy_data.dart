import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';

/// Dummy data providers for testing and fallback scenarios
class DummyDataProvider {
  static Post getDummyPost(int postId) {
    final now = DateTime.now();

    switch (postId % 3) {
      case 1:
        return Post(
          id: postId,
          ownerId: 50,
          category: 'stay',
          title: 'Luxury Beachfront Villa',
          description:
              'Stunning beachfront villa with private pool, ocean views, and direct beach access.',
          price: 250.0,
          locationId: 1,
          contentUrl: 'assets/images/placeholder.jpg',
          status: 'active',
          isPaid: false,
          createdAt: now,
          updatedAt: now,
          availability: [],
        );
      case 2:
        return Post(
          id: postId,
          ownerId: 51,
          category: 'vehicle',
          title: 'Premium Mercedes-Benz SUV',
          description:
              'Luxury SUV with advanced features, full insurance included.',
          price: 150.0,
          locationId: 2,
          contentUrl: 'assets/images/placeholder.jpg',
          status: 'active',
          isPaid: false,
          createdAt: now,
          updatedAt: now,
          availability: [],
        );
      default:
        return Post(
          id: postId,
          ownerId: 52,
          category: 'activity',
          title: 'Mountain Hiking Adventure',
          description:
              'Guided hiking tour through scenic mountain trails with professional guide.',
          price: 80.0,
          locationId: 3,
          contentUrl: 'assets/images/placeholder.jpg',
          status: 'active',
          isPaid: false,
          createdAt: now,
          updatedAt: now,
          availability: [],
        );
    }
  }

  static User getDummyHost(int ownerId) {
    switch (ownerId % 3) {
      case 0:
        return User(
          id: ownerId,
          username: 'john_owner',
          email: 'john.owner@email.com',
          firstName: 'John',
          lastName: 'Anderson',
          phoneNumber: '+1234567890',
          isVerified: true,
          userType: 'host',
          createdAt: DateTime.now(),
        );
      case 1:
        return User(
          id: ownerId,
          username: 'sarah_owner',
          email: 'sarah.owner@email.com',
          firstName: 'Sarah',
          lastName: 'Wilson',
          phoneNumber: '+1234567891',
          isVerified: true,
          userType: 'host',
          createdAt: DateTime.now(),
        );
      default:
        return User(
          id: ownerId,
          username: 'mike_owner',
          email: 'mike.owner@email.com',
          firstName: 'Mike',
          lastName: 'Johnson',
          phoneNumber: '+1234567892',
          isVerified: true,
          userType: 'host',
          createdAt: DateTime.now(),
        );
    }
  }

  static List<Review> getDummyReviews(int postId) {
    final now = DateTime.now();
    return [
      Review(
        id: 1,
        postId: postId,
        reviewerId: 100,
        rating: 5,
        comment: 'Excellent experience! Highly recommended.',
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      Review(
        id: 2,
        postId: postId,
        reviewerId: 101,
        rating: 4,
        comment: 'Great property with responsive host.',
        createdAt: now.subtract(const Duration(days: 15)),
      ),
    ];
  }

  static Map<int, User> getDummyReviewers(List<Review> reviews) {
    final reviewers = <int, User>{};
    for (var review in reviews) {
      switch (review.reviewerId % 2) {
        case 0:
          reviewers[review.reviewerId] = User(
            id: review.reviewerId,
            username: 'alex_traveler',
            email: 'reviewer1@email.com',
            firstName: 'Alex',
            lastName: 'Thompson',
            phoneNumber: '+1234567893',
            isVerified: true,
            userType: 'tourist',
            createdAt: DateTime.now(),
          );
          break;
        default:
          reviewers[review.reviewerId] = User(
            id: review.reviewerId,
            username: 'emma_adventure',
            email: 'reviewer2@email.com',
            firstName: 'Emma',
            lastName: 'Davis',
            phoneNumber: '+1234567894',
            isVerified: true,
            userType: 'tourist',
            createdAt: DateTime.now(),
          );
      }
    }
    return reviewers;
  }

  // Get dummy stay details
  static Stay getDummyStayDetails(int postId) {
    switch (postId % 3) {
      case 1:
        return Stay(
          postId: postId,
          stayType: 'villa',
          area: 350.0,
          bedrooms: 5,
        );
      case 2:
        return Stay(
          postId: postId,
          stayType: 'apartment',
          area: 120.0,
          bedrooms: 2,
        );
      default:
        return Stay(postId: postId, stayType: 'room', area: 45.0, bedrooms: 1);
    }
  }

  // Get dummy vehicle details
  static Vehicle getDummyVehicleDetails(int postId) {
    switch (postId % 3) {
      case 1:
        return Vehicle(
          postId: postId,
          vehicleType: 'suv',
          model: 'Mercedes-Benz GLE',
          year: 2023,
          fuelType: 'diesel',
          transmission: true, // automatic
          seats: 5,
          features: {
            'airConditioning': true,
            'cruiseControl': true,
            'leatherSeats': true,
            'sunroof': true,
            'navigation': true,
          },
        );
      case 2:
        return Vehicle(
          postId: postId,
          vehicleType: 'sedan',
          model: 'BMW 320i',
          year: 2022,
          fuelType: 'gasoline',
          transmission: true,
          seats: 5,
          features: {
            'airConditioning': true,
            'cruiseControl': true,
            'bluetooth': true,
            'backupCamera': true,
          },
        );
      default:
        return Vehicle(
          postId: postId,
          vehicleType: 'hatchback',
          model: 'Honda Civic',
          year: 2021,
          fuelType: 'gasoline',
          transmission: false, // manual
          seats: 5,
          features: {
            'airConditioning': true,
            'powerWindows': true,
            'bluetooth': true,
          },
        );
    }
  }

  // Get dummy activity details
  static Activity getDummyActivityDetails(int postId) {
    switch (postId % 3) {
      case 1:
        return Activity(
          postId: postId,
          activityType: 'guided tour',
          requirements: {
            'minAge': 12,
            'maxGroup': 15,
            'duration': '4 hours',
            'difficulty': 'moderate',
            'include': ['guide', 'lunch', 'equipment'],
            'language': 'English, French',
          },
        );
      case 2:
        return Activity(
          postId: postId,
          activityType: 'adventure sport',
          requirements: {
            'minAge': 18,
            'maxGroup': 8,
            'duration': '3 hours',
            'difficulty': 'high',
            'include': ['instructor', 'equipment', 'insurance'],
            'language': 'English, Spanish',
          },
        );
      default:
        return Activity(
          postId: postId,
          activityType: 'workshop',
          requirements: {
            'minAge': 8,
            'maxGroup': 12,
            'duration': '2 hours',
            'difficulty': 'easy',
            'include': ['materials', 'certificate'],
            'language': 'English',
          },
        );
    }
  }
}
