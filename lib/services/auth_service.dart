import 'dart:async';
import '../models/api_response.dart';
import '../models/user_model.dart';

class AuthService {
  // In-memory mock database of registered users (seeded with default demo user)
  static final List<Map<String, dynamic>> _mockDatabase = [
    {
      'id': 'usr_001',
      'fullName': 'Alex Johnson',
      'email': 'user@example.com',
      'mobileNumber': '9876543210',
      'password': 'Password123!',
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    },
    {
      'id': 'usr_002',
      'fullName': 'Sarah Connor',
      'email': 'sarah@example.com',
      'mobileNumber': '9123456789',
      'password': 'Password123!',
      'createdAt': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
    },
  ];

  /// Simulated Login API
  /// Accepts email OR mobile number and password
  Future<ApiResponse<UserModel>> login({
    required String identifier,
    required String password,
  }) async {
    // Simulate real network latency (1.2 seconds)
    await Future.delayed(const Duration(milliseconds: 1200));

    final cleanId = identifier.trim().toLowerCase();

    // Find user matching either email or mobile number
    final userRecord = _mockDatabase.cast<Map<String, dynamic>?>().firstWhere(
      (element) {
        if (element == null) return false;
        final emailMatch = (element['email'] as String).toLowerCase() == cleanId;
        final mobileMatch = (element['mobileNumber'] as String) == identifier.trim();
        return emailMatch || mobileMatch;
      },
      orElse: () => null,
    );

    if (userRecord == null) {
      return ApiResponse.failure(
        message: 'No account found with this email or mobile number.',
        statusCode: 404,
      );
    }

    if (userRecord['password'] != password) {
      return ApiResponse.failure(
        message: 'Incorrect password. Please verify and try again.',
        statusCode: 401,
      );
    }

    final user = UserModel(
      id: userRecord['id'] as String,
      fullName: userRecord['fullName'] as String,
      email: userRecord['email'] as String,
      mobileNumber: userRecord['mobileNumber'] as String,
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.parse(userRecord['createdAt'] as String),
    );

    return ApiResponse.success(
      data: user,
      message: 'Authentication successful.',
      statusCode: 200,
    );
  }

  /// Simulated Registration API
  Future<ApiResponse<UserModel>> register({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
  }) async {
    // Simulate real network latency (1.4 seconds)
    await Future.delayed(const Duration(milliseconds: 1400));

    final cleanEmail = email.trim().toLowerCase();
    final cleanMobile = mobileNumber.trim();

    // Check if email already registered
    final emailExists = _mockDatabase.any(
      (u) => (u['email'] as String).toLowerCase() == cleanEmail,
    );
    if (emailExists) {
      return ApiResponse.failure(
        message: 'An account with this email address already exists.',
        statusCode: 409,
      );
    }

    // Check if mobile already registered
    final mobileExists = _mockDatabase.any(
      (u) => (u['mobileNumber'] as String) == cleanMobile,
    );
    if (mobileExists) {
      return ApiResponse.failure(
        message: 'An account with this mobile number already exists.',
        statusCode: 409,
      );
    }

    final newId = 'usr_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final now = DateTime.now();

    final newRecord = {
      'id': newId,
      'fullName': fullName.trim(),
      'email': cleanEmail,
      'mobileNumber': cleanMobile,
      'password': password,
      'createdAt': now.toIso8601String(),
    };

    _mockDatabase.add(newRecord);

    final user = UserModel(
      id: newId,
      fullName: fullName.trim(),
      email: cleanEmail,
      mobileNumber: cleanMobile,
      token: 'jwt_mock_token_${now.millisecondsSinceEpoch}',
      createdAt: now,
    );

    return ApiResponse.success(
      data: user,
      message: 'Account created successfully.',
      statusCode: 201,
    );
  }

  /// Simulated Forgot Password API
  Future<ApiResponse<void>> forgotPassword({
    required String identifier,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    final cleanId = identifier.trim().toLowerCase();
    final userRecord = _mockDatabase.firstWhere(
      (element) {
        final emailMatch = (element['email'] as String).toLowerCase() == cleanId;
        final mobileMatch = (element['mobileNumber'] as String) == identifier.trim();
        return emailMatch || mobileMatch;
      },
      orElse: () => {},
    );

    if (userRecord.isEmpty) {
      return ApiResponse.failure(
        message: 'No registered user matches this email or mobile number.',
        statusCode: 404,
      );
    }

    return ApiResponse.success(
      data: null,
      message: 'Reset instructions have been sent successfully.',
      statusCode: 200,
    );
  }
}
