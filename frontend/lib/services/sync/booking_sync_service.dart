import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:easy_vacation/models/bookings.model.dart';
import 'package:easy_vacation/repositories/db_repositories/db_repo.dart';
import 'package:easy_vacation/services/api/api_services.dart';
import 'package:easy_vacation/services/sync/sync_state.dart';
import 'package:easy_vacation/services/sync/connectivity_service.dart';
import 'package:easy_vacation/main.dart';

/// Service for synchronizing bookings between remote and local
class BookingSyncService implements Syncable {
  static BookingSyncService? _instance;
  
  final BookingService _bookingService;
  final BookingRepository _bookingRepository;
  final ConnectivityService _connectivity;
  
  final StreamController<SyncState> _stateController = StreamController<SyncState>.broadcast();
  SyncState _currentState = const SyncState();

  // Cache for bookings
  List<BookingWithDetails> _myBookings = [];
  List<BookingWithDetails> _receivedBookings = [];
  DateTime? _lastFetchTime;

  BookingSyncService._internal({
    required BookingService bookingService,
    required BookingRepository bookingRepository,
    required ConnectivityService connectivity,
  }) : _bookingService = bookingService,
       _bookingRepository = bookingRepository,
       _connectivity = connectivity;

  static Future<BookingSyncService> getInstance() async {
    if (_instance == null) {
      final bookingRepo = appRepos['bookingRepo'] as BookingRepository;
      _instance = BookingSyncService._internal(
        bookingService: BookingService.instance,
        bookingRepository: bookingRepo,
        connectivity: ConnectivityService.instance,
      );
    }
    return _instance!;
  }

  /// Stream of sync state changes
  Stream<SyncState> get stateStream => _stateController.stream;
  
  /// Current sync state
  SyncState get currentState => _currentState;

  /// Cached bookings
  List<BookingWithDetails> get myBookings => _myBookings;
  List<BookingWithDetails> get receivedBookings => _receivedBookings;

  void _updateState(SyncState state) {
    _currentState = state;
    _stateController.add(state);
  }

  /// Get user's bookings (as client)
  Future<List<BookingWithDetails>> getMyBookings({bool forceRefresh = false}) async {
    if (!forceRefresh && _myBookings.isNotEmpty && _lastFetchTime != null) {
      final cacheAge = DateTime.now().difference(_lastFetchTime!);
      if (cacheAge.inMinutes < 2) {
        return _myBookings;
      }
    }

    _updateState(_currentState.copyWith(status: SyncStatus.syncing, message: 'Loading bookings...'));

    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _bookingService.getMyBookings();
        
        if (result.isSuccess && result.data != null) {
          _myBookings = result.data!;
          _lastFetchTime = DateTime.now();
          
          // Save to local
          await _saveBookingsLocally(result.data!.map((b) => b.booking).toList());

          _updateState(_currentState.copyWith(
            status: SyncStatus.success,
            lastSyncTime: DateTime.now(),
          ));
          
          return _myBookings;
        }
      } catch (e) {
        debugPrint('Error fetching bookings: $e');
      }
    }

    // Fallback to local
    _updateState(_currentState.copyWith(status: SyncStatus.offline));
    final localBookings = await _bookingRepository.getAllBookings();
    return localBookings.map((b) => BookingWithDetails(booking: b)).toList();
  }

  /// Get received bookings (as owner)
  Future<List<BookingWithDetails>> getReceivedBookings({bool forceRefresh = false}) async {
    if (!forceRefresh && _receivedBookings.isNotEmpty) {
      return _receivedBookings;
    }

    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _bookingService.getReceivedBookings();
        
        if (result.isSuccess && result.data != null) {
          _receivedBookings = result.data!;
          return _receivedBookings;
        }
      } catch (e) {
        debugPrint('Error fetching received bookings: $e');
      }
    }

    return [];
  }

  /// Create a new booking
  Future<ApiResponse<Booking>> createBooking({
    required int listingId,
    required DateTime startDate,
    required DateTime endDate,
    String? notes,
  }) async {
    _updateState(_currentState.copyWith(status: SyncStatus.syncing, message: 'Creating booking...'));

    if (!await _connectivity.checkConnectivity()) {
      _updateState(_currentState.copyWith(status: SyncStatus.offline));
      return ApiResponse.error('No internet connection. Please try again later.');
    }

    try {
      final result = await _bookingService.createBooking(CreateBookingRequest(
        listingId: listingId,
        startDate: startDate,
        endDate: endDate,
        notes: notes,
      ));

      if (result.isSuccess && result.data != null) {
        // Add to local
        await _bookingRepository.insertBooking(result.data!);
        
        // Invalidate cache
        _lastFetchTime = null;

        _updateState(_currentState.copyWith(
          status: SyncStatus.success,
          lastSyncTime: DateTime.now(),
          message: 'Booking created successfully',
        ));
      } else {
        _updateState(_currentState.copyWith(
          status: SyncStatus.error,
          message: result.message,
        ));
      }

      return result;
    } catch (e) {
      _updateState(_currentState.copyWith(
        status: SyncStatus.error,
        message: e.toString(),
      ));
      return ApiResponse.error(e.toString());
    }
  }

  /// Cancel a booking
  Future<ApiResponse<Booking>> cancelBooking(int id) async {
    if (!await _connectivity.checkConnectivity()) {
      return ApiResponse.error('No internet connection. Please try again later.');
    }

    try {
      final result = await _bookingService.cancelBooking(id);
      
      if (result.isSuccess) {
        _lastFetchTime = null; // Invalidate cache
      }

      return result;
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Confirm a booking (owner only)
  Future<ApiResponse<Booking>> confirmBooking(int id) async {
    if (!await _connectivity.checkConnectivity()) {
      return ApiResponse.error('No internet connection. Please try again later.');
    }

    try {
      final result = await _bookingService.confirmBooking(id);
      
      if (result.isSuccess) {
        _lastFetchTime = null; // Invalidate cache
      }

      return result;
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Complete a booking (owner only)
  Future<ApiResponse<Booking>> completeBooking(int id) async {
    if (!await _connectivity.checkConnectivity()) {
      return ApiResponse.error('No internet connection. Please try again later.');
    }

    try {
      final result = await _bookingService.completeBooking(id);
      
      if (result.isSuccess) {
        _lastFetchTime = null; // Invalidate cache
      }

      return result;
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<void> _saveBookingsLocally(List<Booking> bookings) async {
    for (final booking in bookings) {
      try {
        final existing = booking.id != null 
            ? await _bookingRepository.getBookingById(booking.id!) 
            : null;
        if (existing != null) {
          await _bookingRepository.updateBooking(booking.id!, booking);
        } else {
          await _bookingRepository.insertBooking(booking);
        }
      } catch (e) {
        debugPrint('Error saving booking locally: $e');
      }
    }
  }

  @override
  Future<SyncResult> syncFromRemote() async {
    if (!await _connectivity.checkConnectivity()) {
      return SyncResult.offline();
    }

    try {
      final result = await _bookingService.getMyBookings();
      if (result.isSuccess && result.data != null) {
        await _saveBookingsLocally(result.data!.map((b) => b.booking).toList());
        _myBookings = result.data!;
        _lastFetchTime = DateTime.now();
        return SyncResult.success(itemsSynced: result.data!.length);
      }
      return SyncResult.error(result.message ?? 'Failed to sync bookings');
    } catch (e) {
      return SyncResult.error(e.toString());
    }
  }

  @override
  Future<SyncResult> syncToRemote() async {
    return SyncResult.success();
  }

  @override
  Future<void> clearLocalData() async {
    _myBookings.clear();
    _receivedBookings.clear();
    _lastFetchTime = null;
    final bookings = await _bookingRepository.getAllBookings();
    for (final booking in bookings) {
      if (booking.id != null) {
        await _bookingRepository.deleteBooking(booking.id!);
      }
    }
  }

  void invalidateCache() {
    _lastFetchTime = null;
  }

  void dispose() {
    _stateController.close();
    _instance = null;
  }
}
