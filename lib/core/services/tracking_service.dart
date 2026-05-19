import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/api_config.dart';

/// Service Socket.io pour le tracking temps réel entre GoRide et Driver
/// 
/// Flow:
/// 1. Client crée une réservation → backend crée une delivery
/// 2. Driver accepte la mission → statut "accepted"
/// 3. Driver démarre → envoie sa position GPS toutes les 5s
/// 4. Client reçoit les updates en temps réel sur la carte
class TrackingService {
  TrackingService._();
  static final TrackingService instance = TrackingService._();

  IO.Socket? _socket;
  bool _isConnected = false;

  // ── Streams pour les updates temps réel ────────────────────────
  final _locationController = StreamController<DriverLocation>.broadcast();
  final _statusController = StreamController<DeliveryStatus>.broadcast();
  final _driverInfoController = StreamController<DriverInfo>.broadcast();

  Stream<DriverLocation> get locationStream => _locationController.stream;
  Stream<DeliveryStatus> get statusStream => _statusController.stream;
  Stream<DriverInfo> get driverInfoStream => _driverInfoController.stream;

  bool get isConnected => _isConnected;

  // ── Connexion Socket.io ───────────────────────────────────────
  void connect(String reservationId) {
    if (_socket != null) disconnect();

    final baseUrl = ApiConfig.baseUrl.replaceAll('/api/v1', '');
    // GoRide tourne sur le port 3004
    final socketUrl = baseUrl.contains(':3004') 
        ? baseUrl 
        : '${baseUrl.replaceAll(RegExp(r':\d+$'), '')}:3004';

    if (kDebugMode) debugPrint('🔌 Socket.io connecting to: $socketUrl');

    _socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
    });

    _socket!.onConnect((_) {
      _isConnected = true;
      if (kDebugMode) debugPrint('✅ Socket.io connected');
      
      // Rejoindre la room de la réservation
      _socket!.emit('tracking:join', reservationId);
      if (kDebugMode) debugPrint('📡 Joined room: reservation:$reservationId');
    });

    // ── Recevoir la position GPS du driver ──────────────────────
    _socket!.on('tracking:update', (data) {
      if (kDebugMode) debugPrint('📍 Location update: $data');
      try {
        final location = DriverLocation(
          lat: (data['lat'] as num).toDouble(),
          lng: (data['lng'] as num).toDouble(),
          timestamp: data['timestamp'] as String? ?? DateTime.now().toIso8601String(),
        );
        _locationController.add(location);
      } catch (e) {
        if (kDebugMode) debugPrint('❌ Location parse error: $e');
      }
    });

    // ── Recevoir les changements de statut (étapes) ─────────────
    _socket!.on('tracking:status_update', (data) {
      if (kDebugMode) debugPrint('🔄 Status update: $data');
      try {
        final status = DeliveryStatus(
          status: data['status'] as String? ?? 'pending',
          timestamp: data['timestamp'] as String? ?? DateTime.now().toIso8601String(),
        );
        _statusController.add(status);
      } catch (e) {
        if (kDebugMode) debugPrint('❌ Status parse error: $e');
      }
    });

    // ── Recevoir les infos du driver assigné ─────────────────────
    _socket!.on('tracking:driver_assigned', (data) {
      if (kDebugMode) debugPrint('🏍️ Driver assigned: $data');
      try {
        final info = DriverInfo(
          name: data['name'] as String? ?? 'Driver GO212',
          phone: data['phone'] as String? ?? '',
          vehiclePlate: data['vehicle_plate'] as String? ?? '',
          rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
          totalDeliveries: (data['total_deliveries'] as num?)?.toInt() ?? 0,
        );
        _driverInfoController.add(info);
      } catch (e) {
        if (kDebugMode) debugPrint('❌ Driver info parse error: $e');
      }
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      if (kDebugMode) debugPrint('🔌 Socket.io disconnected');
    });

    _socket!.onError((error) {
      if (kDebugMode) debugPrint('❌ Socket.io error: $error');
    });

    _socket!.connect();
  }

  // ── Déconnexion ───────────────────────────────────────────────
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _locationController.close();
    _statusController.close();
    _driverInfoController.close();
  }
}

// ── Data classes ──────────────────────────────────────────────────

class DriverLocation {
  final double lat;
  final double lng;
  final String timestamp;

  DriverLocation({required this.lat, required this.lng, required this.timestamp});
}

class DeliveryStatus {
  final String status; // pending, accepted, en_route, arrived, delivered
  final String timestamp;

  DeliveryStatus({required this.status, required this.timestamp});

  /// Convertir le status string en index pour le stepper UI
  int get stepIndex {
    switch (status) {
      case 'pending': return 0;
      case 'accepted': return 1;
      case 'en_route': return 2;
      case 'arrived': return 3;
      case 'delivered': return 3;
      default: return 0;
    }
  }
}

class DriverInfo {
  final String name;
  final String phone;
  final String vehiclePlate;
  final double rating;
  final int totalDeliveries;

  DriverInfo({
    required this.name,
    required this.phone,
    required this.vehiclePlate,
    required this.rating,
    required this.totalDeliveries,
  });
}
