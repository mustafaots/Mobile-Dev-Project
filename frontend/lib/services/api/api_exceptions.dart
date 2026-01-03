/// Base API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Network related exceptions
class NetworkException extends ApiException {
  NetworkException([String message = 'Network error occurred'])
      : super(message);
}

/// Server error exceptions (5xx)
class ServerException extends ApiException {
  ServerException([String message = 'Server error occurred', int? statusCode])
      : super(message, statusCode: statusCode);
}

/// Client error exceptions (4xx)
class ClientException extends ApiException {
  ClientException(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

/// Authentication exceptions (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = 'Unauthorized'])
      : super(message, statusCode: 401);
}

/// Forbidden exceptions (403)
class ForbiddenException extends ApiException {
  ForbiddenException([String message = 'Forbidden'])
      : super(message, statusCode: 403);
}

/// Not found exceptions (404)
class NotFoundException extends ApiException {
  NotFoundException([String message = 'Resource not found'])
      : super(message, statusCode: 404);
}

/// Validation exceptions (400)
class ValidationException extends ApiException {
  final dynamic errors; // Can be Map<String, dynamic> or List<dynamic>

  ValidationException(String message, {this.errors})
      : super(message, statusCode: 400);
  
  /// Get a user-friendly error message from the validation errors
  String get friendlyMessage {
    if (errors == null) return message;
    
    if (errors is List) {
      // Zod-style validation errors (array of error objects)
      final errorList = errors as List;
      final messages = errorList
          .map((e) => e is Map ? (e['message'] ?? e.toString()) : e.toString())
          .toList();
      return messages.join(', ');
    } else if (errors is Map) {
      // Traditional field-based errors
      final errorMap = errors as Map;
      final messages = errorMap.entries
          .map((e) => '${e.key}: ${e.value}')
          .toList();
      return messages.join(', ');
    }
    
    return errors.toString();
  }
}

/// Timeout exceptions
class TimeoutException extends ApiException {
  TimeoutException([String message = 'Request timed out'])
      : super(message);
}
