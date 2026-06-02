import 'package:flutter/material.dart';

import '../shared/utils/map_navigation.dart';
import '../features/auth/presentation/screens/add_vehicle_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/otp_verification_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/sign_up_screen.dart';
import '../features/auth/presentation/screens/verify_email_screen.dart';
import '../features/foundation/presentation/screens/foundation_preview_screen.dart';
import '../features/main/data/booking_flow_mock_data.dart';
import '../features/main/data/main_shell_mock_data.dart';
import '../features/main/presentation/screens/booking_success_screen.dart';
import '../features/main/presentation/screens/booking_summary_screen.dart';
import '../features/main/presentation/screens/feedback_thanks_screen.dart';
import '../features/main/presentation/screens/leave_review_screen.dart';
import '../features/main/presentation/screens/main_shell_screen.dart';
import '../features/main/presentation/screens/payment_history_screen.dart';
import '../features/main/presentation/screens/payment_method_screen.dart';
import '../features/main/presentation/screens/payment_result_screen.dart';
import '../features/main/presentation/screens/profile_settings_screens.dart';
import '../features/main/presentation/screens/reviews_screen.dart';
import '../features/main/presentation/screens/service_selection_screen.dart';
import '../features/main/presentation/screens/slot_selection_screen.dart';
import '../features/main/presentation/screens/station_detail_screen.dart';
import '../features/main/presentation/screens/wash_detail_screen.dart';
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
  static const String mainShell = '/main';
  static const String stationSearchMap = '/station-search-map';
  static const String stationDetail = '/station-detail';
  static const String serviceSelection = '/service-selection';
  static const String slotSelection = '/slot-selection';
  static const String bookingSummary = '/booking-summary';
  static const String paymentMethod = '/payment-method';
  static const String paymentResult = '/payment-result';
  static const String bookingSuccess = '/booking-success';
  static const String bookingInfo = '/booking-info';
  static const String leaveReview = '/leave-review';
  static const String feedbackThanks = '/feedback-thanks';
  static const String washDetail = '/wash-detail';
  static const String foundation = '/foundation';

  static BookingDraft _defaultDraft() {
    return BookingDraft(
      station: nearbyStations.first,
      service: washServices.first,
      slot: washSlots.first,
      vehicle: vehicles[2],
    );
  }

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
      mainShell => (_) {
        final initialIndex = settings.arguments is int
            ? settings.arguments as int
            : 0;
        return MainShellScreen(initialIndex: initialIndex);
      },
      // Map screen disabled for static UI phase — toast + pop.
      stationSearchMap => (context) => buildDisabledMapRoute(context),
      stationDetail => (_) {
        final station = settings.arguments is WashStationMock
            ? settings.arguments as WashStationMock
            : nearbyStations.first;
        return StationDetailScreen(station: station);
      },
      serviceSelection => (_) {
        final args = settings.arguments is StationBookingArgs
            ? settings.arguments as StationBookingArgs
            : StationBookingArgs(
                station: nearbyStations.first,
                vehicle: vehicles[2],
              );
        return ServiceSelectionScreen(args: args);
      },
      slotSelection => (_) {
        final draft = settings.arguments is BookingDraft
            ? settings.arguments as BookingDraft
            : _defaultDraft();
        return SlotSelectionScreen(draft: draft);
      },
      bookingSummary => (_) {
        final draft = settings.arguments is BookingDraft
            ? settings.arguments as BookingDraft
            : _defaultDraft();
        return BookingSummaryScreen(draft: draft);
      },
      paymentMethod => (_) {
        final draft = settings.arguments is BookingDraft
            ? settings.arguments as BookingDraft
            : _defaultDraft();
        return PaymentMethodScreen(draft: draft);
      },
      paymentResult => (_) {
        final draft = settings.arguments is BookingDraft
            ? settings.arguments as BookingDraft
            : _defaultDraft();
        return PaymentResultScreen(draft: draft);
      },
      bookingSuccess => (_) {
        final draft = settings.arguments is BookingDraft
            ? settings.arguments as BookingDraft
            : _defaultDraft();
        return BookingSuccessScreen(draft: draft);
      },
      bookingInfo => (_) {
        final draft = settings.arguments is BookingDraft
            ? settings.arguments as BookingDraft
            : _defaultDraft();
        return BookingInfoScreen(draft: draft);
      },
      leaveReview => (_) => const LeaveReviewScreen(),
      feedbackThanks => (_) => const FeedbackThanksScreen(),
      washDetail => (_) {
        final booking = settings.arguments is WashBookingMock
            ? settings.arguments as WashBookingMock
            : washBookings.first;
        return WashDetailScreen(booking: booking);
      },
      AppProfileRoutes.profileSetting => (_) => const ProfileSettingScreen(),
      AppProfileRoutes.myVehicle => (_) => const MyVehicleScreen(),
      AppProfileRoutes.saved => (_) => const SavedStationsScreen(),
      AppProfileRoutes.paymentHistory => (_) => const PaymentHistoryScreen(),
      AppProfileRoutes.reviews => (_) => const ReviewsScreen(),
      AppProfileRoutes.aboutUs => (_) => const AboutUsScreen(),
      AppProfileRoutes.terms => (_) => const TermsScreen(),
      AppProfileRoutes.privacyPolicy => (_) => const PrivacyPolicyScreen(),
      foundation => (_) => const FoundationPreviewScreen(),
      _ => (_) => const SplashScreen(),
    };

    return MaterialPageRoute<void>(
      builder: builder,
      settings: settings,
    );
  }
}
