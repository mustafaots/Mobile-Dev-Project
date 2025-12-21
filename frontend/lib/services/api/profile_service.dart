import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_config.dart';
import 'package:easy_vacation/services/api/api_response.dart';

/// User profile with additional stats
class UserProfile {
  final User user;
  final int? totalListings;
  final int? totalBookings;
  final double? averageRating;
  final DateTime? memberSince;
  final bool? isHost;

  UserProfile({
    required this.user,
    this.totalListings,
    this.totalBookings,
    this.averageRating,
    this.memberSince,
    this.isHost,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      user: User.fromMap(json),
      totalListings: json['total_listings'],
      totalBookings: json['total_bookings'],
      averageRating: json['average_rating']?.toDouble(),
      memberSince: json['member_since'] != null 
          ? DateTime.parse(json['member_since']) 
          : null,
      isHost: json['is_host'],
    );
  }
}

/// Request model for updating profile
class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? phone;

  UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (firstName != null) map['first_name'] = firstName;
    if (lastName != null) map['last_name'] = lastName;
    if (phone != null) map['phone'] = phone;
    return map;
  }
}

/// Profile Service for managing user profiles with the backend
class ProfileService {
  static ProfileService? _instance;
  final ApiClient _apiClient;

  ProfileService._internal() : _apiClient = ApiClient.instance;

  /// Get singleton instance
  static ProfileService get instance {
    _instance ??= ProfileService._internal();
    return _instance!;
  }

  /// Get current user's profile
  /// 
  /// GET /api/profile
  Future<ApiResponse<UserProfile>> getMyProfile() async {
    try {
      final response = await _apiClient.get(
        ApiConfig.profile,
        requiresAuth: true,
      );
      final profile = UserProfile.fromJson(response['data'] ?? response);
      return ApiResponse.success(profile);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Update current user's profile
  /// 
  /// PATCH /api/profile
  Future<ApiResponse<UserProfile>> updateMyProfile(UpdateProfileRequest request) async {
    try {
      final response = await _apiClient.patch(
        ApiConfig.profile,
        body: request.toJson(),
        requiresAuth: true,
      );
      final profile = UserProfile.fromJson(response['data'] ?? response);
      return ApiResponse.success(profile);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Request account verification
  /// 
  /// POST /api/profile/verify
  Future<ApiResponse<String>> requestVerification() async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.profile}/verify',
        requiresAuth: true,
      );
      return ApiResponse.success(response['message'] ?? 'Verification requested');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Delete account
  /// 
  /// DELETE /api/profile
  Future<ApiResponse<void>> deleteAccount() async {
    try {
      await _apiClient.delete(
        ApiConfig.profile,
        requiresAuth: true,
      );
      return ApiResponse.success(null);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get public profile by user ID
  /// 
  /// GET /api/users/:id/profile
  Future<ApiResponse<UserProfile>> getPublicProfile(int userId) async {
    try {
      final response = await _apiClient.get('${ApiConfig.users}/$userId/profile');
      final profile = UserProfile.fromJson(response['data'] ?? response);
      return ApiResponse.success(profile);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
