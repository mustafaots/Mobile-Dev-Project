import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/repositories/db_repositories/db_repo.dart';
import 'package:easy_vacation/services/api/api_services.dart';
import 'package:easy_vacation/services/sync/sync_state.dart';
import 'package:easy_vacation/services/sync/connectivity_service.dart';
import 'package:easy_vacation/main.dart';

/// Service for synchronizing listings between remote and local
class ListingSyncService implements Syncable {
  static ListingSyncService? _instance;

  final ListingService _listingService;
  final SearchService _searchService;
  final PostRepository _postRepository;
  final LocationRepository _locationRepository;
  final ConnectivityService _connectivity;

  final StreamController<SyncState> _stateController =
      StreamController<SyncState>.broadcast();
  SyncState _currentState = const SyncState();

  // Cache for listings
  List<Listing> _cachedListings = [];
  DateTime? _lastFetchTime;

  // Category-specific cache
  final Map<String, List<Listing>> _categoryCache = {};
  final Map<String, DateTime> _categoryCacheTime = {};
  static const _cacheDuration = Duration(minutes: 5);

  ListingSyncService._internal({
    required ListingService listingService,
    required SearchService searchService,
    required PostRepository postRepository,
    required LocationRepository locationRepository,
    required ConnectivityService connectivity,
  }) : _listingService = listingService,
       _searchService = searchService,
       _postRepository = postRepository,
       _locationRepository = locationRepository,
       _connectivity = connectivity;

  static Future<ListingSyncService> getInstance() async {
    if (_instance == null) {
      final postRepo = appRepos['postRepo'] as PostRepository;
      final locationRepo = appRepos['locationRepo'] as LocationRepository;
      _instance = ListingSyncService._internal(
        listingService: ListingService.instance,
        searchService: SearchService.instance,
        postRepository: postRepo,
        locationRepository: locationRepo,
        connectivity: ConnectivityService.instance,
      );
    }
    return _instance!;
  }

  /// Stream of sync state changes
  Stream<SyncState> get stateStream => _stateController.stream;

  /// Current sync state
  SyncState get currentState => _currentState;

  /// Cached listings
  List<Listing> get cachedListings => _cachedListings;

  void _updateState(SyncState state) {
    _currentState = state;
    _stateController.add(state);
  }

  /// Get all listings - tries remote first, falls back to local
  Future<List<Listing>> getListings({
    ListingFilters? filters,
    bool forceRefresh = false,
  }) async {
    // Check if we should use cache
    if (!forceRefresh && _cachedListings.isNotEmpty && _lastFetchTime != null) {
      final cacheAge = DateTime.now().difference(_lastFetchTime!);
      if (cacheAge.inMinutes < 5) {
        return _filterCachedListings(filters);
      }
    }

    _updateState(
      _currentState.copyWith(
        status: SyncStatus.syncing,
        message: 'Loading listings...',
      ),
    );

    // Try to fetch from remote
    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _listingService.searchListings(filters);

        if (result.isSuccess && result.data != null) {
          _cachedListings = result.data!.items;
          _lastFetchTime = DateTime.now();

          // Save to local DB
          await _saveListingsLocally(result.data!.items);

          _updateState(
            _currentState.copyWith(
              status: SyncStatus.success,
              lastSyncTime: DateTime.now(),
            ),
          );

          return result.data!.items;
        }
      } catch (e) {
        debugPrint('Error fetching remote listings: $e');
      }
    }

    // Fallback to local database
    _updateState(
      _currentState.copyWith(
        status: SyncStatus.offline,
        message: 'Using offline data',
      ),
    );
    return await _getListingsFromLocal(filters);
  }

  /// Get featured listings
  Future<List<Listing>> getFeaturedListings({bool forceRefresh = false}) async {
    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _searchService.getFeatured();
        if (result.isSuccess && result.data != null) {
          return result.data!;
        }
      } catch (e) {
        debugPrint('Error fetching featured listings: $e');
      }
    }

    // Return from cached listings
    return _cachedListings.take(10).toList();
  }

  /// Get listings by category (stay, vehicle, activity)
  Future<List<Listing>> getListingsByCategory(
    String category, {
    bool forceRefresh = false,
  }) async {
    print('📋 getListingsByCategory: $category, forceRefresh: $forceRefresh');
    print('📋 isOnline: ${_connectivity.isOnline}');

    // Check category cache first (fast path - no network call)
    if (!forceRefresh && _categoryCache.containsKey(category)) {
      final cacheTime = _categoryCacheTime[category];
      if (cacheTime != null &&
          DateTime.now().difference(cacheTime) < _cacheDuration) {
        print(
          '📋 Returning cached data: ${_categoryCache[category]!.length} items',
        );
        final cachedItems = _categoryCache[category]!;
        if (cachedItems.isNotEmpty) {
          print('📋 First cached listing images: ${cachedItems.first.images}');
        }
        return _categoryCache[category]!;
      }
    }

    // Try to fetch from remote first when online
    if (_connectivity.isOnline) {
      try {
        print('📡 Fetching $category listings from backend...');
        final result = await _searchService.search(
          category: category,
          limit: 50,
        );

        if (result.isSuccess && result.data != null) {
          print(
            '✅ Got ${result.data!.items.length} $category listings from backend',
          );
          // Debug: Show images from API result
          for (var item in result.data!.items.take(2)) {
            print('✅ Listing ${item.id} images: ${item.images}');
          }
          _categoryCache[category] = result.data!.items;
          _categoryCacheTime[category] = DateTime.now();
          // Save to local DB in background
          _saveListingsLocally(result.data!.items);
          return result.data!.items;
        } else {
          print('⚠️ Backend search failed: ${result.message}');
        }
      } catch (e) {
        debugPrint('Error fetching remote $category listings: $e');
        print('❌ Exception fetching $category listings: $e');
      }
    } else {
      print('📴 Offline - skipping remote fetch');
    }

    // Fallback to local database
    print('📦 Falling back to local database...');
    final localListings = await _getListingsFromLocal(
      ListingFilters(category: category),
    );
    print('📦 Got ${localListings.length} local listings');

    if (localListings.isNotEmpty) {
      _categoryCache[category] = localListings;
      _categoryCacheTime[category] = DateTime.now();
    }

    return localListings;
  }

  /// Get listing by ID
  Future<Listing?> getListingById(int id, {bool forceRefresh = false}) async {
    debugPrint(
      '🔍 ListingSyncService.getListingById($id, forceRefresh: $forceRefresh)',
    );

    // Check cache first
    if (!forceRefresh) {
      final cached = _cachedListings.where((l) => l.id == id).firstOrNull;
      if (cached != null) {
        debugPrint('📦 Found in cache, images: ${cached.images.length}');
        // If cached has no images, try to fetch fresh
        if (cached.images.isEmpty) {
          debugPrint('⚠️ Cached listing has no images, fetching fresh...');
        } else {
          return cached;
        }
      }
    }

    // Try remote
    if (await _connectivity.checkConnectivity()) {
      try {
        debugPrint('🌐 Fetching from remote API...');
        final result = await _listingService.getListingById(id);
        debugPrint(
          '📥 API result: success=${result.isSuccess}, data=${result.data != null}',
        );
        if (result.isSuccess && result.data != null) {
          debugPrint('🖼️ Remote listing images: ${result.data!.images}');
          return result.data;
        }
      } catch (e) {
        debugPrint('❌ Error fetching listing $id: $e');
      }
    } else {
      debugPrint('📴 No connectivity');
    }

    // Fallback to local
    debugPrint('💾 Falling back to local database');
    final post = await _postRepository.getPostById(id);
    if (post != null) {
      return await _postToListing(post);
    }
    return null;
  }

  /// Get user's own listings
  Future<List<Listing>> getMyListings({bool forceRefresh = false}) async {
    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _listingService.getMyListings();
        if (result.isSuccess && result.data != null) {
          return result.data!;
        }
      } catch (e) {
        debugPrint('Error fetching my listings: $e');
      }
    }

    // Fallback to local - would need user ID
    return [];
  }

  /// Create a new listing
  Future<ApiResponse<Listing>> createListing(Listing listing) async {
    _updateState(
      _currentState.copyWith(
        status: SyncStatus.syncing,
        message: 'Creating listing...',
      ),
    );

    if (!await _connectivity.checkConnectivity()) {
      _updateState(_currentState.copyWith(status: SyncStatus.offline));
      return ApiResponse.error(
        'No internet connection. Please try again later.',
      );
    }

    try {
      final result = await _listingService.createListing(listing);

      if (result.isSuccess && result.data != null) {
        // Add to cache
        _cachedListings.insert(0, result.data!);

        // Save to local
        await _saveListingLocally(result.data!);

        _updateState(
          _currentState.copyWith(
            status: SyncStatus.success,
            lastSyncTime: DateTime.now(),
            message: 'Listing created successfully',
          ),
        );
      } else {
        _updateState(
          _currentState.copyWith(
            status: SyncStatus.error,
            message: result.message,
          ),
        );
      }

      return result;
    } catch (e) {
      _updateState(
        _currentState.copyWith(status: SyncStatus.error, message: e.toString()),
      );
      return ApiResponse.error(e.toString());
    }
  }

  /// Update a listing
  Future<ApiResponse<Listing>> updateListing(int id, Listing listing) async {
    if (!await _connectivity.checkConnectivity()) {
      return ApiResponse.error(
        'No internet connection. Please try again later.',
      );
    }

    try {
      final result = await _listingService.updateListing(id, listing);

      if (result.isSuccess && result.data != null) {
        // Update cache
        final index = _cachedListings.indexWhere((l) => l.id == id);
        if (index != -1) {
          _cachedListings[index] = result.data!;
        }

        // Save to local database
        await _saveListingLocally(result.data!);
      }

      return result;
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Delete a listing
  Future<ApiResponse<void>> deleteListing(int id) async {
    if (!await _connectivity.checkConnectivity()) {
      return ApiResponse.error(
        'No internet connection. Please try again later.',
      );
    }

    try {
      final result = await _listingService.deleteListing(id);

      if (result.isSuccess) {
        // Remove from cache
        _cachedListings.removeWhere((l) => l.id == id);

        // Remove from local
        await _postRepository.deletePost(id);
      }

      return result;
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Search listings
  Future<PaginatedResponse<Listing>> searchListings({
    String? query,
    String? category,
    String? wilaya,
    double? minPrice,
    double? maxPrice,
    int limit = 20,
    int offset = 0,
  }) async {
    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _searchService.search(
          query: query,
          category: category,
          wilaya: wilaya,
          minPrice: minPrice,
          maxPrice: maxPrice,
          limit: limit,
          offset: offset,
        );

        if (result.isSuccess && result.data != null) {
          return result.data!;
        }
      } catch (e) {
        debugPrint('Search error: $e');
      }
    }

    // Fallback to local search
    final localListings = await _getListingsFromLocal(
      ListingFilters(
        category: category,
        wilaya: wilaya,
        minPrice: minPrice,
        maxPrice: maxPrice,
        limit: limit,
        offset: offset,
      ),
    );

    return PaginatedResponse(
      items: localListings,
      total: localListings.length,
      limit: limit,
      offset: offset,
    );
  }

  // Helper methods

  List<Listing> _filterCachedListings(ListingFilters? filters) {
    if (filters == null) return _cachedListings;

    return _cachedListings.where((listing) {
      if (filters.category != null && listing.category != filters.category)
        return false;
      if (filters.wilaya != null && listing.location.wilaya != filters.wilaya)
        return false;
      if (filters.minPrice != null && listing.price < filters.minPrice!)
        return false;
      if (filters.maxPrice != null && listing.price > filters.maxPrice!)
        return false;
      return true;
    }).toList();
  }

  Future<List<Listing>> _getListingsFromLocal(ListingFilters? filters) async {
    try {
      final posts = await _postRepository.getPostsFiltered(
        category: filters?.category,
        wilaya: filters?.wilaya,
        maxPrice: filters?.maxPrice,
      );

      final listings = <Listing>[];
      for (final post in posts) {
        final listing = await _postToListing(post);
        if (listing != null) {
          listings.add(listing);
        }
      }
      return listings;
    } catch (e) {
      debugPrint('Error loading local listings: $e');
      return [];
    }
  }

  Future<Listing?> _postToListing(Post post) async {
    try {
      final location = await _locationRepository.getLocationById(
        post.locationId,
      );
      if (location == null) return null;

      return Listing(
        id: post.id,
        ownerId: post.ownerId,
        category: post.category,
        title: post.title,
        description: post.description,
        price: post.price,
        status: post.status,
        location: location,
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveListingsLocally(List<Listing> listings) async {
    for (final listing in listings) {
      await _saveListingLocally(listing);
    }
  }

  Future<void> _saveListingLocally(Listing listing) async {
    try {
      print('📦 _saveListingLocally: id=${listing.id}, title=${listing.title}');
      print('📦 Listing.availability: ${listing.availability}');

      // Save location first
      int locationId;
      final existingLocation = await _locationRepository.getLocationByAddress(
        listing.location.wilaya,
        listing.location.city,
        listing.location.address,
      );

      if (existingLocation != null) {
        locationId = existingLocation.id!;
      } else {
        locationId = await _locationRepository.insertLocation(listing.location);
      }

      // Parse availability
      final parsedAvailability = _parseAvailabilityFromListing(
        listing.availability,
      );
      print('📦 Parsed availability: $parsedAvailability');

      // Save post
      final post = Post(
        id: listing.id,
        ownerId: listing.ownerId,
        category: listing.category,
        title: listing.title,
        description: listing.description,
        price: listing.price,
        locationId: locationId,
        status: listing.status,
        createdAt: listing.createdAt ?? DateTime.now(),
        updatedAt: listing.updatedAt ?? DateTime.now(),
        availability: parsedAvailability,
      );

      final existingPost = listing.id != null
          ? await _postRepository.getPostById(listing.id!)
          : null;
      if (existingPost != null) {
        await _postRepository.updatePost(listing.id!, post);
      } else {
        await _postRepository.insertPost(post);
      }
      print('📦 Post saved successfully');

      // Save category-specific details
      if (listing.id != null) {
        final category = listing.category.toLowerCase();
        switch (category) {
          case 'stay':
            if (listing.stayDetails != null) {
              final stay = Stay(
                postId: listing.id!,
                stayType: listing.stayDetails!.stayType,
                area: listing.stayDetails!.area,
                bedrooms: listing.stayDetails!.bedrooms,
              );
              final existingStay = await _postRepository.getStayByPostId(
                listing.id!,
              );
              if (existingStay != null) {
                await _postRepository.updateStay(listing.id!, stay);
              } else {
                await _postRepository.insertStay(stay);
              }
              print(' Stay details saved');
            }
            break;
          case 'vehicle':
            if (listing.vehicleDetails != null) {
              final vehicle = Vehicle(
                postId: listing.id!,
                vehicleType: listing.vehicleDetails!.vehicleType,
                model: listing.vehicleDetails!.model,
                year: listing.vehicleDetails!.year,
                fuelType: listing.vehicleDetails!.fuelType,
                transmission: listing.vehicleDetails!.transmission,
                seats: listing.vehicleDetails!.seats,
                features: listing.vehicleDetails!.features,
              );
              final existingVehicle = await _postRepository.getVehicleByPostId(
                listing.id!,
              );
              if (existingVehicle != null) {
                await _postRepository.updateVehicle(listing.id!, vehicle);
              } else {
                await _postRepository.insertVehicle(vehicle);
              }
              print(' Vehicle details saved');
            }
            break;
          case 'activity':
            if (listing.activityDetails != null) {
              final activity = Activity(
                postId: listing.id!,
                activityType: listing.activityDetails!.activityType,
                requirements: listing.activityDetails!.requirements,
              );
              final existingActivity = await _postRepository
                  .getActivityByPostId(listing.id!);
              if (existingActivity != null) {
                await _postRepository.updateActivity(listing.id!, activity);
              } else {
                await _postRepository.insertActivity(activity);
              }
              print(' Activity details saved');
            }
            break;
        }
      }
    } catch (e) {
      debugPrint('Error saving listing locally: $e');
    }
  }

  @override
  Future<SyncResult> syncFromRemote() async {
    if (!await _connectivity.checkConnectivity()) {
      return SyncResult.offline();
    }

    try {
      final result = await _listingService.searchListings(
        ListingFilters(limit: 100),
      );
      if (result.isSuccess && result.data != null) {
        await _saveListingsLocally(result.data!.items);
        _cachedListings = result.data!.items;
        _lastFetchTime = DateTime.now();
        return SyncResult.success(itemsSynced: result.data!.items.length);
      }
      return SyncResult.error(result.message ?? 'Failed to sync listings');
    } catch (e) {
      return SyncResult.error(e.toString());
    }
  }

  @override
  Future<SyncResult> syncToRemote() async {
    // Listings are created/updated immediately via API
    return SyncResult.success();
  }

  @override
  Future<void> clearLocalData() async {
    _cachedListings.clear();
    _lastFetchTime = null;
    final posts = await _postRepository.getAllPosts();
    for (final post in posts) {
      if (post.id != null) {
        await _postRepository.deletePost(post.id!);
      }
    }
  }

  /// Invalidate cache to force refresh on next fetch
  void invalidateCache() {
    _lastFetchTime = null;
  }

  /// Parse availability JSON string from Listing to List<Map<String, DateTime>> for Post
  List<Map<String, DateTime>> _parseAvailabilityFromListing(
    String? availabilityJson,
  ) {
    if (availabilityJson == null || availabilityJson.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(availabilityJson);
      List<dynamic> intervals;

      if (decoded is List) {
        intervals = decoded;
      } else if (decoded is Map<String, dynamic> &&
          decoded['intervals'] is List) {
        intervals = decoded['intervals'] as List<dynamic>;
      } else {
        return [];
      }

      return intervals
          .map((interval) {
            try {
              final map = Map<String, dynamic>.from(interval as Map);
              final startValue =
                  map['startDate'] ?? map['start'] ?? map['start_date'];
              final endValue = map['endDate'] ?? map['end'] ?? map['end_date'];

              DateTime? parseDate(dynamic value) {
                if (value is DateTime) return value;
                if (value is String && value.isNotEmpty) {
                  try {
                    return DateTime.parse(value);
                  } catch (_) {
                    return null;
                  }
                }
                return null;
              }

              final startDate = parseDate(startValue);
              final endDate = parseDate(endValue);

              if (startDate == null || endDate == null) {
                return null;
              }

              return <String, DateTime>{
                'startDate': startDate,
                'endDate': endDate,
              };
            } catch (_) {
              return null;
            }
          })
          .whereType<Map<String, DateTime>>()
          .toList();
    } catch (e) {
      debugPrint('Error parsing availability: $e');
      return [];
    }
  }

  void dispose() {
    _stateController.close();
    _instance = null;
  }
}
