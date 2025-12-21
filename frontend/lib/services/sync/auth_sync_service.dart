import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:easy_vacation/models/users.model.dart';
import 'package:easy_vacation/repositories/db_repositories/db_repo.dart';
import 'package:easy_vacation/services/api/api_services.dart';
import 'package:easy_vacation/services/sync/sync_state.dart';
import 'package:easy_vacation/services/sync/connectivity_service.dart';
import 'package:easy_vacation/services/sharedprefs.services.dart';
import 'package:easy_vacation/main.dart';

/// Service for synchronizing user/auth data between remote and local
class AuthSyncService implements Syncable {
  static AuthSyncService? _instance;
  
  final AuthService _authService;
  final UserRepository _userRepository;
  final ConnectivityService _connectivity;
  
  final StreamController<SyncState> _stateController = StreamController<SyncState>.broadcast();
  SyncState _currentState = const SyncState();

  AuthSyncService._internal({
    required AuthService authService,
    required UserRepository userRepository,
    required ConnectivityService connectivity,
  }) : _authService = authService,
       _userRepository = userRepository,
       _connectivity = connectivity;

  static Future<AuthSyncService> getInstance() async {
    if (_instance == null) {
      final userRepo = appRepos['userRepo'] as UserRepository;
      _instance = AuthSyncService._internal(
        authService: AuthService.instance,
        userRepository: userRepo,
        connectivity: ConnectivityService.instance,
      );
    }
    return _instance!;
  }

  /// Stream of sync state changes
  Stream<SyncState> get stateStream => _stateController.stream;
  
  /// Current sync state
  SyncState get currentState => _currentState;

  void _updateState(SyncState state) {
    _currentState = state;
    _stateController.add(state);
  }

  /// Register a new user - syncs to remote and stores locally
  Future<ApiResponse<AuthResult>> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    _updateState(_currentState.copyWith(status: SyncStatus.syncing, message: 'Registering...'));

    // Check connectivity
    if (!await _connectivity.checkConnectivity()) {
      _updateState(_currentState.copyWith(status: SyncStatus.offline));
      return ApiResponse.error('No internet connection. Please try again later.');
    }

    try {
      print('📝 Attempting registration for: $email');
      // Register on remote server
      final result = await _authService.register(RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      ));

      print('📝 Registration result: success=${result.isSuccess}, message=${result.message}');

      if (result.isSuccess && result.data != null) {
        // Store user locally
        final user = result.data!.user;
        await _saveUserLocally(user);

        // Save auth tokens for persistent login
        await _saveAuthTokens(
          accessToken: result.data!.accessToken,
          refreshToken: result.data!.refreshToken,
          userId: user.id,
        );

        _updateState(_currentState.copyWith(
          status: SyncStatus.success,
          lastSyncTime: DateTime.now(),
          message: 'Registration successful',
        ));
      } else {
        print('📝 Registration failed: ${result.message}');
        _updateState(_currentState.copyWith(
          status: SyncStatus.error,
          message: result.message ?? 'Registration failed',
        ));
      }

      return result;
    } catch (e, stackTrace) {
      print('📝 Registration exception: $e');
      print('📝 Stack trace: $stackTrace');
      _updateState(_currentState.copyWith(
        status: SyncStatus.error,
        message: e.toString(),
      ));
      return ApiResponse.error(e.toString());
    }
  }

  /// Login user - syncs from remote and stores locally
  Future<ApiResponse<AuthResult>> login({
    required String email,
    required String password,
  }) async {
    _updateState(_currentState.copyWith(status: SyncStatus.syncing, message: 'Logging in...'));

    // Check connectivity
    if (!await _connectivity.checkConnectivity()) {
      // Try offline login
      final localUser = await _userRepository.getUserByEmail(email);
      if (localUser != null) {
        _updateState(_currentState.copyWith(
          status: SyncStatus.offline,
          message: 'Logged in offline',
        ));
        // Note: In a real app, you'd verify password hash here
        return ApiResponse.success(AuthResult(
          user: localUser,
          accessToken: '', // No token in offline mode
        ));
      }
      _updateState(_currentState.copyWith(status: SyncStatus.offline));
      return ApiResponse.error('No internet connection and no cached user found.');
    }

    try {
      // Login on remote server
      final result = await _authService.login(LoginRequest(
        email: email,
        password: password,
      ));

      if (result.isSuccess && result.data != null) {
        // Store/update user locally
        final user = result.data!.user;
        await _saveUserLocally(user);

        // Save auth tokens for persistent login
        await _saveAuthTokens(
          accessToken: result.data!.accessToken,
          refreshToken: result.data!.refreshToken,
          userId: user.id,
        );

        _updateState(_currentState.copyWith(
          status: SyncStatus.success,
          lastSyncTime: DateTime.now(),
          message: 'Login successful',
        ));
      } else {
        _updateState(_currentState.copyWith(
          status: SyncStatus.error,
          message: result.message ?? 'Login failed',
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

  /// Get current user profile - try remote first, fallback to local
  Future<User?> getCurrentUser() async {
    // Try to get from remote if online
    if (await _connectivity.checkConnectivity()) {
      final result = await _authService.getProfile();
      if (result.isSuccess && result.data != null) {
        await _saveUserLocally(result.data!);
        return result.data;
      }
    }

    // Fallback to local cached user
    final currentUser = _authService.currentUser;
    if (currentUser?.email != null) {
      return await _userRepository.getUserByEmail(currentUser!.email);
    }
    return null;
  }

  /// Save user to local database
  Future<void> _saveUserLocally(User user) async {
    final existingUser = await _userRepository.getUserByEmail(user.email);
    if (existingUser != null) {
      await _userRepository.updateUser(existingUser.id!, user);
    } else {
      await _userRepository.insertUser(user);
    }
  }

  /// Save auth tokens to persistent storage
  Future<void> _saveAuthTokens({
    required String accessToken,
    String? refreshToken,
    String? userId,
  }) async {
    if (accessToken.isNotEmpty) {
      await SharedPrefsService.setAuthToken(accessToken);
    }
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await SharedPrefsService.setRefreshToken(refreshToken);
    }
    if (userId != null && userId.isNotEmpty) {
      await SharedPrefsService.setUserId(userId);
    }
  }

  /// Try to restore session from stored tokens
  /// Returns the user if session is valid, null otherwise
  Future<User?> tryRestoreSession() async {
    final storedToken = SharedPrefsService.getAuthToken();
    final storedUserId = SharedPrefsService.getUserId();

    if (storedToken == null || storedToken.isEmpty) {
      print('📝 No stored token found');
      return null;
    }

    print('📝 Found stored token, attempting to restore session...');

    // Set the token in the auth service
    _authService.setStoredToken(storedToken);

    // Try to validate the token by fetching the user profile
    if (await _connectivity.checkConnectivity()) {
      try {
        final result = await _authService.getProfile();
        if (result.isSuccess && result.data != null) {
          print('📝 Session restored successfully');
          await _saveUserLocally(result.data!);
          _updateState(_currentState.copyWith(
            status: SyncStatus.success,
            message: 'Session restored',
          ));
          return result.data;
        } else {
          // Token is invalid, clear stored data
          print('📝 Stored token is invalid, clearing...');
          await SharedPrefsService.clearAuthData();
          _authService.logout();
          return null;
        }
      } catch (e) {
        print('📝 Error validating token: $e');
        // Token might be expired, clear it
        await SharedPrefsService.clearAuthData();
        _authService.logout();
        return null;
      }
    } else {
      // Offline mode - try to get user from local storage
      if (storedUserId != null && storedUserId.isNotEmpty) {
        final localUser = await _userRepository.getUserById(storedUserId);
        if (localUser != null) {
          print('📝 Restored session offline from local storage');
          _updateState(_currentState.copyWith(
            status: SyncStatus.offline,
            message: 'Logged in offline',
          ));
          return localUser;
        }
      }
      return null;
    }
  }

  /// Check if there's a stored session
  bool hasStoredSession() {
    return SharedPrefsService.hasAuthToken();
  }

  /// Logout - clear local and remote session
  Future<void> logout() async {
    await SharedPrefsService.clearAuthData();
    _authService.logout();
    _updateState(const SyncState(status: SyncStatus.idle));
  }

  @override
  Future<SyncResult> syncFromRemote() async {
    if (!await _connectivity.checkConnectivity()) {
      return SyncResult.offline();
    }

    try {
      final result = await _authService.getProfile();
      if (result.isSuccess && result.data != null) {
        await _saveUserLocally(result.data!);
        return SyncResult.success(itemsSynced: 1);
      }
      return SyncResult.error(result.message ?? 'Failed to sync user');
    } catch (e) {
      return SyncResult.error(e.toString());
    }
  }

  @override
  Future<SyncResult> syncToRemote() async {
    // Profile updates are done immediately via API
    return SyncResult.success();
  }

  @override
  Future<void> clearLocalData() async {
    // Clear all users from local DB (be careful with this)
    final users = await _userRepository.getAllUsers();
    for (final user in users) {
      if (user.id != null) {
        await _userRepository.deleteUser(user.id!);
      }
    }
  }

  void dispose() {
    _stateController.close();
    _instance = null;
  }
}
