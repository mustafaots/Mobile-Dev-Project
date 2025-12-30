import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_config.dart';
import 'package:easy_vacation/services/api/api_response.dart';
import 'package:easy_vacation/services/api/listing_service.dart';

/// Search suggestion
class SearchSuggestion {
  final String text;
  final String type; // 'location', 'listing', 'category'
  final String? icon;

  SearchSuggestion({
    required this.text,
    required this.type,
    this.icon,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      text: json['text'] ?? json['name'] ?? '',
      type: json['type'] ?? 'text',
      icon: json['icon'],
    );
  }
}

/// Location for search
class SearchLocation {
  final String wilaya;
  final String city;
  final int? listingCount;

  SearchLocation({
    required this.wilaya,
    required this.city,
    this.listingCount,
  });

  factory SearchLocation.fromJson(Map<String, dynamic> json) {
    return SearchLocation(
      wilaya: json['wilaya'] ?? '',
      city: json['city'] ?? '',
      listingCount: json['listing_count'] ?? json['count'],
    );
  }
}

/// Search Service for searching listings
class SearchService {
  static SearchService? _instance;
  final ApiClient _apiClient;

  SearchService._internal() : _apiClient = ApiClient.instance;

  /// Get singleton instance
  static SearchService get instance {
    _instance ??= SearchService._internal();
    return _instance!;
  }

  /// Full-text search across all listings
  /// 
  /// GET /api/search
  Future<ApiResponse<PaginatedResponse<Listing>>> search({
    String? query,
    String? category,
    String? wilaya,
    String? city,
    double? minPrice,
    double? maxPrice,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final params = <String, dynamic>{
        'limit': limit,
        'offset': offset,
      };
      
      if (query != null && query.isNotEmpty) params['q'] = query;
      if (category != null) params['category'] = category;
      if (wilaya != null) params['wilaya'] = wilaya;
      if (city != null) params['city'] = city;
      if (minPrice != null) params['min_price'] = minPrice;
      if (maxPrice != null) params['max_price'] = maxPrice;

      final response = await _apiClient.get(
        ApiConfig.search,
        queryParams: params,
      );

      // Debug: Print raw response to see what images look like
      print('🔍 SearchService.search raw response: ${response['data']?.length ?? 0} items');
      if (response['data'] != null && (response['data'] as List).isNotEmpty) {
        final firstItem = (response['data'] as List).first;
        print('🔍 First item images: ${firstItem['images']}');
      }

      final listings = (response['data'] as List<dynamic>)
          .map((json) => Listing.fromJson(json))
          .toList();
      
      // Debug: Print parsed listings to check images
      print('🔍 Parsed ${listings.length} listings');
      for (var listing in listings.take(3)) {
        print('🔍 Listing ${listing.id} images: ${listing.images.length} - ${listing.images}');
      }

      final meta = response['meta'] ?? {};

      return ApiResponse.success(PaginatedResponse(
        items: listings,
        total: meta['total'] ?? listings.length,
        limit: meta['limit'] ?? limit,
        offset: meta['offset'] ?? offset,
      ));
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get search suggestions based on query
  /// 
  /// GET /api/search/suggestions
  Future<ApiResponse<List<SearchSuggestion>>> getSuggestions(String query) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.search}/suggestions',
        queryParams: {'q': query},
      );

      final suggestions = (response['data'] as List<dynamic>? ?? response as List<dynamic>)
          .map((json) => SearchSuggestion.fromJson(json))
          .toList();

      return ApiResponse.success(suggestions);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get available locations for filtering
  /// 
  /// GET /api/search/locations
  Future<ApiResponse<List<SearchLocation>>> getLocations() async {
    try {
      final response = await _apiClient.get('${ApiConfig.search}/locations');

      final locations = (response['data'] as List<dynamic>? ?? response as List<dynamic>)
          .map((json) => SearchLocation.fromJson(json))
          .toList();

      return ApiResponse.success(locations);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get featured listings
  /// 
  /// GET /api/search/featured
  Future<ApiResponse<List<Listing>>> getFeatured() async {
    try {
      final response = await _apiClient.get('${ApiConfig.search}/featured');

      final listings = (response['data'] as List<dynamic>)
          .map((json) => Listing.fromJson(json))
          .toList();

      return ApiResponse.success(listings);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
