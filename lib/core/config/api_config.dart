/// GO212 API Configuration — single source of truth for all backend URLs.
/// Toggle [_isProduction] to switch between dev IP and live HTTPS domain.
class ApiConfig {
  // ── Environment ──────────────────────────────────────────────────────────
  static const bool _isProduction = true; // ✅ Live — api.api-go212.online

  static const String _devBase  = 'http://62.84.177.120:3001';
  static const String _prodBase = 'https://api.api-go212.online';

  static String get baseUrl => _isProduction ? _prodBase : _devBase;

  // ── Auth ─────────────────────────────────────────────────────────────────
  static String get otpSend     => '$baseUrl/api/v1/auth/otp/send';
  static String get otpVerify   => '$baseUrl/api/v1/auth/otp/verify';
  static String get authRefresh => '$baseUrl/api/v1/auth/refresh';
  static String get logout      => '$baseUrl/api/v1/auth/logout';
  static String get health      => '$baseUrl/health';

  // ── GoBike ───────────────────────────────────────────────────────────────
  static String get goBikeRental   => '$baseUrl/api/v1/gobike/rental';
  static String get goBikeServices => '$baseUrl/api/v1/gobike/services';
  static String goBikeRentalById(String id) => '$baseUrl/api/v1/gobike/rental/$id';

  // ── GoWash ───────────────────────────────────────────────────────────────
  static String get goWashPacks   => '$baseUrl/api/v1/gowash/packs';
  static String get goWashBooking => '$baseUrl/api/v1/gowash/booking';
  static String goWashBookingById(String id) => '$baseUrl/api/v1/gowash/booking/$id';

  // ── GoRide ───────────────────────────────────────────────────────────────
  static String get goRideMotos        => '$baseUrl/api/v1/goride/motos';
  static String get goRideReservations => '$baseUrl/api/v1/goride/reservations';
  static String get goRideKyc          => '$baseUrl/api/v1/goride/kyc';
  static String get goRideKycStatus    => '$baseUrl/api/v1/goride/kyc/status';
  static String get goRideReviews      => '$baseUrl/api/v1/goride/reviews';
  static String goRideReservationById(String id) => '$baseUrl/api/v1/goride/reservations/$id';
  static String goRideCancelReservation(String id) => '$baseUrl/api/v1/goride/reservations/$id/cancel';

  // ── Payments ─────────────────────────────────────────────────────────────
  static String get paymentIntent  => '$baseUrl/api/v1/payments/intent';
  static String get paymentConfirm => '$baseUrl/api/v1/payments/confirm';
  static String get paymentHistory => '$baseUrl/api/v1/payments/history';
}
