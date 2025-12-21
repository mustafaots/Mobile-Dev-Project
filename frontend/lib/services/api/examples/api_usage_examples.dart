// ignore_for_file: unused_local_variable
/// Example Usage of API Services
/// 
/// This file demonstrates how to use the API services to connect
/// to the backend and perform common operations.

import 'package:easy_vacation/models/locations.model.dart';
import 'package:easy_vacation/services/api/api_services.dart';
import 'package:easy_vacation/services/api/api_service_locator.dart';

/// Example: User Registration
Future<void> exampleRegister() async {
  final request = RegisterRequest(
    email: 'user@example.com',
    password: 'securePassword123',
    firstName: 'John',
    lastName: 'Doe',
  );

  final result = await ApiServiceLocator.auth.register(request);

  if (result.isSuccess) {
    final authResult = result.data!;
    print('Registered successfully!');
    print('User: ${authResult.user.email}');
    print('Token: ${authResult.accessToken}');
  } else {
    print('Registration failed: ${result.message}');
  }
}

/// Example: User Login
Future<void> exampleLogin() async {
  final request = LoginRequest(
    email: 'user@example.com',
    password: 'securePassword123',
  );

  final result = await ApiServiceLocator.auth.login(request);

  if (result.isSuccess) {
    final authResult = result.data!;
    print('Logged in successfully!');
    print('Welcome, ${authResult.user.firstName ?? authResult.user.email}');
    // Token is automatically stored in ApiClient
  } else {
    print('Login failed: ${result.message}');
  }
}

/// Example: Search Listings
Future<void> exampleSearchListings() async {
  // Search with filters
  final filters = ListingFilters(
    category: 'stay',
    wilaya: 'Algiers',
    minPrice: 1000,
    maxPrice: 5000,
    limit: 10,
  );

  final result = await ApiServiceLocator.listings.searchListings(filters);

  if (result.isSuccess) {
    final paginatedResult = result.data!;
    print('Found ${paginatedResult.total} listings');
    
    for (final listing in paginatedResult.items) {
      print('- ${listing.title}: ${listing.price} DZD');
    }

    if (paginatedResult.hasMore) {
      print('Load more with offset: ${paginatedResult.nextOffset}');
    }
  }
}

/// Example: Create a Listing
Future<void> exampleCreateListing() async {
  // Must be authenticated first
  if (!ApiServiceLocator.isAuthenticated) {
    print('Please login first');
    return;
  }

  final listing = Listing(
    ownerId: '', // Will be set by backend from auth token
    category: 'stay',
    title: 'Beautiful Apartment in Algiers',
    description: 'A cozy 2-bedroom apartment with sea view',
    price: 3500,
    location: Location(
      wilaya: 'Algiers',
      city: 'Bab El Oued',
      address: '123 Main Street',
      latitude: 36.7753,
      longitude: 3.0588,
    ),
    // Add stay-specific details if needed
  );

  final result = await ApiServiceLocator.listings.createListing(listing);

  if (result.isSuccess) {
    print('Listing created with ID: ${result.data!.id}');
  } else {
    print('Failed to create listing: ${result.message}');
  }
}

/// Example: Create a Booking
Future<void> exampleCreateBooking() async {
  if (!ApiServiceLocator.isAuthenticated) {
    print('Please login first');
    return;
  }

  final request = CreateBookingRequest(
    listingId: 1,
    startDate: DateTime.now().add(const Duration(days: 7)),
    endDate: DateTime.now().add(const Duration(days: 10)),
    notes: 'Looking forward to my stay!',
  );

  final result = await ApiServiceLocator.bookings.createBooking(request);

  if (result.isSuccess) {
    print('Booking created with ID: ${result.data!.id}');
    print('Status: ${result.data!.status}');
  } else {
    print('Failed to create booking: ${result.message}');
  }
}

/// Example: Leave a Review
Future<void> exampleCreateReview() async {
  if (!ApiServiceLocator.isAuthenticated) {
    print('Please login first');
    return;
  }

  final request = CreateReviewRequest(
    listingId: 1,
    rating: 5,
    comment: 'Amazing place! Great host and perfect location.',
  );

  final result = await ApiServiceLocator.reviews.createReview(request);

  if (result.isSuccess) {
    print('Review submitted successfully');
  } else {
    print('Failed to submit review: ${result.message}');
  }
}

/// Example: Get User Profile
Future<void> exampleGetProfile() async {
  if (!ApiServiceLocator.isAuthenticated) {
    print('Please login first');
    return;
  }

  final result = await ApiServiceLocator.profile.getMyProfile();

  if (result.isSuccess) {
    final profile = result.data!;
    print('Profile: ${profile.user.firstName} ${profile.user.lastName}');
    print('Total Listings: ${profile.totalListings ?? 0}');
    print('Average Rating: ${profile.averageRating ?? 'N/A'}');
  }
}

/// Example: Update Profile
Future<void> exampleUpdateProfile() async {
  if (!ApiServiceLocator.isAuthenticated) {
    print('Please login first');
    return;
  }

  final request = UpdateProfileRequest(
    firstName: 'John',
    lastName: 'Smith',
    phone: '+213555123456',
  );

  final result = await ApiServiceLocator.profile.updateMyProfile(request);

  if (result.isSuccess) {
    print('Profile updated successfully');
  }
}

/// Example: Search with Query
Future<void> exampleSearch() async {
  // Full-text search
  final result = await ApiServiceLocator.search.search(
    query: 'beach villa',
    category: 'stay',
    limit: 20,
  );

  if (result.isSuccess) {
    print('Search results: ${result.data!.total}');
  }

  // Get search suggestions
  final suggestions = await ApiServiceLocator.search.getSuggestions('alg');
  
  if (suggestions.isSuccess) {
    for (final suggestion in suggestions.data!) {
      print('Suggestion: ${suggestion.text} (${suggestion.type})');
    }
  }

  // Get featured listings
  final featured = await ApiServiceLocator.search.getFeatured();
  
  if (featured.isSuccess) {
    print('Featured listings: ${featured.data!.length}');
  }
}

/// Example: Logout
void exampleLogout() {
  ApiServiceLocator.logout();
  print('Logged out successfully');
}

/// Example: Handle Errors
Future<void> exampleErrorHandling() async {
  try {
    final result = await ApiServiceLocator.auth.login(
      LoginRequest(email: 'test@test.com', password: 'wrong'),
    );

    if (result.isError) {
      // Handle application-level error
      print('Error: ${result.message}');
    }
  } on UnauthorizedException {
    // Handle 401 error
    print('Invalid credentials');
  } on NetworkException {
    // Handle network error
    print('No internet connection');
  } on ApiException catch (e) {
    // Handle other API errors
    print('API Error: ${e.message}');
  }
}
