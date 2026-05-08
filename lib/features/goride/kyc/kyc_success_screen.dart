// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../widgets/goride_btn.dart';
import '../widgets/goride_header.dart';

class GoRideKycSuccessScreen extends StatefulWidget {
  const GoRideKycSuccessScreen({super.key});

  @override
  State<GoRideKycSuccessScreen> createState() => _GoRideKycSuccessScreenState();
}

class _GoRideKycSuccessScreenState extends State<GoRideKycSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkCtrl;
  late AnimationController _cardCtrl;
  late AnimationController _confettiCtrl;
  late Animation<double> _checkScale;
  late Animation<double> _cardSlide;
  late Animation<double> _confettiAnim;

  @override
  void initState() {
    super.initState();

    _checkCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _checkScale = CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut);

    _cardCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _cardSlide = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic);

    _confettiCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));
    _confettiAnim =
        CurvedAnimation(parent: _confettiCtrl, curve: Curves.easeOut);

    _runAnimation();
  }

  Future<void> _runAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _checkCtrl.forward();
    _confettiCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _cardCtrl.forward();
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    _cardCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      body: SafeArea(
        child: Stack(
          children: [
            // Confetti particles
            AnimatedBuilder(
              animation: _confettiAnim,
              builder: (_, __) => CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _ConfettiPainter(progress: _confettiAnim.value),
              ),
            ),
            // Main content
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSuccessIcon(),
                          const SizedBox(height: 32),
                          ScaleTransition(
                            scale: _cardSlide,
                            child: _buildSuccessCard(),
                          ),
                          const SizedBox(height: 28),
                          FadeTransition(
                            opacity: _cardSlide,
                            child: _buildDetailCards(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildFooter(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return ScaleTransition(
      scale: _checkScale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Go212Colors.primary100,
              shape: BoxShape.circle,
            ),
          ),
          // Mascot avatar circle
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
                  color: const Color(0xFF16A34A).withValues(alpha: 0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/images/mascot.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Check badge
          Positioned(
            bottom: 4,
            right: 12,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF0FDF4), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.4),
                    blurRadius: 8,
                  )
                ],
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16A34A).withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Identité vérifiée ! 🎉',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 10),
          Text(
            'Votre CIN a été validée avec succès.\nVous pouvez maintenant accéder à GoRide.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: Go212Colors.neutral500, height: 1.5),
          ),
          const SizedBox(height: 20),
          // Welcome badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Go212Colors.primary200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const GoRideMotoIcon(size: 20),
                const SizedBox(width: 8),
                Text(
                  'Bienvenue dans GoRide ! 🛵',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Go212Colors.primary700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCards() {
    final items = [
      (Icons.check_circle_rounded, 'CIN validée', 'Document authentique'),
      (Icons.face_rounded, 'Biométrie OK', 'Correspondance confirmée'),
      (Icons.lock_rounded, 'Données sécurisées', 'Chiffrement AES-256'),
    ];
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: items.indexOf(item) == 0 ? 0 : 6,
              right: items.indexOf(item) == items.length - 1 ? 0 : 6,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Go212Colors.primary100),
            ),
            child: Column(
              children: [
                Icon(item.$1, size: 22, color: Go212Colors.primary600),
                const SizedBox(height: 6),
                Text(
                  item.$2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B)),
                ),
                Text(
                  item.$3,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Go212Colors.neutral400),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      color: const Color(0xFFF0FDF4),
      child: Column(
        children: [
          GoRideBtn(
            label: 'Découvrir GoRide',
            icon: Icons.two_wheeler_rounded,
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/goride/transition'),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/main', (route) => false),
            child: Text(
              'Retour à l\'accueil',
              style: TextStyle(
                  fontSize: 13,
                  color: Go212Colors.neutral500,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// Confetti painter — small colored shapes falling down
class _ConfettiPainter extends CustomPainter {
  final double progress;
  final math.Random _rng = math.Random(42);

  _ConfettiPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFF22C55E),
      const Color(0xFF16A34A),
      const Color(0xFF4ADE80),
      const Color(0xFF86EFAC),
      const Color(0xFFFBBF24),
      const Color(0xFF3B82F6),
      const Color(0xFFF97316),
    ];

    for (int i = 0; i < 35; i++) {
      final x = _rng.nextDouble() * size.width;
      final startY = _rng.nextDouble() * -100;
      final endY = size.height + 50;
      final speed = 0.5 + _rng.nextDouble() * 0.5;
      final y = startY + (endY - startY) * (progress * speed).clamp(0.0, 1.0);
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      final color = colors[i % colors.length].withValues(alpha: opacity * 0.7);
      final paint = Paint()..color = color;

      final rotation = progress * math.pi * (2 + _rng.nextDouble() * 4);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      if (i % 3 == 0) {
        // Small rectangle
        canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(-4, -2, 8, 4), const Radius.circular(1)),
          paint,
        );
      } else if (i % 3 == 1) {
        // Small circle
        canvas.drawCircle(Offset.zero, 3, paint);
      } else {
        // Small diamond
        final path = Path()
          ..moveTo(0, -4)
          ..lineTo(3, 0)
          ..lineTo(0, 4)
          ..lineTo(-3, 0)
          ..close();
        canvas.drawPath(path, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
