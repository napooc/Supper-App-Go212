import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../../../core/services/goride_service.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_btn.dart';

class GoRideConfirmScreen extends StatefulWidget {
  const GoRideConfirmScreen({super.key});

  @override
  State<GoRideConfirmScreen> createState() => _GoRideConfirmScreenState();
}

class _GoRideConfirmScreenState extends State<GoRideConfirmScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkCtrl;
  late AnimationController _cardCtrl;
  late AnimationController _dotsCtrl;
  late Animation<double> _checkScale;
  late Animation<double> _cardFade;
  late Animation<double> _dotsAnim;

  bool _showDemande = true;
  bool _showSuccess = false;
  bool _showError = false;
  String? _errorMessage;
  String? _reservationId;

  @override
  void initState() {
    super.initState();

    _checkCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _checkScale = CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut);

    _cardCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _cardFade = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut);

    _dotsCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat();
    _dotsAnim = CurvedAnimation(parent: _dotsCtrl, curve: Curves.easeInOut);

    _runSequence();
  }

  Future<void> _runSequence() async {
    // ── Récupérer le booking depuis les arguments de navigation ──
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;

    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();

    // ── Appel RÉEL au backend GoRide ────────────────────────────
    try {
      final result = await GoRideService.instance.createReservation(
        nbPersons: booking.persons,
        durationType: booking.duration ?? 'jour',
        durationQty: booking.durationQuantity,
        startDate: booking.startDate?.toIso8601String().split('T').first ??
            DateTime.now().toIso8601String().split('T').first,
        startTime: booking.startTime,
        numMotos: booking.numMotos,
        deliveryType: booking.deliveryType ?? 'agence',
        deliveryAddress: booking.deliveryAddress,
        paymentMethod: booking.paymentMethod,
      );

      if (kDebugMode) debugPrint('📝 Reservation result: $result');

      if (!mounted) return;

      if (result['success'] == true) {
        // ── Succès → sauvegarder l'ID et afficher la confirmation ──
        final data = result['data'] as Map<String, dynamic>?;
        _reservationId = data?['id'] as String?;
        setState(() {
          _showDemande = false;
          _showSuccess = true;
        });
        _dotsCtrl.stop();
        _checkCtrl.forward();
        await Future.delayed(const Duration(milliseconds: 400));
        _cardCtrl.forward();
      } else {
        // ── Erreur API → afficher le message ───────────────────
        setState(() {
          _showDemande = false;
          _showError = true;
          _errorMessage = result['message'] as String? ?? 'Erreur inconnue';
        });
        _dotsCtrl.stop();
      }
    } catch (e) {
      // ── Erreur réseau → afficher fallback ────────────────────
      if (!mounted) return;
      if (kDebugMode) debugPrint('❌ Reservation error: $e');
      setState(() {
        _showDemande = false;
        _showError = true;
        _errorMessage = 'Impossible de joindre le serveur. Vérifiez votre connexion.';
      });
      _dotsCtrl.stop();
    }
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    _cardCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: _showDemande
                    ? _buildDemandeView(key: const ValueKey('demande'))
                    : _showError
                        ? _buildErrorView(key: const ValueKey('error'))
                        : _buildSuccessView(booking,
                            key: const ValueKey('success')),
              ),
            ),
            if (_showSuccess) _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDemandeView({Key? key}) {
    return Container(
      key: key,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo
            AnimatedBuilder(
              animation: _dotsAnim,
              builder: (_, child) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF16A34A)
                            .withOpacity(0.2 + _dotsAnim.value * 0.2),
                        blurRadius: 24 + _dotsAnim.value * 16,
                        spreadRadius: _dotsAnim.value * 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.pending_actions_rounded,
                      color: Colors.white, size: 48),
                );
              },
            ),
            const SizedBox(height: 36),
            const Text(
              'Demande en cours...',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),
            Text(
              'Traitement de votre réservation\nGoRide en cours',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: Go212Colors.neutral500, height: 1.5),
            ),
            const SizedBox(height: 40),
            _buildAnimatedDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDots() {
    return AnimatedBuilder(
      animation: _dotsCtrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (i) {
            final offset = (i / 4);
            final v = (((_dotsCtrl.value + offset) % 1.0));
            final opacity = (v < 0.5 ? v * 2 : (1.0 - v) * 2).clamp(0.2, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Go212Colors.primary600
                    .withOpacity(opacity.toDouble()),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildErrorView({Key? key}) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded,
                  color: Color(0xFFEF4444), size: 52),
            ),
            const SizedBox(height: 28),
            const Text(
              'Réservation échouée',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Une erreur est survenue',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: Go212Colors.neutral500, height: 1.5),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showError = false;
                  _showDemande = true;
                });
                _dotsCtrl.repeat();
                _runSequence();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text('Réessayer',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text('Retour',
                  style: TextStyle(
                      fontSize: 13,
                      color: Go212Colors.neutral500,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(GoRideBooking booking, {Key? key}) {
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          ScaleTransition(
            scale: _checkScale,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Go212Colors.primary100,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF16A34A).withOpacity(0.4),
                        blurRadius: 28,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 52),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          FadeTransition(
            opacity: _cardFade,
            child: Column(
              children: [
                const Text(
                  'Réservation confirmée ! 🎉',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Votre GoRide est en préparation.\nNous vous contactons sous peu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, color: Go212Colors.neutral500, height: 1.5),
                ),
                const SizedBox(height: 28),
                _buildConfirmCard(booking),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmCard(GoRideBooking booking) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Go212Colors.primary200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.confirmation_number_rounded,
                  size: 18, color: Go212Colors.primary600),
              const SizedBox(width: 8),
              Text(
                '#GR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Go212Colors.primary700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Go212Colors.primary100),
          const SizedBox(height: 16),
          _ConfirmRow('Formule', booking.durationLabel),
          _ConfirmRow('Départ', booking.formattedDate),
          _ConfirmRow('Heure', booking.startTime ?? '-'),
          _ConfirmRow('Réception', booking.deliveryLabel),
          _ConfirmRow('Paiement', _payLabel(booking.paymentMethod)),
        ],
      ),
    );
  }

  String _payLabel(String? m) {
    switch (m) {
      case 'cmi':
        return 'Carte bancaire';
      case 'orange':
        return 'Orange Money';
      case 'wafa':
        return 'Wafacash';
      case 'cash':
        return 'Cash à la livraison';
      default:
        return '-';
    }
  }

  Widget _buildFooter(BuildContext context) {
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();
    final isLivraison = booking.deliveryType != 'agence';
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Column(
        children: [
          GoRideBtn(
            label: isLivraison
                ? 'Suivre ma livraison'
                : 'Voir l\'itinéraire agence',
            icon: isLivraison ? Icons.location_on_rounded : Icons.store_rounded,
            onTap: () => Navigator.pushNamed(
              context,
              isLivraison ? '/goride/tracking' : '/goride/agence',
              arguments: booking.copyWith(
                confirmed: true,
                reservationId: _reservationId,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/main', (route) => false),
            child: Text(
              'Retour à l\'accueil',
              style: TextStyle(
                  fontSize: 13,
                  color: Go212Colors.neutral500,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label, value;
  const _ConfirmRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B))),
        ],
      ),
    );
  }
}
