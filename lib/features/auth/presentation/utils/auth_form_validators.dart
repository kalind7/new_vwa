class AuthFormValidators {
  const AuthFormValidators._();

  static String? requiredName(String? value, String fieldName) {
    if (_isBlank(value)) {
      return '$fieldName is required';
    }
    if (value!.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  static String? email(String? value) {
    if (_isBlank(value)) {
      return 'Email is required';
    }
    final trimmed = value!.trim();
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    if (_isBlank(value)) {
      return 'Phone number is required';
    }
    final trimmed = value!.trim();
    if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
      return 'Use numbers only';
    }
    if (trimmed.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  static String? password(String? value) {
    if (_isBlank(value)) {
      return 'Password is required';
    }
    final password = value!;
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) {
      return 'Password must contain one special character';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final passwordError = AuthFormValidators.password(value);
    if (passwordError != null) {
      return passwordError;
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? otp(String? value) {
    if (_isBlank(value)) {
      return 'OTP is required';
    }
    final trimmed = value!.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(trimmed)) {
      return 'Enter the 6-digit OTP';
    }
    return null;
  }

  static String? vehicleNumber(String? value) {
    if (_isBlank(value)) {
      return 'Vehicle number is required';
    }
    final trimmed = value!.trim();
    if (trimmed.length < 4) {
      return 'Enter a valid vehicle number';
    }
    if (!RegExp(r'^[A-Za-z0-9 -]+$').hasMatch(trimmed)) {
      return 'Use letters, numbers, spaces, or hyphens only';
    }
    return null;
  }

  static bool hasMinPasswordLength(String value) => value.length >= 8;

  static bool hasPasswordSpecialCharacter(String value) =>
      RegExp(r'[^A-Za-z0-9]').hasMatch(value);

  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;
}
