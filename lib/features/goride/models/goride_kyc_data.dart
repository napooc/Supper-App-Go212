import 'dart:typed_data';

/// Singleton qui stocke temporairement les données KYC entre les écrans
/// CIN → Scan (recto/verso) → Selfie → Verify
class GoRideKycData {
  GoRideKycData._();
  static final GoRideKycData instance = GoRideKycData._();

  // ── Données collectées ─────────────────────────────────────────
  String? cinNumber;          // Saisi dans kyc_cin_screen
  Uint8List? cinRectoBytes;   // Photo CIN recto
  Uint8List? cinVersoBytes;   // Photo CIN verso
  Uint8List? selfieBytes;     // Selfie utilisateur
  bool kycPassed = false;     // Flow KYC terminé côté front

  // ── Helpers ────────────────────────────────────────────────────
  bool get isComplete =>
      cinNumber != null &&
      cinRectoBytes != null &&
      cinVersoBytes != null &&
      selfieBytes != null;

  void clear() {
    cinNumber = null;
    cinRectoBytes = null;
    cinVersoBytes = null;
    selfieBytes = null;
    // NOTE: on ne reset PAS kycPassed ici — il persiste pour la session
  }
}
