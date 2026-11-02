import '../constants/app_strings.dart';

enum PasswordStrength { weak, medium, strong }

class Validators {
  // Regex patterns
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static final RegExp _phoneRegex = RegExp(r"^[0-9]{10}$");

  static final RegExp _nameRegex = RegExp(r"^[a-zA-Z\s]{3,50}$");

  /// Validates either an email or a 10-digit mobile number for Login
  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final trimmed = value.trim();
    final isEmail = _emailRegex.hasMatch(trimmed);
    final isPhone = _phoneRegex.hasMatch(trimmed);

    if (!isEmail && !isPhone) {
      return AppStrings.invalidIdentifier;
    }
    return null;
  }

  /// Validates Full Name
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return AppStrings.invalidName;
    }
    if (!_nameRegex.hasMatch(trimmed)) {
      return 'Name must contain only alphabets and spaces';
    }
    return null;
  }

  /// Validates standard email format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final trimmed = value.trim();
    if (!_emailRegex.hasMatch(trimmed)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  /// Validates standard 10-digit mobile number
  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final trimmed = value.trim();
    if (!_phoneRegex.hasMatch(trimmed)) {
      return AppStrings.invalidMobile;
    }
    return null;
  }

  /// Validates password with strength checks
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.length < 8) {
      return AppStrings.passwordTooShort;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return AppStrings.passwordNeedsUpper;
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return AppStrings.passwordNeedsLower;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return AppStrings.passwordNeedsDigit;
    }
    if (!RegExp(r'[@$!%*?&]').hasMatch(value)) {
      return AppStrings.passwordNeedsSpecial;
    }
    return null;
  }

  /// Validates confirm password matches password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  /// Calculates password strength score (0.0 to 1.0)
  static double getPasswordStrengthScore(String password) {
    if (password.isEmpty) return 0.0;
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[@$!%*?&]').hasMatch(password)) score++;

    return score / 5.0;
  }

  /// Categorizes password strength
  static PasswordStrength getPasswordStrength(String password) {
    final score = getPasswordStrengthScore(password);
    if (score <= 0.4) return PasswordStrength.weak;
    if (score <= 0.8) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }
}

