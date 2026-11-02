import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  // State properties
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  UserModel? _currentUser;
  bool _rememberMe = false;
  String _savedIdentifier = '';
  bool _isInitialized = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get rememberMe => _rememberMe;
  String get savedIdentifier => _savedIdentifier;
  bool get isInitialized => _isInitialized;

  /// Initialize and load saved state from persistent storage
  Future<void> initialize() async {
    _rememberMe = await LocalStorageService.isRememberMeEnabled();
    if (_rememberMe) {
      _savedIdentifier = await LocalStorageService.getSavedIdentifier() ?? '';
    }
    _currentUser = await LocalStorageService.getUserSession();
    _isInitialized = true;
    notifyListeners();
  }

  /// Toggle remember me preference
  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  /// Clear transient messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Login with email or mobile
  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    _setLoading(true);
    _clearErrors();

    try {
      final response = await _authService.login(
        identifier: identifier,
        password: password,
      );

      if (response.isSuccess && response.data != null) {
        _currentUser = response.data;
        _successMessage = response.message;

        // Persist session and remember me
        await LocalStorageService.saveUserSession(_currentUser!);
        await LocalStorageService.saveRememberMe(
          rememberMe: _rememberMe,
          identifier: identifier.trim(),
        );

        if (_rememberMe) {
          _savedIdentifier = identifier.trim();
        }

        _setLoading(false);
        return true;
      } else {
        _errorMessage = response.message;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _setLoading(false);
      return false;
    }
  }

  /// Register a new account
  Future<bool> register({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    _setLoading(true);
    _clearErrors();

    try {
      final response = await _authService.register(
        fullName: fullName,
        email: email,
        mobileNumber: mobileNumber,
        password: password,
      );

      if (response.isSuccess && response.data != null) {
        _currentUser = response.data;
        _successMessage = response.message;

        // Save session
        await LocalStorageService.saveUserSession(_currentUser!);
        if (_rememberMe) {
          await LocalStorageService.saveRememberMe(
            rememberMe: true,
            identifier: email.trim(),
          );
          _savedIdentifier = email.trim();
        }

        _setLoading(false);
        return true;
      } else {
        _errorMessage = response.message;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred during registration.';
      _setLoading(false);
      return false;
    }
  }

  /// Send password reset link
  Future<bool> forgotPassword({required String identifier}) async {
    _setLoading(true);
    _clearErrors();

    try {
      final response = await _authService.forgotPassword(identifier: identifier);
      if (response.isSuccess) {
        _successMessage = response.message;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = response.message;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to process password reset request.';
      _setLoading(false);
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    _currentUser = null;
    await LocalStorageService.clearUserSession();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearErrors() {
    _errorMessage = null;
    _successMessage = null;
  }
}

