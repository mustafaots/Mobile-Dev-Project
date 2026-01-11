import 'dart:async';
import 'package:easy_vacation/main.dart';
import 'package:easy_vacation/services/api/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import '../screens/resetPasswordScreen.dart';

class DeepLinkHandler {
  static StreamSubscription? _sub;

  /// Initialize deep link handling
  static Future<void> init(BuildContext context) async {
    final appLinks = AppLinks();

    // ==============================
    // Cold start: app was terminated
    // ==============================
    try {
      final initialLink = await appLinks.getInitialLinkString();
      if (initialLink != null) {
        print("===============================");
        print("=== Cold start link received: $initialLink ===");
        print("===============================");
        _handleUri(Uri.parse(initialLink), context);
      }
    } catch (e) {
      print("===============================");
      print("=== Deep link getInitial error: $e ===");
      print("===============================");
    }

    // =========================================
    // Warm start: app running in background
    // =========================================
    _sub = appLinks.stringLinkStream.listen((link) {
      if (link != null) {
        print("===============================");
        print("=== Incoming link received: $link ===");
        print("===============================");
        _handleUri(Uri.parse(link), context);
      }
    });
  }

  /// Handle incoming URI
  static void _handleUri(Uri uri, BuildContext context) {
    print("===============================");
    print("=== Handling URI: $uri ===");
    print("=== Host: ${uri.host} ===");
    print("=== Fragment: ${uri.fragment} ===");
    print("===============================");

    // Parse the fragment to get type and token
    final fragment = uri.fragment;
    final params = fragment.isNotEmpty ? Uri.splitQueryString(fragment) : {};
    final token = params['access_token'];
    final type = params['type'];

    print("=== Type: $type ===");
    print("=== Token exists: ${token != null} ===");

    // -------------------------------
    // Check by type parameter first (more reliable)
    // -------------------------------
    if (type == 'recovery') {
      // Password reset flow
      print("=== Type is recovery - going to reset password ===");
      if (token != null) {
        navigator_key.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(token: token),
          ),
        );
      }
      return;
    }
    
    if (type == 'magiclink') {
      // Email verification flow
      print("=== Type is magiclink - confirming email verification ===");
      _confirmEmailVerification(context);
      return;
    }

    // -------------------------------
    // Fallback: Check by host
    // -------------------------------
    if (uri.host == 'reset-password') {
      print("=== Found reset-password host ===");
      if (token != null) {
        navigator_key.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(token: token),
          ),
        );
      }
    } else if (uri.host == 'email-verified') {
      print("=== Found email-verified host ===");
      _confirmEmailVerification(context);
    } else {
      print("=== URI does not match any known pattern ===");
    }
  }

  /// Confirm email verification with the backend
  static Future<void> _confirmEmailVerification(BuildContext context) async {
    try {
      final result = await AuthService.instance.confirmEmailVerification();
      
      if (result.isSuccess) {
        print("===============================");
        print("=== Email verified successfully ===");
        print("===============================");
        
        // Show success message
        if (navigator_key.currentContext != null) {
          ScaffoldMessenger.of(navigator_key.currentContext!).showSnackBar(
            const SnackBar(
              content: Text('Email verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        print("===============================");
        print("=== Email verification failed: ${result.message} ===");
        print("===============================");
      }
    } catch (e) {
      print("===============================");
      print("=== Email verification error: $e ===");
      print("===============================");
    }
  }

  /// Dispose the stream subscription
  static void dispose() {
    _sub?.cancel();
    print("===============================");
    print("=== DeepLinkHandler disposed ===");
    print("===============================");
  }
}
