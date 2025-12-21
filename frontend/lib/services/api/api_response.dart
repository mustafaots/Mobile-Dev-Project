/// Generic API response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? meta;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.meta,
  });

  factory ApiResponse.success(T data, {Map<String, dynamic>? meta}) {
    return ApiResponse(
      success: true,
      data: data,
      meta: meta,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;
}

/// Paginated response for list endpoints
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int limit;
  final int offset;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
  });

  bool get hasMore => offset + items.length < total;
  int get nextOffset => offset + limit;
}
