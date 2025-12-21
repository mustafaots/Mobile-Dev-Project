import 'dart:async';
import 'dart:io';

/// Service to check network connectivity
class ConnectivityService {
  static ConnectivityService? _instance;
  
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();
  bool _isOnline = true;
  bool _hasCheckedOnce = false;
  DateTime? _lastCheckTime;
  Timer? _checkTimer;

  ConnectivityService._internal() {
    _startPeriodicCheck();
  }

  static ConnectivityService get instance {
    _instance ??= ConnectivityService._internal();
    return _instance!;
  }

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Current connectivity status (cached, doesn't do network call)
  bool get isOnline => _isOnline;

  /// Quick check - uses cached value if checked recently (within 30 seconds)
  /// This avoids slow DNS lookups on every API call
  Future<bool> checkConnectivity() async {
    // Use cached value if we checked recently (within 30 seconds)
    if (_hasCheckedOnce && _lastCheckTime != null) {
      final elapsed = DateTime.now().difference(_lastCheckTime!);
      if (elapsed.inSeconds < 30) {
        return _isOnline;
      }
    }
    
    // Do actual network check
    return await _doConnectivityCheck();
  }

  /// Force a fresh connectivity check (used by periodic timer)
  Future<bool> _doConnectivityCheck() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      _isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      _isOnline = false;
    } on TimeoutException catch (_) {
      _isOnline = false;
    } catch (e) {
      _isOnline = false;
    }
    
    _hasCheckedOnce = true;
    _lastCheckTime = DateTime.now();
    _connectivityController.add(_isOnline);
    return _isOnline;
  }

  /// Start periodic connectivity checks
  void _startPeriodicCheck() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      checkConnectivity();
    });
    // Initial check
    checkConnectivity();
  }

  /// Stop periodic checks
  void stopPeriodicCheck() {
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  /// Dispose resources
  void dispose() {
    _checkTimer?.cancel();
    _connectivityController.close();
    _instance = null;
  }
}
