import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/services/api/api_client.dart';
import 'package:easy_vacation/services/api/api_config.dart';
import 'package:easy_vacation/services/api/api_response.dart';

/// Request model for user registration
class RegisterRequest {
  final String email;
  final String password;
  final String? firstName;
  final String? lastName;

  RegisterRequest({
    required this.email,
    required this.password,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
    };
  }
}

/// Request model for user login
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

/// Response model for authentication (login/register)
class AuthResult {
  final User user;
  final String accessToken;
  final String? refreshToken;

  AuthResult({
    required this.user,
    required this.accessToken,
    this.refreshToken,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    // Handle Supabase response structure
    // Register returns: { user: supabaseUser, profile: {...} }
    // Login returns: { user: supabaseUser, session: { access_token, refresh_token, ... } }
    
    final userData = json['user'] as Map<String, dynamic>? ?? {};
    final session = json['session'] as Map<String, dynamic>?;
    final profile = json['profile'] as Map<String, dynamic>?;
    
    // Merge profile data with user data if available
    if (profile != null) {
      userData.addAll(profile);
    }
    
    return AuthResult(
      user: User.fromMap(userData),
      accessToken: session?['access_token'] ?? json['access_token'] ?? json['token'] ?? '',
      refreshToken: session?['refresh_token'] ?? json['refresh_token'],
    );
  }
}

/// Authentication Service for handling user authentication with the backend
class AuthService {
  static AuthService? _instance;
  final ApiClient _apiClient;
  User? _currentUser;

  AuthService._internal() : _apiClient = ApiClient.instance;

  /// Get singleton instance
  static AuthService get instance {
    _instance ??= AuthService._internal();
    return _instance!;
  }

  /// Get current authenticated user
  User? get currentUser => _currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _apiClient.isAuthenticated && _currentUser != null;

  /// Register a new user
  /// 
  /// POST /api/auth/register
  Future<ApiResponse<AuthResult>> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/register',
        body: request.toJson(),
      );

      final authResult = AuthResult.fromJson(response);
      
      // Store token and user
      _apiClient.setAuthToken(authResult.accessToken);
      _currentUser = authResult.user;

      return ApiResponse.success(authResult);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Login with email and password
  /// 
  /// POST /api/auth/login
  Future<ApiResponse<AuthResult>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/login',
        body: request.toJson(),
      );

      final authResult = AuthResult.fromJson(response);
      
      // Store token and user
      _apiClient.setAuthToken(authResult.accessToken);
      _currentUser = authResult.user;

      return ApiResponse.success(authResult);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get current user profile
  /// 
  /// GET /api/auth/me
  Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.auth}/me',
        requiresAuth: true,
      );

      // Merge user and profile data
      final userData = Map<String, dynamic>.from(response['user'] ?? response);
      final profile = response['profile'] as Map<String, dynamic>?;
      
      if (profile != null) {
        userData.addAll(profile);
      }

      final user = User.fromMap(userData);
      _currentUser = user;

      return ApiResponse.success(user);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Request password reset
  /// 
  /// POST /api/auth/forgot-password
  Future<ApiResponse<String>> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/forgot-password',
        body: {'email': email},
      );

      final message = response['message'] ?? 'Password reset email sent';
      return ApiResponse.success(message);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Logout user
  void logout() {
    _apiClient.clearAuthToken();
    _currentUser = null;
  }

  /// Set auth token from stored value (for session restore)
  void setStoredToken(String token) {
    _apiClient.setAuthToken(token);
  }

  /// Get current auth token
  String? get authToken => _apiClient.authToken;
}
