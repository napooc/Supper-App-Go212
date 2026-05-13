import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

// ── User Model ──────────────────────────────────────────────────
class Go212User {
  final String id;
  final String phone;
  final String? fullName;
  final String? profilePic;
  final String role;
  final bool isNewUser;

  const Go212User({
    required this.id,
    required this.phone,
    this.fullName,
    this.profilePic,
    this.role = 'customer',
    this.isNewUser = false,
  });

  factory Go212User.fromJson(Map<String, dynamic> json) {
    return Go212User(
      id:         json['id']          as String,
      phone:      json['phone']       as String,
      fullName:   json['full_name']   as String?,
      profilePic: json['profile_pic'] as String?,
      role:       json['role']        as String? ?? 'customer',
      isNewUser:  json['is_new_user'] as bool?   ?? false,
    );
  }
}

// ── Auth Result ─────────────────────────────────────────────────
class AuthResult {
  final bool success;
  final String? message;
  final Go212User? user;
  final String? devOtp; // Only returned in dev mode

  const AuthResult({
    required this.success,
    this.message,
    this.user,
    this.devOtp,
  });
}

// ── Auth Service ────────────────────────────────────────────────
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyAccessToken  = 'go212_access_token';
  static const _keyRefreshToken = 'go212_refresh_token';
  static const _keyUserId       = 'go212_user_id';
  static const _keyPhone        = 'go212_phone';

  // ── HTTP client with timeout ───────────────────────────────────
  final _client = http.Client();
  static const _timeout = Duration(seconds: 15);

  // ── Send OTP ──────────────────────────────────────────────────
  Future<AuthResult> sendOtp(String phone) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConfig.otpSend),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': phone}),
          )
          .timeout(_timeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;

      if (kDebugMode) {
        debugPrint('📡 sendOtp → ${response.statusCode} | ${response.body}');
      }

      return AuthResult(
        success: success,
        message: body['message'] as String?,
        devOtp:  body['dev_otp'] as String?, // only in dev
      );
    } catch (e) {
      debugPrint('sendOtp error: $e');
      return AuthResult(
        success: false,
        message: 'Impossible de joindre le serveur. Vérifiez votre connexion.',
      );
    }
  }

  // ── Verify OTP ────────────────────────────────────────────────
  Future<AuthResult> verifyOtp(String phone, String otp) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConfig.otpVerify),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': phone, 'otp': otp}),
          )
          .timeout(_timeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final success = body['success'] as bool? ?? false;

      if (kDebugMode) {
        debugPrint('📡 verifyOtp → ${response.statusCode} | ${response.body}');
      }

      if (success) {
        final data = body['data'] as Map<String, dynamic>;
        final user = Go212User.fromJson(data['user'] as Map<String, dynamic>);

        // ── Persist tokens securely ──────────────────────────────
        await _storage.write(key: _keyAccessToken,  value: data['access_token']  as String);
        await _storage.write(key: _keyRefreshToken, value: data['refresh_token'] as String);
        await _storage.write(key: _keyUserId,       value: user.id);
        await _storage.write(key: _keyPhone,        value: user.phone);

        return AuthResult(success: true, user: user);
      }

      return AuthResult(
        success: false,
        message: body['message'] as String?,
      );
    } catch (e) {
      debugPrint('verifyOtp error: $e');
      return AuthResult(
        success: false,
        message: 'Impossible de joindre le serveur. Vérifiez votre connexion.',
      );
    }
  }

  // ── Check if logged in ────────────────────────────────────────
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _keyAccessToken);
    return token != null && token.isNotEmpty;
  }

  // ── Get access token ──────────────────────────────────────────
  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  // ── Get saved phone ───────────────────────────────────────────
  Future<String?> getSavedPhone() => _storage.read(key: _keyPhone);

  // ── Logout ────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        await _client.post(
          Uri.parse(ApiConfig.logout),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(_timeout);
      }
    } catch (_) {
      // Logout locally even if server call fails
    }
    await _storage.deleteAll();
  }
}
