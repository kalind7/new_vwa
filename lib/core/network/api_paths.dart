/// Relative API paths. [AppConfig.apiBaseUrl] already includes `/api/v1/`.
///
/// Aligned with Postman collection: Service Station Booking API (2026-04).
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
  static const String authMe = 'auth/me';

  // Vehicles
  static const String vehicles = 'vehicles';
  static String vehicleDetails(String id) => 'vehicles/$id';
  static String setDefaultVehicle(String id) => 'vehicles/$id/set-default';

  // Service stations
  static const String serviceStations = 'service-stations';
  static String serviceStationDetails(String id) => 'service-stations/$id';
  static const String nearestStations = 'service-stations/nearest';
  static const String suggestStationNearest = 'suggest-nearest';
  static String stationRatings(String stationId) =>
      'service-stations/$stationId/ratings';
  static String stationQueueStats(String stationId) =>
      'service-stations/$stationId/queue-stats';

  // Favorites
  static const String favorites = 'favorites';

  // Locations
  static const String locations = 'locations';

  // Bookings
  static const String bookings = 'bookings';
  static const String validateBookingPromo = 'bookings/validate-promo';
  static String bookingDetails(String id) => 'bookings/$id';
  static String cancelBooking(String id) => 'bookings/$id/cancel';

  // Payments
  static const String initiatePayment = 'payments/initiate';

  // Ratings
  static const String submitRating = 'ratings';
  static const String myRatings = 'ratings/my-ratings';

  // Rewards
  static const String rewardsBalance = 'rewards/balance';
  static const String rewardsTransactions = 'rewards/transactions';
  static const String rewardsRedeem = 'rewards/redeem';

  // Admin (station staff)
  static const String adminCheckRole = 'admin/check-role';
  static const String adminBookings = 'admin/bookings';
  static String adminBookingStatus(String id) => 'admin/bookings/$id/status';
  static const String adminQueue = 'admin/queue';

  // Notifications
  static const String notifications = 'notifications';
  static String notificationRead(String id) => 'notifications/$id/read';
  static const String notificationsReadAll = 'notifications/read-all';
  static String notificationDelete(String id) => 'notifications/$id';
  static const String authUpdateFcmToken = 'auth/update-fcm-token';
}
