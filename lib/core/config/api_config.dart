/// GO212 API Configuration — single source of truth for all backend URLs.
/// Toggle [_isProduction] to switch between dev IP and live HTTPS domain.
class ApiConfig {
  // ── Environment ──────────────────────────────────────────────────────────
  static const bool _isProduction = false; // ← flip to true before Play Store release

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
  static String get goRideTrip    => '$baseUrl/api/v1/goride/trip';
  static String get goRideDrivers => '$baseUrl/api/v1/goride/drivers';

  // ── Payments ─────────────────────────────────────────────────────────────
  static String get paymentIntent  => '$baseUrl/api/v1/payments/intent';
  static String get paymentConfirm => '$baseUrl/api/v1/payments/confirm';
  static String get paymentHistory => '$baseUrl/api/v1/payments/history';
}
