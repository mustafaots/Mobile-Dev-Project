import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:easy_vacation/models/reviews.model.dart';
import 'package:easy_vacation/repositories/db_repositories/db_repo.dart';
import 'package:easy_vacation/services/api/api_services.dart';
import 'package:easy_vacation/services/sync/sync_state.dart';
import 'package:easy_vacation/services/sync/connectivity_service.dart';
import 'package:easy_vacation/main.dart';

/// Service for synchronizing reviews between remote and local
class ReviewSyncService implements Syncable {
  static ReviewSyncService? _instance;
  
  final ReviewService _reviewService;
  final ReviewRepository _reviewRepository;
  final ConnectivityService _connectivity;
  
  final StreamController<SyncState> _stateController = StreamController<SyncState>.broadcast();
  SyncState _currentState = const SyncState();

  // Cache for reviews by listing ID
  final Map<int, List<ReviewWithDetails>> _reviewsCache = {};
  final Map<int, RatingSummary> _ratingsCache = {};

  ReviewSyncService._internal({
    required ReviewService reviewService,
    required ReviewRepository reviewRepository,
    required ConnectivityService connectivity,
  }) : _reviewService = reviewService,
       _reviewRepository = reviewRepository,
       _connectivity = connectivity;

  static Future<ReviewSyncService> getInstance() async {
    if (_instance == null) {
      final reviewRepo = appRepos['reviewRepo'] as ReviewRepository;
      _instance = ReviewSyncService._internal(
        reviewService: ReviewService.instance,
        reviewRepository: reviewRepo,
        connectivity: ConnectivityService.instance,
      );
    }
    return _instance!;
  }

  /// Stream of sync state changes
  Stream<SyncState> get stateStream => _stateController.stream;
  
  /// Current sync state
  SyncState get currentState => _currentState;

  void _updateState(SyncState state) {
    _currentState = state;
    _stateController.add(state);
  }

  /// Get reviews for a listing
  Future<List<ReviewWithDetails>> getReviewsForListing(int listingId, {bool forceRefresh = false}) async {
    // Check cache
    if (!forceRefresh && _reviewsCache.containsKey(listingId)) {
      return _reviewsCache[listingId]!;
    }

    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _reviewService.getReviewsForListing(listingId);
        
        if (result.isSuccess && result.data != null) {
          _reviewsCache[listingId] = result.data!;
          
          // Save to local
          await _saveReviewsLocally(result.data!.map((r) => r.review).toList());
          
          return result.data!;
        }
      } catch (e) {
        debugPrint('Error fetching reviews: $e');
      }
    }

    // Fallback to local
    final localReviews = await _reviewRepository.getReviewsByPostId(listingId);
    return localReviews.map((r) => ReviewWithDetails(review: r)).toList();
  }

  /// Get rating summary for a listing
  Future<RatingSummary?> getRatingSummary(int listingId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _ratingsCache.containsKey(listingId)) {
      return _ratingsCache[listingId];
    }

    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _reviewService.getRatingSummary(listingId);
        
        if (result.isSuccess && result.data != null) {
          _ratingsCache[listingId] = result.data!;
          return result.data;
        }
      } catch (e) {
        debugPrint('Error fetching rating summary: $e');
      }
    }

    // Calculate from local reviews
    final reviews = await _reviewRepository.getReviewsByPostId(listingId);
    if (reviews.isEmpty) return null;

    final totalRating = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    return RatingSummary(
      averageRating: totalRating / reviews.length,
      totalReviews: reviews.length,
      ratingDistribution: {},
    );
  }

  /// Get user's reviews
  Future<List<ReviewWithDetails>> getMyReviews({bool forceRefresh = false}) async {
    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _reviewService.getMyReviews();
        if (result.isSuccess && result.data != null) {
          return result.data!;
        }
      } catch (e) {
        debugPrint('Error fetching my reviews: $e');
      }
    }

    return [];
  }

  /// Create a new review
  Future<ApiResponse<Review>> createReview({
    required int listingId,
    required int rating,
    String? comment,
  }) async {
    _updateState(_currentState.copyWith(status: SyncStatus.syncing, message: 'Submitting review...'));

    if (!await _connectivity.checkConnectivity()) {
      _updateState(_currentState.copyWith(status: SyncStatus.offline));
      return ApiResponse.error('No internet connection. Please try again later.');
    }

    try {
      final result = await _reviewService.createReview(CreateReviewRequest(
        listingId: listingId,
        rating: rating,
        comment: comment,
      ));

      if (result.isSuccess && result.data != null) {
        // Add to local
        await _reviewRepository.insertReview(result.data!);
        
        // Invalidate cache for this listing
        _reviewsCache.remove(listingId);
        _ratingsCache.remove(listingId);

        _updateState(_currentState.copyWith(
          status: SyncStatus.success,
          lastSyncTime: DateTime.now(),
          message: 'Review submitted successfully',
        ));
      } else {
        _updateState(_currentState.copyWith(
          status: SyncStatus.error,
          message: result.message,
        ));
      }

      return result;
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: SyncStatus.error,
        message: e.toString(),
      ));
      return ApiResponse.error(e.toString());
    }
  }

  /// Update a review
  Future<ApiResponse<Review>> updateReview(int id, {int? rating, String? comment}) async {
    if (!await _connectivity.checkConnectivity()) {
      return ApiResponse.error('No internet connection. Please try again later.');
    }

    try {
      final result = await _reviewService.updateReview(id, rating: rating, comment: comment);
      
      if (result.isSuccess && result.data != null) {
        // Update local
        await _reviewRepository.updateReview(id, result.data!);
        
        // Invalidate caches
        _reviewsCache.clear();
        _ratingsCache.clear();
      }

      return result;
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Delete a review
  Future<ApiResponse<void>> deleteReview(int id) async {
    if (!await _connectivity.checkConnectivity()) {
      return ApiResponse.error('No internet connection. Please try again later.');
    }

    try {
      final result = await _reviewService.deleteReview(id);
      
      if (result.isSuccess) {
        await _reviewRepository.deleteReview(id);
        _reviewsCache.clear();
        _ratingsCache.clear();
      }

      return result;
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<void> _saveReviewsLocally(List<Review> reviews) async {
    for (final review in reviews) {
      try {
        final existing = review.id != null 
            ? await _reviewRepository.getReviewById(review.id!) 
            : null;
        if (existing != null) {
          await _reviewRepository.updateReview(review.id!, review);
        } else {
          await _reviewRepository.insertReview(review);
        }
      } catch (e) {
        debugPrint('Error saving review locally: $e');
      }
    }
  }

  @override
  Future<SyncResult> syncFromRemote() async {
    // Reviews are fetched per-listing, so we don't do a full sync here
    return SyncResult.success();
  }

  @override
  Future<SyncResult> syncToRemote() async {
    return SyncResult.success();
  }

  @override
  Future<void> clearLocalData() async {
    _reviewsCache.clear();
    _ratingsCache.clear();
    final reviews = await _reviewRepository.getAllReviews();
    for (final review in reviews) {
      if (review.id != null) {
        await _reviewRepository.deleteReview(review.id!);
      }
    }
  }

  void invalidateCache([int? listingId]) {
    if (listingId != null) {
      _reviewsCache.remove(listingId);
      _ratingsCache.remove(listingId);
    } else {
      _reviewsCache.clear();
      _ratingsCache.clear();
    }
  }

  void dispose() {
    _stateController.close();
    _instance = null;
  }
}
