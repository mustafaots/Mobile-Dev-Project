import 'dart:math';
import 'package:easy_vacation/services/api/listing_service.dart';
import 'package:easy_vacation/services/sync/sync_manager.dart';

/// Algorithm for fetching featured listings
/// Randomly selects 5 listings from available listings for the featured section
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

  /// Fetches 5 random featured listings for the given category
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

      // Randomly select up to 5 listings
      final featured = _selectRandomListings(allListings, 5);
      
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
