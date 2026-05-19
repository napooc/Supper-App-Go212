import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

// ── GoRide API Service ──────────────────────────────────────────────────
// Fait le lien entre le front Flutter et le backend GoRide (port 3004)
// Pattern identique à auth_service.dart
class GoRideService {
  GoRideService._();
  static final GoRideService instance = GoRideService._();

  final _client = http.Client();
  static const _timeout = Duration(seconds: 15);

  // ── Headers avec JWT token ────────────────────────────────────────────
  Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.instance.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ══════════════════════════════════════════════════════════════════════
  //  MOTOS
  // ══════════════════════════════════════════════════════════════════════

  /// Liste des motos disponibles
  Future<Map<String, dynamic>> getMotos() async {
    try {
      final headers = await _authHeaders();
      final response = await _client
          .get(Uri.parse(ApiConfig.goRideMotos), headers: headers)
          .timeout(_timeout);

      if (kDebugMode) debugPrint('🏍️ getMotos → ${response.statusCode}');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('getMotos error: $e');
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  //  RÉSERVATIONS
  // ══════════════════════════════════════════════════════════════════════

  /// Créer une réservation (appelé depuis GoRideSummaryScreen → Confirmer)
  Future<Map<String, dynamic>> createReservation({
    required int nbPersons,
    required String durationType,
    required int durationQty,
    required String startDate,
    String? startTime,
    int numMotos = 1,
    required String deliveryType,
    String? deliveryAddress,
    String? paymentMethod,
    String? motoId,
  }) async {
    try {
      final headers = await _authHeaders();
      final body = jsonEncode({
        'nb_persons': nbPersons,
        'duration_type': durationType,
        'duration_qty': durationQty,
        'start_date': startDate,
        'start_time': startTime,
        'num_motos': numMotos,
        'delivery_type': deliveryType,
        'delivery_address': deliveryAddress,
        'payment_method': paymentMethod,
        'moto_id': motoId,
      });

      final response = await _client
          .post(Uri.parse(ApiConfig.goRideReservations),
              headers: headers, body: body)
          .timeout(_timeout);

      if (kDebugMode) {
        debugPrint('📝 createReservation → ${response.statusCode}');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('createReservation error: $e');
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  /// Mes réservations (historique)
  Future<Map<String, dynamic>> getMyReservations() async {
    try {
      final headers = await _authHeaders();
      final response = await _client
          .get(Uri.parse(ApiConfig.goRideReservations), headers: headers)
          .timeout(_timeout);

      if (kDebugMode) debugPrint('📋 getReservations → ${response.statusCode}');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('getMyReservations error: $e');
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  /// Détail d'une réservation (pour le tracking)
  Future<Map<String, dynamic>> getReservation(String id) async {
    try {
      final headers = await _authHeaders();
      final response = await _client
          .get(Uri.parse(ApiConfig.goRideReservationById(id)),
              headers: headers)
          .timeout(_timeout);

      if (kDebugMode) debugPrint('🔍 getReservation → ${response.statusCode}');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('getReservation error: $e');
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  /// Annuler une réservation
  Future<Map<String, dynamic>> cancelReservation(String id) async {
    try {
      final headers = await _authHeaders();
      final response = await _client
          .patch(Uri.parse(ApiConfig.goRideCancelReservation(id)),
              headers: headers)
          .timeout(_timeout);

      if (kDebugMode) debugPrint('❌ cancelReservation → ${response.statusCode}');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('cancelReservation error: $e');
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  //  KYC
  // ══════════════════════════════════════════════════════════════════════

  /// Soumettre les documents KYC (CIN + selfie)
  Future<Map<String, dynamic>> submitKyc({
    required String cinRecto,
    String? cinVerso,
    required String selfieUrl,
  }) async {
    try {
      final headers = await _authHeaders();
      final body = jsonEncode({
        'cin_recto': cinRecto,
        'cin_verso': cinVerso,
        'selfie_url': selfieUrl,
      });

      final response = await _client
          .post(Uri.parse(ApiConfig.goRideKyc), headers: headers, body: body)
          .timeout(const Duration(seconds: 60)); // KYC: OCR takes longer

      if (kDebugMode) debugPrint('📄 submitKyc → ${response.statusCode}');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('submitKyc error: $e');
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  /// Vérifier le statut KYC
  Future<Map<String, dynamic>> getKycStatus() async {
    try {
      final headers = await _authHeaders();
      final response = await _client
          .get(Uri.parse(ApiConfig.goRideKycStatus), headers: headers)
          .timeout(_timeout);

      if (kDebugMode) debugPrint('🔒 kycStatus → ${response.statusCode}');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('getKycStatus error: $e');
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  // ══════════════════════════════════════════════════════════════════════
  //  REVIEWS
  // ══════════════════════════════════════════════════════════════════════

  /// Soumettre un avis
  Future<Map<String, dynamic>> submitReview({
    String? reservationId,
    required int note,
    List<String>? tags,
    String? commentaire,
  }) async {
    try {
      final headers = await _authHeaders();
      final body = jsonEncode({
        'reservation_id': reservationId,
        'note': note,
        'tags': tags,
        'commentaire': commentaire,
      });

      final response = await _client
          .post(Uri.parse(ApiConfig.goRideReviews),
              headers: headers, body: body)
          .timeout(_timeout);

      if (kDebugMode) debugPrint('⭐ submitReview → ${response.statusCode}');
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('submitReview error: $e');
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }
}
