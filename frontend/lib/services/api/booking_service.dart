import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_config.dart';
import 'package:easy_vacation/services/api/api_response.dart';

/// Request model for creating a booking
class CreateBookingRequest {
  final int listingId;
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;

  CreateBookingRequest({
    required this.listingId,
    required this.startDate,
    required this.endDate,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'listing_id': listingId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      if (notes != null) 'notes': notes,
    };
  }
}

/// Booking with listing details for display
class BookingWithDetails {
  final Booking booking;
  final String? listingTitle;
  final String? listingCategory;
  final String? ownerName;
  final String? clientName;
  final double? totalPrice;

  BookingWithDetails({
    required this.booking,
    this.listingTitle,
    this.listingCategory,
    this.ownerName,
    this.clientName,
    this.totalPrice,
  });

  factory BookingWithDetails.fromJson(Map<String, dynamic> json) {
    return BookingWithDetails(
      booking: Booking.fromMap(json),
      listingTitle: json['listing_title'] ?? json['post_title'],
      listingCategory: json['listing_category'] ?? json['category'],
      ownerName: json['owner_name'],
      clientName: json['client_name'],
      totalPrice: (json['total_price'] ?? json['price'])?.toDouble(),
    );
  }
}

/// Booking Service for managing bookings with the backend
class BookingService {
  static BookingService? _instance;
  final ApiClient _apiClient;

  BookingService._internal() : _apiClient = ApiClient.instance;

  /// Get singleton instance
  static BookingService get instance {
    _instance ??= BookingService._internal();
    return _instance!;
  }

  /// Get user's bookings (as client)
  /// 
  /// GET /api/bookings/my
  Future<ApiResponse<List<BookingWithDetails>>> getMyBookings() async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.bookings}/my',
        requiresAuth: true,
      );
      final bookings = (response['data'] as List<dynamic>? ?? response as List<dynamic>)
          .map((json) => BookingWithDetails.fromJson(json))
          .toList();
      return ApiResponse.success(bookings);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get bookings received (as owner)
  /// 
  /// GET /api/bookings/received
  Future<ApiResponse<List<BookingWithDetails>>> getReceivedBookings() async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.bookings}/received',
        requiresAuth: true,
      );
      final bookings = (response['data'] as List<dynamic>? ?? response as List<dynamic>)
          .map((json) => BookingWithDetails.fromJson(json))
          .toList();
      return ApiResponse.success(bookings);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Create a new booking
  /// 
  /// POST /api/bookings
  Future<ApiResponse<Booking>> createBooking(CreateBookingRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiConfig.bookings,
        body: request.toJson(),
        requiresAuth: true,
      );
      final booking = Booking.fromMap(response['data'] ?? response);
      return ApiResponse.success(booking);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get a specific booking by ID
  /// 
  /// GET /api/bookings/:id
  Future<ApiResponse<BookingWithDetails>> getBookingById(int id) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.bookings}/$id',
        requiresAuth: true,
      );
      final booking = BookingWithDetails.fromJson(response['data'] ?? response);
      return ApiResponse.success(booking);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Cancel a booking
  /// 
  /// POST /api/bookings/:id/cancel
  Future<ApiResponse<Booking>> cancelBooking(int id) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.bookings}/$id/cancel',
        requiresAuth: true,
      );
      final booking = Booking.fromMap(response['data'] ?? response);
      return ApiResponse.success(booking);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Confirm a booking (owner only)
  /// 
  /// POST /api/bookings/:id/confirm
  Future<ApiResponse<Booking>> confirmBooking(int id) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.bookings}/$id/confirm',
        requiresAuth: true,
      );
      final booking = Booking.fromMap(response['data'] ?? response);
      return ApiResponse.success(booking);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Complete a booking (owner only)
  /// 
  /// POST /api/bookings/:id/complete
  Future<ApiResponse<Booking>> completeBooking(int id) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.bookings}/$id/complete',
        requiresAuth: true,
      );
      final booking = Booking.fromMap(response['data'] ?? response);
      return ApiResponse.success(booking);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
