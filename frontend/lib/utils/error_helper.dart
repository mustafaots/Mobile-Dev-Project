import 'package:flutter/material.dart';
import 'package:easy_vacation/l10n/app_localizations.dart';
import 'package:easy_vacation/services/api/api_exceptions.dart';

/// Error types for categorizing errors
enum ErrorType {
  timeout,
  network,
  server,
  unknown,
}

/// Helper class to convert API exceptions to localized user-friendly messages.
class ErrorHelper {
  /// Converts an exception to a localized user-friendly message.
  /// 
  /// If [context] is provided, returns a localized message.
  /// Otherwise, returns a generic English message.
  static String getLocalizedMessage(dynamic error, [BuildContext? context]) {
    final loc = context != null ? AppLocalizations.of(context) : null;
    
    if (error is TimeoutException) {
      return loc?.error_networkTimeout ?? 
             'Network timeout. Please check your connection and try again.';
    }
    
    if (error is NetworkException) {
      return loc?.error_noConnection ?? 
             'Unable to connect to server. Please check your internet connection.';
    }
    
    if (error is ServerException) {
      return loc?.error_serverError ?? 
             'Server error. Please try again later.';
    }
    
    if (error is ApiException) {
      // For other API exceptions, return the message as-is
      // (like validation errors which have specific messages)
      return error.message;
    }
    
    // Check if error string contains timeout-related keywords
    final errorString = error.toString().toLowerCase();
    if (errorString.contains('timeout') || errorString.contains('timed out')) {
      return loc?.error_networkTimeout ?? 
             'Network timeout. Please check your connection and try again.';
    }
    
    if (errorString.contains('socket') || 
        errorString.contains('connection refused') ||
        errorString.contains('network')) {
      return loc?.error_noConnection ?? 
             'Unable to connect to server. Please check your internet connection.';
    }
    
    // For unknown errors, return a generic message
    return loc?.error_unknownError ?? 
           'An unexpected error occurred. Please try again.';
  }
  
  /// Converts an error message string to a localized user-friendly message.
  /// 
  /// This is useful when the cubit has already converted the exception to a string
  /// and you need to convert it back to a friendly message in the UI.
  static String getLocalizedMessageFromString(String errorMessage, BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final lowerMessage = errorMessage.toLowerCase();
    
    // Check for timeout errors
    if (lowerMessage.contains('timeout') || lowerMessage.contains('timed out')) {
      return loc.error_networkTimeout;
    }
    
    // Check for network/connection errors
    if (lowerMessage.contains('socket') || 
        lowerMessage.contains('connection refused') ||
        lowerMessage.contains('cannot connect') ||
        lowerMessage.contains('network error')) {
      return loc.error_noConnection;
    }
    
    // Check for server errors
    if (lowerMessage.contains('server error') || 
        lowerMessage.contains('500') ||
        lowerMessage.contains('502') ||
        lowerMessage.contains('503')) {
      return loc.error_serverError;
    }
    
    // Return the original message if it doesn't match known patterns
    // But check if it starts with common prefixes and strip them
    final prefixes = [
      'failed to load bookings:',
      'failed to load received bookings:',
      'failed to load host info:',
      'failed to load images:',
      'failed to load reviews:',
      'failed to load details:',
      'failed to cancel booking:',
      'error:',
    ];
    
    String cleanMessage = errorMessage;
    for (final prefix in prefixes) {
      if (lowerMessage.startsWith(prefix)) {
        cleanMessage = errorMessage.substring(prefix.length).trim();
        break;
      }
    }
    
    // Re-check the cleaned message for timeout/network patterns
    final cleanLower = cleanMessage.toLowerCase();
    if (cleanLower.contains('timeout') || cleanLower.contains('timed out')) {
      return loc.error_networkTimeout;
    }
    if (cleanLower.contains('socket') || 
        cleanLower.contains('connection') ||
        cleanLower.contains('network')) {
      return loc.error_noConnection;
    }
    
    // If still no match, return the cleaned message or unknown error
    if (cleanMessage.isEmpty || cleanMessage.contains('ApiException') || cleanMessage.contains('Exception')) {
      return loc.error_unknownError;
    }
    
    return cleanMessage;
  }
  
  /// Checks if the error is a timeout-related exception
  static bool isTimeoutError(dynamic error) {
    if (error is TimeoutException) return true;
    final errorString = error.toString().toLowerCase();
    return errorString.contains('timeout') || errorString.contains('timed out');
  }
  
  /// Checks if the error is a network connectivity error
  static bool isNetworkError(dynamic error) {
    if (error is NetworkException) return true;
    final errorString = error.toString().toLowerCase();
    return errorString.contains('socket') || 
           errorString.contains('connection refused') ||
           errorString.contains('network');
  }
}
