import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:easy_vacation/services/sync/sync_state.dart';
import 'package:easy_vacation/services/sync/connectivity_service.dart';
import 'package:easy_vacation/services/sync/auth_sync_service.dart';
import 'package:easy_vacation/services/sync/listing_sync_service.dart';
import 'package:easy_vacation/services/sync/booking_sync_service.dart';
import 'package:easy_vacation/services/sync/review_sync_service.dart';

/// Main synchronization manager that coordinates all sync services
class SyncManager {
  static SyncManager? _instance;
  
  late final ConnectivityService connectivity;
  late final AuthSyncService auth;
  late final ListingSyncService listings;
  late final BookingSyncService bookings;
  late final ReviewSyncService reviews;
  
  final StreamController<SyncState> _stateController = StreamController<SyncState>.broadcast();
  SyncState _currentState = const SyncState();
  
  bool _isInitialized = false;
  Timer? _autoSyncTimer;

  SyncManager._internal();

  static SyncManager get instance {
    _instance ??= SyncManager._internal();
    return _instance!;
  }

  /// Check if sync manager is initialized
  bool get isInitialized => _isInitialized;

  /// Stream of overall sync state changes
  Stream<SyncState> get stateStream => _stateController.stream;
  
  /// Current sync state
  SyncState get currentState => _currentState;

  /// Check if currently online
  bool get isOnline => connectivity.isOnline;

  /// Initialize all sync services
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      connectivity = ConnectivityService.instance;
      auth = await AuthSyncService.getInstance();
      listings = await ListingSyncService.getInstance();
      bookings = await BookingSyncService.getInstance();
      reviews = await ReviewSyncService.getInstance();

      // Listen to connectivity changes
      connectivity.connectivityStream.listen((isOnline) {
        if (isOnline) {
          _onConnectivityRestored();
        } else {
          _updateState(_currentState.copyWith(
            status: SyncStatus.offline,
            message: 'No internet connection',
          ));
        }
      });

      _isInitialized = true;
      debugPrint('SyncManager initialized successfully');
    } catch (e) {
      debugPrint('Error initializing SyncManager: $e');
      rethrow;
    }
  }

  void _updateState(SyncState state) {
    _currentState = state;
    _stateController.add(state);
  }

  /// Called when connectivity is restored
  Future<void> _onConnectivityRestored() async {
    _updateState(_currentState.copyWith(
      status: SyncStatus.syncing,
      message: 'Connection restored, syncing...',
    ));

    await syncAll();
  }

  /// Sync all data from remote
  Future<SyncResult> syncAll() async {
    if (!_isInitialized) {
      return SyncResult.error('SyncManager not initialized');
    }

    if (!await connectivity.checkConnectivity()) {
      _updateState(_currentState.copyWith(status: SyncStatus.offline));
      return SyncResult.offline();
    }

    _updateState(_currentState.copyWith(
      status: SyncStatus.syncing,
      message: 'Syncing all data...',
      progress: 0.0,
    ));

    int totalSynced = 0;
    final errors = <String>[];

    try {
      // Sync auth/profile
      _updateState(_currentState.copyWith(progress: 0.25, message: 'Syncing profile...'));
      final authResult = await auth.syncFromRemote();
      if (authResult.success) {
        totalSynced += authResult.itemsSynced;
      } else if (authResult.message != null) {
        errors.add('Auth: ${authResult.message}');
      }

      // Sync listings
      _updateState(_currentState.copyWith(progress: 0.5, message: 'Syncing listings...'));
      final listingsResult = await listings.syncFromRemote();
      if (listingsResult.success) {
        totalSynced += listingsResult.itemsSynced;
      } else if (listingsResult.message != null) {
        errors.add('Listings: ${listingsResult.message}');
      }

      // Sync bookings
      _updateState(_currentState.copyWith(progress: 0.75, message: 'Syncing bookings...'));
      final bookingsResult = await bookings.syncFromRemote();
      if (bookingsResult.success) {
        totalSynced += bookingsResult.itemsSynced;
      } else if (bookingsResult.message != null) {
        errors.add('Bookings: ${bookingsResult.message}');
      }

      _updateState(_currentState.copyWith(
        status: errors.isEmpty ? SyncStatus.success : SyncStatus.error,
        progress: 1.0,
        lastSyncTime: DateTime.now(),
        message: errors.isEmpty 
            ? 'Sync completed ($totalSynced items)'
            : 'Sync completed with errors',
      ));

      return SyncResult(
        success: errors.isEmpty,
        itemsSynced: totalSynced,
        message: errors.isEmpty ? null : errors.join('; '),
      );
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: SyncStatus.error,
        message: e.toString(),
      ));
      return SyncResult.error(e.toString());
    }
  }

  /// Start automatic background sync
  void startAutoSync({Duration interval = const Duration(seconds: 5)}) {
    stopAutoSync();
    _autoSyncTimer = Timer.periodic(interval, (_) {
      if (connectivity.isOnline) {
        syncAll();
      }
    });
  }

  /// Stop automatic background sync
  void stopAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
  }

  /// Force refresh all caches
  Future<void> forceRefresh() async {
    listings.invalidateCache();
    bookings.invalidateCache();
    reviews.invalidateCache();
    await syncAll();
  }

  /// Clear all local data
  Future<void> clearAllLocalData() async {
    await auth.clearLocalData();
    await listings.clearLocalData();
    await bookings.clearLocalData();
    await reviews.clearLocalData();
  }

  /// Dispose all resources
  void dispose() {
    stopAutoSync();
    connectivity.dispose();
    auth.dispose();
    listings.dispose();
    bookings.dispose();
    reviews.dispose();
    _stateController.close();
    _isInitialized = false;
    _instance = null;
  }
}
