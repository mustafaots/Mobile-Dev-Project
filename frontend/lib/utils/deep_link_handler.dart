import 'dart:async';
import 'package:easy_vacation/main.dart';
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
    print("===============================");

    // -------------------------------
    // Check host (reset-password)
    // -------------------------------
    if (uri.host == 'reset-password') {
      // Supabase sends token in the fragment (#access_token=...)
      final fragment = uri.fragment; // everything after #
      final params = fragment.isNotEmpty ? Uri.splitQueryString(fragment) : {};
      final token = params['access_token'];

      print("===============================");
      print("=== Found reset-password host ===");
      print("=== Fragment: $fragment ===");
      print("=== Token: $token ===");
      print("===============================");

      if (token != null) {
        // Navigate to ResetPasswordScreen on the next frame
        navigator_key.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(token: token),
          ),
        );
      } else {
        print("===============================");
        print("=== Token is null ===");
        print("===============================");
      }
    } else {
      print("===============================");
      print("=== URI does not contain reset-password host ===");
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
