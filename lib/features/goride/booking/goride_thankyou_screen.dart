// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';

class GoRideThankYouScreen extends StatefulWidget {
  const GoRideThankYouScreen({super.key});
  @override
  State<GoRideThankYouScreen> createState() => _GoRideThankYouScreenState();
}

class _GoRideThankYouScreenState extends State<GoRideThankYouScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _slideCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _particleCtrl;
  late Animation<Offset> _slideAnim;
  Timer? _redirectTimer;
  int _countdown = 10;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();

    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _slideCtrl.forward();
    });

    // Countdown timer
    _redirectTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown--);
      if (_countdown <= 0) {
        t.cancel();
        Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false);
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    _pulseCtrl.dispose();
    _particleCtrl.dispose();
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF052E16), Color(0xFF14532D), Color(0xFF166534), Color(0xFF15803D)],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: Stack(children: [
          // Particle background
          AnimatedBuilder(
            animation: _particleCtrl,
            builder: (_, __) => CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _ParticlePainter(_particleCtrl.value),
            ),
          ),

          SafeArea(
            child: Column(children: [
              const SizedBox(height: 16),

              // Badge
              FadeTransition(
                opacity: _fadeCtrl,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: const Text('🦁  GO212 GoRide', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),

              const Spacer(flex: 1),

              // ── Animated celebration widget (replaces web video) ──
              FadeTransition(
                opacity: _fadeCtrl,
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, __) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 15)),
                        BoxShadow(color: const Color(0xFF4ADE80).withOpacity(0.15 + _pulseCtrl.value * 0.1), blurRadius: 60, spreadRadius: 10),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF4ADE80).withOpacity(0.15 + _pulseCtrl.value * 0.08),
                              const Color(0xFF052E16),
                            ],
                          ),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          // Big animated checkmark
                          Transform.scale(
                            scale: 1.0 + _pulseCtrl.value * 0.05,
                            child: Container(
                              width: 110, height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF22C55E).withOpacity(0.15),
                                border: Border.all(color: const Color(0xFF4ADE80).withOpacity(0.4 + _pulseCtrl.value * 0.3), width: 2),
                              ),
                              child: const Center(child: Text('✅', style: TextStyle(fontSize: 52))),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text('Trajet terminé !', style: TextStyle(
                            color: const Color(0xFF4ADE80).withOpacity(0.9 + _pulseCtrl.value * 0.1),
                            fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 0.5,
                          )),
                          const SizedBox(height: 8),
                          const Text('🎉 Merci d\'avoir choisi GO212', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Text section
              SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeCtrl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(children: [
                      const Text('Merci & À bientôt ! 👋',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5, height: 1.2)),
                      const SizedBox(height: 14),
                      Text(
                        'Votre expérience GO212 GoRide est terminée.\nOn se retrouve pour votre prochaine aventure ! 🚀',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.65), height: 1.6)),
                      const SizedBox(height: 24),
                      Container(width: 50, height: 3,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(colors: [Color(0xFF4ADE80), Color(0xFF86EFAC)]))),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6))]),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.home_rounded, color: Go212Colors.primary700, size: 20),
                            const SizedBox(width: 10),
                            Text('Retour à l\'accueil', style: TextStyle(color: Go212Colors.primary700, fontSize: 14, fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              FadeTransition(
                opacity: _fadeCtrl,
                child: Text(
                  'Redirection dans $_countdown secondes…',
                  style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.35)),
                ),
              ),
              const SizedBox(height: 16),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double t;
  _ParticlePainter(this.t);
  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 30; i++) {
      final x = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final speed = 0.3 + rng.nextDouble() * 0.7;
      final y = (baseY - t * speed * 200) % size.height;
      final r = 1.5 + rng.nextDouble() * 3;
      final pulse = math.sin((t + rng.nextDouble()) * math.pi * 2) * 0.5 + 0.5;
      paint.color = const Color(0xFF4ADE80).withOpacity(0.04 + pulse * 0.08);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }
  @override bool shouldRepaint(_ParticlePainter o) => o.t != t;
}
