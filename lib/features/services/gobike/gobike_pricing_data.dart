/// GoBike Pricing — Single Source of Truth
///
/// Set once in [GoBikeDurationScreen], optionally updated by
/// [GoBikeGroupReservationScreen] for bike count.
/// Read directly in [GoBikeCheckoutScreen].
/// No pricing calculations outside this file.
class GoBikePricingData {
  // ── Singleton ────────────────────────────────────────────────────────────
  static GoBikePricingData _current = const GoBikePricingData._empty();
  static GoBikePricingData get current => _current;

  /// Called by the duration screen when the user confirms a selection.
  static void set({
    required int durationIndex,
    required int quantity,
    int bikeCount = 1,
  }) {
    _current = GoBikePricingData(
      durationIndex: durationIndex,
      quantity: quantity,
      bikeCount: bikeCount,
    );
  }

  /// Called by the group-reservation screen when the user picks a bike count.
  static void updateBikeCount(int count) {
    _current = GoBikePricingData(
      durationIndex: _current.durationIndex,
      quantity: _current.quantity,
      bikeCount: count,
    );
  }

  static void reset() => _current = const GoBikePricingData._empty();

  // ── Price / label tables (index == durationIndex) ────────────────────────
  static const List<int>    _prices = [30, 150, 700, 2500];
  static const List<String> _labels = ['Heure', 'Jour', 'Semaine', 'Mois'];

  // ── Fields ───────────────────────────────────────────────────────────────
  final int durationIndex;
  final int quantity;    // # hours / days / weeks / months chosen
  final int bikeCount;  // 1 = solo, N = group

  const GoBikePricingData({
    required this.durationIndex,
    required this.quantity,
    required this.bikeCount,
  });

  const GoBikePricingData._empty()
      : durationIndex = 0,
        quantity = 1,
        bikeCount = 1;

  // ── Derived ──────────────────────────────────────────────────────────────
  bool get isGroupe => bikeCount > 1;

  int get unitPrice =>
      durationIndex < _prices.length ? _prices[durationIndex] : 30;

  String get unitLabel =>
      durationIndex < _labels.length ? _labels[durationIndex] : 'Heure';

  /// French-correct label: "1 Heure", "3 Heures", "1 Mois", "6 Mois"
  String get durationTitle {
    final plural = quantity > 1 && unitLabel != 'Mois' ? 's' : '';
    return '$quantity $unitLabel$plural';
  }

  /// Group discount: 10% for 3–4 bikes, 15% for 5+ bikes
  double get discountPercent {
    if (bikeCount >= 5) return 15;
    if (bikeCount >= 3) return 10;
    return 0;
  }

  /// Full price before discount
  int get baseTotal => unitPrice * quantity * bikeCount;

  /// Group discount in DH
  int get discountAmount => (baseTotal * discountPercent / 100).round();

  /// What the customer pays for the rental (before service fee)
  int get rentalTotal => baseTotal - discountAmount;

  /// Price hint shown in the group-reservation CTA
  String groupHint(int previewBikeCount) {
    final preview = GoBikePricingData(
      durationIndex: durationIndex,
      quantity: quantity,
      bikeCount: previewBikeCount,
    );
    final total = preview.rentalTotal;
    if (previewBikeCount >= 5) return '🎉 -15% groupe · Total: $total DH';
    if (previewBikeCount >= 3) return '🎁 -10% groupe · Total: $total DH';
    final need = 3 - previewBikeCount;
    return 'Total: $total DH · Ajoutez $need vélo${need > 1 ? "s" : ""} pour -10%';
  }
}
