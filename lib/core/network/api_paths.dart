/// Relative API paths. [AppConfig.apiBaseUrl] already includes `/api/v1/`.
class ApiPaths {
  const ApiPaths._();

  // Auth
  static const String authLogin = 'auth/login';
  static const String authRegister = 'auth/register';
  static const String authLogout = 'auth/logout';
  static const String authSendOtp = 'auth/send-otp';
  static const String authVerifyOtp = 'auth/verify-otp';
  static const String authForgotPassword = 'auth/forgot-password';
  static const String authResetPassword = 'auth/reset-password';

  // Profile & vehicles
  static const String userProfile = 'user/profile';
  static const String userVehicles = 'user/vehicles';

  // Stations
  static const String serviceStations = 'service-stations';
  static String serviceStationDetails(String id) => 'service-stations/$id';
  static const String nearestStations = 'service-stations/nearest';
  /// Postman: GET `suggest-nearest` (auth required, uses saved user location).
  static const String suggestStationNearest = 'suggest-nearest';

  // Location
  static const String userLocations = 'locations';
  static const String saveLocation = 'locations';

  // Bookings
  static const String bookings = 'bookings';
  static String bookingDetails(String id) => 'bookings/$id';
  static String cancelBooking(String id) => 'bookings/$id/cancel';

  // Payments & reviews
  static const String validatePromoCode = 'promo-codes/validate';
  static const String initiatePayment = 'payments/initiate';
  static const String submitRating = 'ratings';
  static const String userRatings = 'user/ratings';
  static String stationRatings(String stationId) =>
      'service-stations/$stationId/ratings';
}
