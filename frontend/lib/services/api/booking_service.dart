import 'dart:convert';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_config.dart';
import 'package:easy_vacation/services/api/api_response.dart';

/// Request model for creating a booking
class CreateBookingRequest {
  final int postId;
  final String clientId;
  final DateTime startTime;
  final DateTime endTime;
  final String? notes;

  CreateBookingRequest({
    required this.postId,
    required this.clientId,
    required this.startTime,
    required this.endTime,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    // Normalize dates to noon UTC to avoid timezone day-boundary issues
    final normalizedStart = DateTime.utc(
      startTime.year,
      startTime.month,
      startTime.day,
      12,
      0,
      0,
    );
    final normalizedEnd = DateTime.utc(
      endTime.year,
      endTime.month,
      endTime.day,
      12,
      0,
      0,
    );
    // Store dates as JSON in 'reservation' column (same format as availability)
    final reservation = jsonEncode([
      {
        'startDate': normalizedStart.toIso8601String(),
        'endDate': normalizedEnd.toIso8601String(),
        if (notes != null) 'notes': notes,
      },
    ]);
    return {
      'post_id': postId,
      'client_id': clientId,
      'reservation': reservation,
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
  final String? clientId;
  final String? clientEmail;
  final String? clientPhone;
  final double? totalPrice;

  BookingWithDetails({
    required this.booking,
    this.listingTitle,
    this.listingCategory,
    this.ownerName,
    this.clientName,
    this.clientId,
    this.clientEmail,
    this.clientPhone,
    this.totalPrice,
  });

  factory BookingWithDetails.fromJson(Map<String, dynamic> json) {
    // Extract client info from nested client object if available
    String? clientName;
    String? clientId;
    String? clientEmail;
    String? clientPhone;
    if (json['client'] != null) {
      final client = json['client'];
      final firstName = client['first_name'] ?? '';
      final lastName = client['last_name'] ?? '';
      clientName = '$firstName $lastName'.trim();
      if (clientName.isEmpty) clientName = null;
      clientId = client['user_id'];
      clientEmail = client['email'];
      clientPhone = client['phone'];
    } else {
      clientName = json['client_name'];
      clientId = json['client_id'];
      clientEmail = json['client_email'];
      clientPhone = json['client_phone'];
    }

    return BookingWithDetails(
      booking: Booking.fromMap(json),
      listingTitle:
          json['listing_title'] ?? json['post']?['title'] ?? json['post_title'],
      listingCategory:
          json['listing_category'] ??
          json['post']?['category'] ??
          json['category'],
      ownerName: json['owner_name'],
      clientName: clientName,
      clientId: clientId,
      clientEmail: clientEmail,
      clientPhone: clientPhone,
      totalPrice:
          (json['total_price'] ?? json['post']?['price'] ?? json['price'])
              ?.toDouble(),
    );
  }
}

/// Booking Service for managing bookings with the backend
class BookingService {
  static BookingService? _instance;
  final ApiClient _apiClient;

  BookingService._internal() : _apiClient = ApiClient.instance;

  /// Test constructor for dependency injection
  BookingService.test(this._apiClient);

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
      final bookings =
          (response['data'] as List<dynamic>? ?? response as List<dynamic>)
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
      final bookings =
          (response['data'] as List<dynamic>? ?? response as List<dynamic>)
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
  Future<ApiResponse<Booking>> createBooking(
    CreateBookingRequest request,
  ) async {
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
