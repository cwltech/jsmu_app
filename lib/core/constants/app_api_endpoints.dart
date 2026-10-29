class AppApiEndpoints {
  AppApiEndpoints._();

  static const String baseUrl = 'https://api.jsmu.app/v1';

  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh';
  static const String userProfile = '/user/profile';

  // Services & Categories
  static const String categories = '/services/categories';
  static const String popularServices = '/services/popular';
  static const String serviceDetails = '/services/';

  // Bookings
  static const String createBooking = '/bookings/create';
  static const String bookingDetails = '/bookings/';
  static const String activeTracking = '/bookings/tracking/';

  // Partner Pro
  static const String partnerStatus = '/partner/status';
  static const String partnerMetrics = '/partner/metrics';
  static const String acceptLead = '/partner/leads/accept';
  static const String rejectLead = '/partner/leads/reject';
  static const String partnerWallet = '/partner/wallet';
}
