import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:easy_vacation/services/sync/sync_manager.dart';

/// Background sync task name
const String backgroundSyncTask = 'com.easyvacation.backgroundSync';
const String periodicSyncTask = 'com.easyvacation.periodicSync';

/// Callback dispatcher for WorkManager (must be top-level function)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('🔄 Background task executing: $task');

    try {
      switch (task) {
        case backgroundSyncTask:
        case periodicSyncTask:
          // Initialize and sync
          final syncManager = SyncManager.instance;
          if (!syncManager.isInitialized) {
            await syncManager.init();
          }

          final result = await syncManager.syncAll();
          debugPrint(
            '🔄 Background sync result: ${result.success ? 'Success' : 'Failed'} - ${result.message ?? 'No message'}',
          );
          return result.success;

        default:
          debugPrint('🔄 Unknown task: $task');
          return false;
      }
    } catch (e) {
      debugPrint('🔄 Background sync error: $e');
      return false;
    }
  });
}

/// Service to manage background synchronization using WorkManager
class BackgroundSyncService {
  static BackgroundSyncService? _instance;

  Timer? _foregroundSyncTimer;
  bool _isInitialized = false;

  BackgroundSyncService._internal();

  static BackgroundSyncService get instance {
    _instance ??= BackgroundSyncService._internal();
    return _instance!;
  }

  bool get isInitialized => _isInitialized;

  /// Initialize WorkManager for background sync
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );

      _isInitialized = true;
      debugPrint('✅ BackgroundSyncService initialized');
    } catch (e) {
      debugPrint('❌ BackgroundSyncService init error: $e');
      rethrow;
    }
  }

  /// Start foreground sync with 1-second interval
  /// Note: This only works when app is in foreground
  void startForegroundSync({Duration interval = const Duration(seconds: 1)}) {
    stopForegroundSync();

    debugPrint(
      '🔄 Starting foreground sync with ${interval.inSeconds}s interval',
    );

    _foregroundSyncTimer = Timer.periodic(interval, (_) async {
      final syncManager = SyncManager.instance;
      if (syncManager.isInitialized && syncManager.isOnline) {
        await syncManager.syncAll();
      }
    });
  }

  /// Stop foreground sync timer
  void stopForegroundSync() {
    _foregroundSyncTimer?.cancel();
    _foregroundSyncTimer = null;
    debugPrint('🔄 Foreground sync stopped');
  }

  /// Register periodic background sync task
  /// Note: Minimum interval on Android is 15 minutes due to OS restrictions
  Future<void> registerPeriodicSync({
    Duration frequency = const Duration(minutes: 15),
  }) async {
    if (!_isInitialized) {
      await init();
    }

    // Cancel any existing periodic task first
    await Workmanager().cancelByUniqueName(periodicSyncTask);

    await Workmanager().registerPeriodicTask(
      periodicSyncTask,
      periodicSyncTask,
      frequency: frequency,
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(seconds: 10),
    );

    debugPrint(
      '✅ Registered periodic sync with ${frequency.inMinutes} min interval',
    );
  }

  /// Register a one-time background sync task
  Future<void> registerOneTimeSync({Duration? initialDelay}) async {
    if (!_isInitialized) {
      await init();
    }

    await Workmanager().registerOneOffTask(
      '${backgroundSyncTask}_${DateTime.now().millisecondsSinceEpoch}',
      backgroundSyncTask,
      initialDelay: initialDelay ?? Duration.zero,
      constraints: Constraints(networkType: NetworkType.connected),
    );

    debugPrint('✅ Registered one-time sync task');
  }

  /// Cancel all background sync tasks
  Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
    debugPrint('🔄 All background tasks cancelled');
  }

  /// Cancel specific task by name
  Future<void> cancelTask(String uniqueName) async {
    await Workmanager().cancelByUniqueName(uniqueName);
    debugPrint('🔄 Task $uniqueName cancelled');
  }

  /// Dispose resources
  void dispose() {
    stopForegroundSync();
    _instance = null;
  }
}
