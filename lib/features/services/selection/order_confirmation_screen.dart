import 'dart:async';
import 'package:flutter/material.dart';
import '../gowash/mascot_en_route_screen.dart';
import '../gowash/gowash_header.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String vehicleType;
  final String brandName;
  final String packName;
  final String selectedDate;
  final String selectedTime;

  const OrderConfirmationScreen({
    super.key,
    required this.vehicleType,
    required this.brandName,
    required this.packName,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with TickerProviderStateMixin {
  static const _green    = Color(0xFF179B2E);
  static const _darkBlue = Color(0xFF1E293B);
  bool _isConfirmed = false;

  // Soft glow-pulse animation on the main circle shadow
  late final AnimationController _pulseCtrl;
  late final Animation<double>    _pulseAnim;

  // Dot blink for the status chip
  late final AnimationController _dotCtrl;
  late final Animation<double>    _dotAnim;

  @override
  void initState() {
    super.initState();

    // ── Pulse ───────────────────────────────────────────────────────────────
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // ── Dot blink ────────────────────────────────────────────────────────────
    _dotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _dotAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _dotCtrl, curve: Curves.easeInOut),
    );

    // ── Confirmation timer ───────────────────────────────────────────────────
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isConfirmed = true);

        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MascotEnRouteScreen(
                  vehicleType: widget.vehicleType,
                  brandName:   widget.brandName,
                ),
              ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _dotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          GoWashHeader(
            title:    _isConfirmed ? 'Commande confirmée !' : 'Confirmation',
            stepText: '4/4',
            onBack:   null,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // ── 1. Success circle (pulse + sparkles + rings) ──────────
                    SizedBox(
                      width: 230,
                      height: 230,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ring — expands on confirm
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.easeOut,
                            width:  _isConfirmed ? 225 : 140,
                            height: _isConfirmed ? 225 : 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _green.withOpacity(_isConfirmed ? 0.12 : 0),
                                width: 1.5,
                              ),
                            ),
                          ),
                          // Inner halo — expands on confirm
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 550),
                            curve: Curves.easeOut,
                            width:  _isConfirmed ? 185 : 140,
                            height: _isConfirmed ? 185 : 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _green.withOpacity(_isConfirmed ? 0.07 : 0),
                            ),
                          ),
                          // Main circle — soft glow pulse
                          AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (_, __) => Container(
                              width:  140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _green,
                                boxShadow: [
                                  BoxShadow(
                                    color: _green.withOpacity(
                                        0.22 + 0.12 * _pulseAnim.value),
                                    blurRadius:
                                        32 + 16 * _pulseAnim.value,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              // Circle interior: check + small premium badge
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Main check icon
                                  const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 66,
                                  ),
                                  // Small premium badge — top-right inside circle
                                  Positioned(
                                    top: 20,
                                    right: 18,
                                    child: AnimatedOpacity(
                                      opacity: _isConfirmed ? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 800),
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.18),
                                        ),
                                        child: const Icon(
                                          Icons.workspace_premium,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Small celebration accent — bottom-left inside circle
                                  Positioned(
                                    bottom: 20,
                                    left: 18,
                                    child: AnimatedOpacity(
                                      opacity: _isConfirmed ? 1.0 : 0.0,
                                      duration: const Duration(milliseconds: 900),
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.15),
                                        ),
                                        child: const Icon(
                                          Icons.celebration,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Sparkles — fade in when confirmed
                          _sparkle(top: 8,    right: 14, size: 16, opacity: 0.85, ms: 600),
                          _sparkle(top: 18,   left:  10, size: 10, opacity: 0.50, ms: 700, star: false),
                          _sparkle(right: 3,  top:   95, size: 10, opacity: 0.45, ms: 650, star: true),
                          _sparkle(left:  3,  top:   95, size:  9, opacity: 0.40, ms: 750, star: false),
                          _sparkle(bottom: 12, right: 12, size: 13, opacity: 0.65, ms: 680),
                          _sparkle(bottom: 8,  left:  14, size: 15, opacity: 0.80, ms: 720),
                          _sparkle(top: 2,    left:  92, size:  8, opacity: 0.35, ms: 600, star: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── 2. Headline only ──────────────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Text(
                        key: ValueKey(_isConfirmed),
                        _isConfirmed
                            ? 'Commande confirmée ! 🎉'
                            : 'L\'équipe GO212 consulte\nvotre demande…',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:      _isConfirmed ? 27 : 20,
                          fontWeight:    FontWeight.w900,
                          color:         _isConfirmed ? _darkBlue : Colors.grey.shade400,
                          letterSpacing: _isConfirmed ? -0.5 : 0.1,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── 4. Status chip (only when confirmed) ──────────────────
                    AnimatedOpacity(
                      opacity:  _isConfirmed ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: _green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _green.withOpacity(0.20),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:      _green.withOpacity(0.08),
                              blurRadius: 16,
                              offset:     const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Blinking green dot
                            AnimatedBuilder(
                              animation: _dotAnim,
                              builder: (_, __) => Container(
                                width:  8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _green.withOpacity(_dotAnim.value),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'WashBoy assigné · En préparation',
                              style: TextStyle(
                                fontSize:   13,
                                fontWeight: FontWeight.w700,
                                color:      _green,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper — builds a positioned sparkle icon with AnimatedOpacity
  Widget _sparkle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double opacity,
    required int ms,
    bool star = false,
  }) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: AnimatedOpacity(
        opacity:  _isConfirmed ? opacity : 0.0,
        duration: Duration(milliseconds: ms),
        child: Icon(
          star ? Icons.star_rounded : Icons.auto_awesome,
          color: _green,
          size:  size,
        ),
      ),
    );
  }
}
