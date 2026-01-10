import 'dart:math';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/services/api/review_service.dart';
import 'package:easy_vacation/services/sync/sync_manager.dart';

/// Algorithm for fetching featured listings
/// Selects 5 random listings from the top 10 highest-rated listings
class FeaturedListingsAlgorithm {
  static final FeaturedListingsAlgorithm _instance = FeaturedListingsAlgorithm._internal();
  factory FeaturedListingsAlgorithm() => _instance;
  FeaturedListingsAlgorithm._internal();

  static FeaturedListingsAlgorithm get instance => _instance;

  final Random _random = Random();
  
  // Cache for featured listings to avoid re-fetching on rebuilds
  List<Listing>? _cachedFeatured;
  String? _cachedCategory;
  DateTime? _cacheTime;
  
  // Cache duration - refresh featured listings every 5 minutes
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Fetches 5 random featured listings from the top 10 highest-rated
  /// 
  /// [category] - The listing category ('stay', 'vehicle', 'activity')
  /// [forceRefresh] - If true, bypasses cache and fetches new listings
  Future<List<Listing>> getFeaturedListings({
    required String category,
    bool forceRefresh = false,
  }) async {
    // Check cache validity
    if (!forceRefresh && 
        _cachedFeatured != null && 
        _cachedCategory == category &&
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < _cacheDuration) {
      return _cachedFeatured!;
    }

    try {
      // Fetch all listings for the category
      final allListings = await SyncManager.instance.listings.getListingsByCategory(
        category,
        forceRefresh: forceRefresh,
      );

      if (allListings.isEmpty) {
        _cachedFeatured = [];
        _cachedCategory = category;
        _cacheTime = DateTime.now();
        return [];
      }

      // Get ratings for all listings and sort by highest rating
      final listingsWithRatings = await _getListingsWithRatings(allListings);
      
      // Sort by rating (highest first), then by review count as tiebreaker
      listingsWithRatings.sort((a, b) {
        final ratingCompare = b.rating.compareTo(a.rating);
        if (ratingCompare != 0) return ratingCompare;
        return b.reviewCount.compareTo(a.reviewCount);
      });
      
      // Get top 10 highest-rated listings
      final top10 = listingsWithRatings.take(10).map((e) => e.listing).toList();
      
      // Randomly select up to 5 from the top 10
      final featured = _selectRandomListings(top10, 5);
      
      // Update cache
      _cachedFeatured = featured;
      _cachedCategory = category;
      _cacheTime = DateTime.now();

      return featured;
    } catch (e) {
      print('FeaturedListingsAlgorithm error: $e');
      return _cachedFeatured ?? [];
    }
  }

  /// Fetches ratings for all listings and returns them paired together
  Future<List<_ListingWithRating>> _getListingsWithRatings(List<Listing> listings) async {
    final results = <_ListingWithRating>[];
    
    // Fetch ratings in parallel for better performance
    final futures = listings.map((listing) async {
      if (listing.id == null) {
        return _ListingWithRating(listing: listing, rating: 0.0, reviewCount: 0);
      }
      
      try {
        final ratingSummary = await ReviewService.instance.getRatingSummary(listing.id!);
        if (ratingSummary.isSuccess && ratingSummary.data != null) {
          return _ListingWithRating(
            listing: listing,
            rating: ratingSummary.data!.averageRating,
            reviewCount: ratingSummary.data!.totalReviews,
          );
        }
      } catch (e) {
        print('Error fetching rating for listing ${listing.id}: $e');
      }
      
      return _ListingWithRating(listing: listing, rating: 0.0, reviewCount: 0);
    });
    
    results.addAll(await Future.wait(futures));
    return results;
  }

  /// Randomly selects [count] listings from the provided list
  List<Listing> _selectRandomListings(List<Listing> listings, int count) {
    if (listings.length <= count) {
      // Shuffle and return all if we have fewer than requested
      final shuffled = List<Listing>.from(listings);
      shuffled.shuffle(_random);
      return shuffled;
    }

    // Use Fisher-Yates shuffle to select random items
    final selected = <Listing>[];
    final indices = List<int>.generate(listings.length, (i) => i);
    
    for (int i = 0; i < count; i++) {
      final randomIndex = _random.nextInt(indices.length);
      selected.add(listings[indices[randomIndex]]);
      indices.removeAt(randomIndex);
    }

    return selected;
  }

  /// Clears the cached featured listings
  void clearCache() {
    _cachedFeatured = null;
    _cachedCategory = null;
    _cacheTime = null;
  }

  /// Refreshes featured listings for the given category
  Future<List<Listing>> refreshFeatured(String category) {
    return getFeaturedListings(category: category, forceRefresh: true);
  }
}

/// Helper class to pair a listing with its rating data
class _ListingWithRating {
  final Listing listing;
  final double rating;
  final int reviewCount;

  _ListingWithRating({
    required this.listing,
    required this.rating,
    required this.reviewCount,
  });
}
