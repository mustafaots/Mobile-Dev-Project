import 'package:easy_vacation/models/posts.model.dart';
import 'package:easy_vacation/models/locations.model.dart';
import 'package:easy_vacation/models/stays.model.dart';
import 'package:easy_vacation/models/vehicles.model.dart';
import 'package:easy_vacation/models/activities.model.dart';
import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_config.dart';
import 'package:easy_vacation/services/api/api_response.dart';

/// Listing model that combines Post with its category-specific details
class Listing {
  final int? id;
  final String ownerId; // Changed to String for UUID support
  final String category; // 'stay', 'vehicle', 'activity'
  final String title;
  final String? description;
  final double price;
  final String status;
  final String? availability;
  final Location location;
  final Stay? stayDetails;
  final Vehicle? vehicleDetails;
  final Activity? activityDetails;
  final List<String> images;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Listing({
    this.id,
    required this.ownerId,
    required this.category,
    required this.title,
    this.description,
    required this.price,
    this.status = 'draft',
    this.availability,
    required this.location,
    this.stayDetails,
    this.vehicleDetails,
    this.activityDetails,
    this.images = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'],
      ownerId: json['owner_id']?.toString() ?? '',
      category: json['category'] ?? 'stay',
      title: json['title'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 'draft',
      availability: json['availability'],
      location: Location.fromMap(json['location'] ?? {}),
      stayDetails: json['stay_details'] != null 
          ? Stay.fromMap({...json['stay_details'], 'post_id': json['id'] ?? 0})
          : null,
      vehicleDetails: json['vehicle_details'] != null 
          ? Vehicle.fromMap({...json['vehicle_details'], 'post_id': json['id'] ?? 0})
          : null,
      activityDetails: json['activity_details'] != null 
          ? Activity.fromMap({...json['activity_details'], 'post_id': json['id'] ?? 0})
          : null,
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'category': category,
      'title': title,
      'price': price,
      'location': location.toMap(),
    };

    if (id != null) map['id'] = id;
    if (description != null) map['description'] = description;
    if (status.isNotEmpty) map['status'] = status;
    if (availability != null) map['availability'] = availability;
    if (images.isNotEmpty) map['images'] = images;

    // Add category-specific details
    if (stayDetails != null) {
      map['stay_details'] = {
        'stay_type': stayDetails!.stayType,
        'area': stayDetails!.area,
        'bedrooms': stayDetails!.bedrooms,
      };
    }

    if (vehicleDetails != null) {
      map['vehicle_details'] = {
        'vehicle_type': vehicleDetails!.vehicleType,
        'model': vehicleDetails!.model,
        'year': vehicleDetails!.year,
        'fuel_type': vehicleDetails!.fuelType,
        'transmission': vehicleDetails!.transmission,
        'seats': vehicleDetails!.seats,
        'features': vehicleDetails!.features,
      };
    }

    if (activityDetails != null) {
      map['activity_details'] = {
        'activity_type': activityDetails!.activityType,
        'requirements': activityDetails!.requirements,
      };
    }

    return map;
  }
}

/// Search filters for listings
class ListingFilters {
  final String? category;
  final String? wilaya;
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final String? stayType;
  final String? vehicleType;
  final String? activityType;
  final int limit;
  final int offset;

  ListingFilters({
    this.category,
    this.wilaya,
    this.city,
    this.minPrice,
    this.maxPrice,
    this.stayType,
    this.vehicleType,
    this.activityType,
    this.limit = 20,
    this.offset = 0,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    
    if (category != null) params['category'] = category;
    if (wilaya != null) params['wilaya'] = wilaya;
    if (city != null) params['city'] = city;
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    if (stayType != null) params['stay_type'] = stayType;
    if (vehicleType != null) params['vehicle_type'] = vehicleType;
    if (activityType != null) params['activity_type'] = activityType;
    params['limit'] = limit;
    params['offset'] = offset;

    return params;
  }

  ListingFilters copyWith({
    String? category,
    String? wilaya,
    String? city,
    double? minPrice,
    double? maxPrice,
    String? stayType,
    String? vehicleType,
    String? activityType,
    int? limit,
    int? offset,
  }) {
    return ListingFilters(
      category: category ?? this.category,
      wilaya: wilaya ?? this.wilaya,
      city: city ?? this.city,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      stayType: stayType ?? this.stayType,
      vehicleType: vehicleType ?? this.vehicleType,
      activityType: activityType ?? this.activityType,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}

/// Listing Service for managing listings with the backend
class ListingService {
  static ListingService? _instance;
  final ApiClient _apiClient;

  ListingService._internal() : _apiClient = ApiClient.instance;

  /// Get singleton instance
  static ListingService get instance {
    _instance ??= ListingService._internal();
    return _instance!;
  }

  /// Search/filter listings (public)
  /// 
  /// GET /api/listings
  Future<ApiResponse<PaginatedResponse<Listing>>> searchListings([ListingFilters? filters]) async {
    try {
      final response = await _apiClient.get(
        ApiConfig.listings,
        queryParams: filters?.toQueryParams(),
      );

      final listings = (response['data'] as List<dynamic>)
          .map((json) => Listing.fromJson(json))
          .toList();

      final meta = response['meta'] ?? {};
      
      return ApiResponse.success(PaginatedResponse(
        items: listings,
        total: meta['total'] ?? listings.length,
        limit: meta['limit'] ?? filters?.limit ?? 20,
        offset: meta['offset'] ?? filters?.offset ?? 0,
      ));
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get a single listing by ID (public)
  /// 
  /// GET /api/listings/:id
  Future<ApiResponse<Listing>> getListingById(int id) async {
    try {
      final response = await _apiClient.get('${ApiConfig.listings}/$id');
      final listing = Listing.fromJson(response['data'] ?? response);
      return ApiResponse.success(listing);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get listings by owner ID (public)
  /// 
  /// GET /api/listings/owner/:ownerId
  Future<ApiResponse<List<Listing>>> getListingsByOwner(int ownerId) async {
    try {
      final response = await _apiClient.get('${ApiConfig.listings}/owner/$ownerId');
      final listings = (response['data'] as List<dynamic>)
          .map((json) => Listing.fromJson(json))
          .toList();
      return ApiResponse.success(listings);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get current user's listings (authenticated)
  /// 
  /// GET /api/listings/my/listings
  Future<ApiResponse<List<Listing>>> getMyListings() async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.listings}/my/listings',
        requiresAuth: true,
      );
      final listings = (response['data'] as List<dynamic>)
          .map((json) => Listing.fromJson(json))
          .toList();
      return ApiResponse.success(listings);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Create a new listing (authenticated)
  /// 
  /// POST /api/listings
  Future<ApiResponse<Listing>> createListing(Listing listing) async {
    try {
      print('🔑 Auth token present: ${_apiClient.isAuthenticated}');
      print('📤 Sending to: ${ApiConfig.listings}');
      
      final body = listing.toJson();
      print('📤 Body: $body');
      
      final response = await _apiClient.post(
        ApiConfig.listings,
        body: body,
        requiresAuth: true,
      );
      
      print('📥 Response: $response');
      final createdListing = Listing.fromJson(response['data'] ?? response);
      return ApiResponse.success(createdListing);
    } catch (e) {
      print('❌ createListing error: $e');
      // Try to extract more details from the error
      if (e.toString().contains('ValidationException')) {
        print('❌ Validation error details - check the body being sent');
      }
      return ApiResponse.error(e.toString());
    }
  }

  /// Update an existing listing (authenticated)
  /// 
  /// PATCH /api/listings/:id
  Future<ApiResponse<Listing>> updateListing(int id, Listing listing) async {
    try {
      final response = await _apiClient.patch(
        '${ApiConfig.listings}/$id',
        body: listing.toJson(),
        requiresAuth: true,
      );
      final updatedListing = Listing.fromJson(response['data'] ?? response);
      return ApiResponse.success(updatedListing);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Delete a listing (authenticated)
  /// 
  /// DELETE /api/listings/:id
  Future<ApiResponse<void>> deleteListing(int id) async {
    try {
      await _apiClient.delete(
        '${ApiConfig.listings}/$id',
        requiresAuth: true,
      );
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Publish a listing (authenticated)
  /// 
  /// POST /api/listings/:id/publish
  Future<ApiResponse<Listing>> publishListing(int id) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.listings}/$id/publish',
        requiresAuth: true,
      );
      final listing = Listing.fromJson(response['data'] ?? response);
      return ApiResponse.success(listing);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Unpublish a listing (authenticated)
  /// 
  /// POST /api/listings/:id/unpublish
  Future<ApiResponse<Listing>> unpublishListing(int id) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.listings}/$id/unpublish',
        requiresAuth: true,
      );
      final listing = Listing.fromJson(response['data'] ?? response);
      return ApiResponse.success(listing);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get listing availability (public)
  /// 
  /// GET /api/listings/:id/availability
  Future<ApiResponse<Map<String, dynamic>>> checkAvailability(int id, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (startDate != null) params['start_date'] = startDate.toIso8601String();
      if (endDate != null) params['end_date'] = endDate.toIso8601String();

      final response = await _apiClient.get(
        '${ApiConfig.listings}/$id/availability',
        queryParams: params,
      );
      return ApiResponse.success(response['data'] ?? response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get unavailable dates for a listing (public)
  /// 
  /// GET /api/listings/:id/unavailable-dates
  Future<ApiResponse<List<DateTime>>> getUnavailableDates(int id) async {
    try {
      final response = await _apiClient.get('${ApiConfig.listings}/$id/unavailable-dates');
      final dates = (response['data'] as List<dynamic>?)
          ?.map((d) => DateTime.parse(d.toString()))
          .toList() ?? [];
      return ApiResponse.success(dates);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Upload images to a listing (authenticated)
  /// 
  /// POST /api/listings/:id/images
  Future<ApiResponse<List<String>>> uploadImages(int id, List<String> filePaths) async {
    try {
      final images = <String>[];
      
      for (final path in filePaths) {
        final response = await _apiClient.uploadFile(
          '${ApiConfig.listings}/$id/images',
          filePath: path,
          fieldName: 'image',
          requiresAuth: true,
        );
        if (response['data'] != null && response['data']['url'] != null) {
          images.add(response['data']['url']);
        }
      }

      return ApiResponse.success(images);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
