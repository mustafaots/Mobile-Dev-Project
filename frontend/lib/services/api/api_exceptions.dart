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
  final Map<String, dynamic>? errors;

  ValidationException(String message, {this.errors})
      : super(message, statusCode: 400);
}

/// Timeout exceptions
class TimeoutException extends ApiException {
  TimeoutException([String message = 'Request timed out'])
      : super(message);
}
