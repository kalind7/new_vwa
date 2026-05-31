import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/add_vehicle_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/otp_verification_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/auth/presentation/screens/verify_email_screen.dart';
import '../features/foundation/presentation/screens/foundation_preview_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/onboarding/presentation/screens/splash_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify-email';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';
  static const String addVehicle = '/add-vehicle';
  static const String foundation = '/foundation';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = switch (settings.name) {
      splash || null => (_) => const SplashScreen(),
      onboarding => (_) => const OnboardingScreen(),
      login => (_) => const LoginScreen(),
      signUp => (_) => const SignUpScreen(),
      forgotPassword => (_) => const ForgotPasswordScreen(),
      verifyEmail => (_) => const VerifyEmailScreen(),
      verifyOtp => (_) => const OtpVerificationScreen(),
      resetPassword => (_) => const ResetPasswordScreen(),
      addVehicle => (_) => const AddVehicleScreen(),
      foundation => (_) => const FoundationPreviewScreen(),
      _ => (_) => const SplashScreen(),
    };

    return MaterialPageRoute<void>(builder: builder, settings: settings);
  }
}
