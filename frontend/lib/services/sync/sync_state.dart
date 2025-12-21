import 'dart:async';

/// Sync status for tracking synchronization state
enum SyncStatus {
  idle,
  syncing,
  success,
  error,
  offline,
}

/// Result of a sync operation
class SyncResult {
  final bool success;
  final String? message;
  final int itemsSynced;
  final DateTime timestamp;

  SyncResult({
    required this.success,
    this.message,
    this.itemsSynced = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory SyncResult.success({int itemsSynced = 0, String? message}) {
    return SyncResult(
      success: true,
      itemsSynced: itemsSynced,
      message: message,
    );
  }

  factory SyncResult.error(String message) {
    return SyncResult(
      success: false,
      message: message,
    );
  }

  factory SyncResult.offline() {
    return SyncResult(
      success: false,
      message: 'No internet connection',
    );
  }
}

/// Sync state that can be observed by UI
class SyncState {
  final SyncStatus status;
  final String? message;
  final DateTime? lastSyncTime;
  final double? progress;

  const SyncState({
    this.status = SyncStatus.idle,
    this.message,
    this.lastSyncTime,
    this.progress,
  });

  SyncState copyWith({
    SyncStatus? status,
    String? message,
    DateTime? lastSyncTime,
    double? progress,
  }) {
    return SyncState(
      status: status ?? this.status,
      message: message ?? this.message,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      progress: progress ?? this.progress,
    );
  }

  bool get isSyncing => status == SyncStatus.syncing;
  bool get isOffline => status == SyncStatus.offline;
  bool get hasError => status == SyncStatus.error;
}

/// Interface for sync-aware services
abstract class Syncable {
  Future<SyncResult> syncFromRemote();
  Future<SyncResult> syncToRemote();
  Future<void> clearLocalData();
}
