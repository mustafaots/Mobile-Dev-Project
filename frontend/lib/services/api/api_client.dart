import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_exceptions.dart';
import 'api_response.dart';

/// HTTP Client for making API requests to the backend
class ApiClient {
  static ApiClient? _instance;
  final http.Client _httpClient;
  String? _authToken;

  ApiClient._internal() : _httpClient = http.Client();

  /// Get singleton instance
  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  /// Set the authentication token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Get current auth token
  String? get authToken => _authToken;

  /// Check if user is authenticated
  bool get isAuthenticated => _authToken != null && _authToken!.isNotEmpty;

  /// Clear auth token (logout)
  void clearAuthToken() {
    _authToken = null;
  }

  /// Get default headers
  Map<String, String> _getHeaders({bool requiresAuth = false}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  /// Build full URL from endpoint
  Uri _buildUrl(String endpoint, [Map<String, dynamic>? queryParams]) {
    final url = '${ApiConfig.baseUrl}$endpoint';
    final uri = Uri.parse(url);
    
    if (queryParams != null && queryParams.isNotEmpty) {
      final stringParams = queryParams.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      );
      return uri.replace(queryParameters: stringParams);
    }
    
    return uri;
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic body;

    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = response.body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    }

    final message = body is Map ? (body['message'] ?? 'Unknown error') : 'Unknown error';
    final details = body is Map ? (body['details'] ?? body['errors']) : null;
    
    // Log validation details for debugging
    if (details != null) {
      print('🔴 API Error Details: $details');
    }

    switch (statusCode) {
      case 400:
        throw ValidationException('$message${details != null ? ': $details' : ''}', errors: details);
      case 401:
        throw UnauthorizedException(message);
      case 403:
        throw ForbiddenException(message);
      case 404:
        throw NotFoundException(message);
      case >= 500:
        throw ServerException(message, statusCode);
      default:
        throw ClientException(message, statusCode: statusCode);
    }
  }

  /// Handle network errors
  Never _handleError(dynamic error) {
    if (error is SocketException) {
      throw NetworkException('No internet connection');
    } else if (error is HttpException) {
      throw NetworkException('HTTP error occurred');
    } else if (error is FormatException) {
      throw ApiException('Invalid response format');
    } else if (error is ApiException) {
      throw error;
    } else {
      throw ApiException('Unexpected error: $error');
    }
  }

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool requiresAuth = false,
  }) async {
    try {
      final response = await _httpClient
          .get(
            _buildUrl(endpoint, queryParams),
            headers: _getHeaders(requiresAuth: requiresAuth),
          )
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final response = await _httpClient
          .post(
            _buildUrl(endpoint),
            headers: _getHeaders(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// PATCH request
  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final response = await _httpClient
          .patch(
            _buildUrl(endpoint),
            headers: _getHeaders(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final response = await _httpClient
          .put(
            _buildUrl(endpoint),
            headers: _getHeaders(requiresAuth: requiresAuth),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final response = await _httpClient
          .delete(
            _buildUrl(endpoint),
            headers: _getHeaders(requiresAuth: requiresAuth),
          )
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Upload file with multipart request
  Future<dynamic> uploadFile(
    String endpoint, {
    required String filePath,
    required String fieldName,
    Map<String, String>? fields,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = _buildUrl(endpoint);
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      final headers = _getHeaders(requiresAuth: requiresAuth);
      headers.remove('Content-Type'); // Let multipart set its own content type
      request.headers.addAll(headers);

      // Add file
      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));

      // Add additional fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      final streamedResponse = await request.send().timeout(ApiConfig.connectionTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Dispose client
  void dispose() {
    _httpClient.close();
    _instance = null;
  }
}
