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
    try {
      print('🏠 Listing.fromJson parsing id=${json['id']}, images=${json['images']}');
      
      // Parse images - can be array of strings (URLs) or array of image objects with secure_url
      List<String> imageUrls = [];
      if (json['images'] != null) {
        final imagesData = json['images'];
        print('🏠 imagesData type: ${imagesData.runtimeType}, value: $imagesData');
        if (imagesData is List) {
          for (var img in imagesData) {
            print('🏠 Processing image: type=${img.runtimeType}, value=$img');
            if (img is String) {
              imageUrls.add(img);
            } else if (img is Map) {
              // Image object from post_images table - handle both Map<String, dynamic> and Map<dynamic, dynamic>
              final imgMap = Map<String, dynamic>.from(img);
              final url = imgMap['secure_url'] ?? imgMap['url'] ?? imgMap['content_url'];
              print('🏠 Extracted URL: $url');
              if (url != null) {
                imageUrls.add(url.toString());
              }
            }
          }
        }
      }
      print('🏠 Final imageUrls: $imageUrls');
      
      // Parse location - can be a Map or a List (from Supabase join)
      Map<String, dynamic> locationMap = {};
      if (json['location'] != null) {
        final locData = json['location'];
        if (locData is Map) {
          locationMap = Map<String, dynamic>.from(locData);
        } else if (locData is List && locData.isNotEmpty) {
          // Supabase sometimes returns joined data as array
          locationMap = Map<String, dynamic>.from(locData.first as Map);
        }
      }
      
      // Parse stay_details - can be a Map or a List
      Map<String, dynamic>? stayDetailsMap;
      if (json['stay_details'] != null) {
        final stayData = json['stay_details'];
        if (stayData is Map) {
          stayDetailsMap = Map<String, dynamic>.from(stayData);
        } else if (stayData is List && stayData.isNotEmpty) {
          stayDetailsMap = Map<String, dynamic>.from(stayData.first as Map);
        }
      }
      
      // Parse vehicle_details - can be a Map or a List
      Map<String, dynamic>? vehicleDetailsMap;
      if (json['vehicle_details'] != null) {
        final vehicleData = json['vehicle_details'];
        if (vehicleData is Map) {
          vehicleDetailsMap = Map<String, dynamic>.from(vehicleData);
        } else if (vehicleData is List && vehicleData.isNotEmpty) {
          vehicleDetailsMap = Map<String, dynamic>.from(vehicleData.first as Map);
        }
      }
      
      // Parse activity_details - can be a Map or a List
      Map<String, dynamic>? activityDetailsMap;
      if (json['activity_details'] != null) {
        final activityData = json['activity_details'];
        if (activityData is Map) {
          activityDetailsMap = Map<String, dynamic>.from(activityData);
        } else if (activityData is List && activityData.isNotEmpty) {
          activityDetailsMap = Map<String, dynamic>.from(activityData.first as Map);
        }
      }
      
      return Listing(
        id: json['id'],
        ownerId: json['owner_id']?.toString() ?? '',
        category: json['category'] ?? 'stay',
        title: json['title'] ?? '',
        description: json['description'],
        price: (json['price'] ?? 0).toDouble(),
        status: json['status'] ?? 'draft',
        availability: json['availability'],
        location: Location.fromMap(locationMap),
        stayDetails: stayDetailsMap != null 
            ? Stay.fromMap({...stayDetailsMap, 'post_id': json['id'] ?? 0})
            : null,
        vehicleDetails: vehicleDetailsMap != null 
            ? Vehicle.fromMap({...vehicleDetailsMap, 'post_id': json['id'] ?? 0})
            : null,
        activityDetails: activityDetailsMap != null 
            ? Activity.fromMap({...activityDetailsMap, 'post_id': json['id'] ?? 0})
            : null,
        images: imageUrls,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );
    } catch (e) {
      print('❌ Error parsing Listing.fromJson: $e');
      print('📄 JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'category': category,
      'title': title,
      'price': price,
      'location': location.toMap(),
    };

    if (id != null) map['id'] = id;
    if (description != null && description!.isNotEmpty) map['description'] = description;
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
      final vehicleMap = <String, dynamic>{
        'vehicle_type': vehicleDetails!.vehicleType,
      };
      // Only include optional fields if they have values
      if (vehicleDetails!.model != null && vehicleDetails!.model!.isNotEmpty) {
        vehicleMap['model'] = vehicleDetails!.model;
      }
      if (vehicleDetails!.year != null) vehicleMap['year'] = vehicleDetails!.year;
      if (vehicleDetails!.fuelType != null && vehicleDetails!.fuelType!.isNotEmpty) {
        vehicleMap['fuel_type'] = vehicleDetails!.fuelType;
      }
      if (vehicleDetails!.transmission != null) vehicleMap['transmission'] = vehicleDetails!.transmission;
      if (vehicleDetails!.seats != null) vehicleMap['seats'] = vehicleDetails!.seats;
      if (vehicleDetails!.features != null) vehicleMap['features'] = vehicleDetails!.features;
      map['vehicle_details'] = vehicleMap;
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
  Future<ApiResponse<List<Listing>>> getListingsByOwner(String ownerId) async {
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
      print('🔍 Calling /api/listings/my/listings...');
      final response = await _apiClient.get(
        '${ApiConfig.listings}/my/listings',
        requiresAuth: true,
      );
      
      print('📥 getMyListings response type: ${response.runtimeType}');
      print('📥 getMyListings response: $response');
      
      // Handle different response structures
      dynamic listingsData;
      if (response is Map && response.containsKey('data')) {
        print('📦 Response has "data" key');
        listingsData = response['data'];
        print('📦 Data type: ${listingsData.runtimeType}');
      } else if (response is List) {
        print('📦 Response is a List directly');
        listingsData = response;
      } else {
        print('⚠️ Unexpected response structure: ${response.runtimeType}');
        return ApiResponse.error('Unexpected response structure');
      }
      
      if (listingsData is! List) {
        print('⚠️ Data is not a list: ${listingsData.runtimeType}');
        return ApiResponse.error('Expected list of listings');
      }
      
      print('🔄 Parsing ${listingsData.length} listings...');
      final List<Listing> listings = [];
      for (int i = 0; i < listingsData.length; i++) {
        try {
          final json = listingsData[i];
          print('  🔸 Item $i type: ${json.runtimeType}');
          if (json is! Map) {
            print('  ⚠️ Item $i is not a Map, skipping');
            continue;
          }
          final listing = Listing.fromJson(Map<String, dynamic>.from(json));
          listings.add(listing);
          print('  ✅ Parsed listing: ${listing.title}');
        } catch (e) {
          print('  ❌ Error parsing item $i: $e');
        }
      }
      
      print('✅ Successfully parsed ${listings.length} listings');
      return ApiResponse.success(listings);
    } catch (e, stackTrace) {
      print('❌ getMyListings error: $e');
      print('❌ Stack trace: $stackTrace');
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
