// ignore_for_file: deprecated_member_use
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Modern clean header for GoRide — replaces ZelligeHeader.
/// Uses smooth gradient + elegant wave/glow pattern.
class GoRideHeader extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;

  const GoRideHeader({
    super.key,
    required this.child,
    this.gradientColors = const [
      Color(0xFF062E16),
      Color(0xFF14532D),
      Color(0xFF16A34A),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Elegant light waves
          Positioned.fill(
            child: CustomPaint(
              painter: _WaveGlowPainter(),
            ),
          ),
          // Smooth curved bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: _SmoothCurveClipper(),
              child: Container(
                height: 22,
                color: const Color(0xFFF5F7FA),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Elegant wave and glow effect — no circles
class _WaveGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Soft diagonal light streak
    final streakPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.02),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final streakPath = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.6)
      ..quadraticBezierTo(
          size.width * 0.7, size.height * 0.3, size.width * 0.5, 0)
      ..close();
    canvas.drawPath(streakPath, streakPaint);

    // Bottom-left subtle glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.8, 1.0),
        radius: 0.7,
        colors: [
          const Color(0xFF4ADE80).withOpacity(0.12),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);

    // Top-right subtle glow
    final glow2 = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.9, -0.8),
        radius: 0.5,
        colors: [
          Colors.white.withOpacity(0.06),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glow2);

    // Thin elegant wave line across the header
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final wavePath = Path()
      ..moveTo(0, size.height * 0.65);
    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height * 0.65 +
          math.sin(x / size.width * math.pi * 3) * 8 +
          math.sin(x / size.width * math.pi * 1.5) * 4;
      wavePath.lineTo(x, y);
    }
    canvas.drawPath(wavePath, wavePaint);

    // Second wave slightly offset
    final wave2 = Path()
      ..moveTo(0, size.height * 0.45);
    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height * 0.45 +
          math.sin(x / size.width * math.pi * 2 + 1) * 6 +
          math.cos(x / size.width * math.pi * 4) * 3;
      wave2.lineTo(x, y);
    }
    canvas.drawPath(
        wave2, wavePaint..color = Colors.white.withOpacity(0.04));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SmoothCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height * 0.35)
      ..quadraticBezierTo(
          size.width * 0.5, -size.height * 0.4, 0, size.height * 0.35)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Back button for GoRide headers
class GoRideBackBtn extends StatelessWidget {
  final VoidCallback onTap;
  const GoRideBackBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.20), width: 1),
        ),
        child: const Icon(Icons.arrow_back_rounded,
            color: Colors.white, size: 20),
      ),
    );
  }
}

/// Step badge showing "X / Y"
class GoRideStepBadge extends StatelessWidget {
  final int step;
  final int total;
  const GoRideStepBadge(
      {super.key, required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Text(
        '$step / $total',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Mascot badge — uses the lion-on-moto image
class GoRideMascotBadge extends StatelessWidget {
  final double size;
  const GoRideMascotBadge({super.key, this.size = 48.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
      ),
      child: ClipOval(
        child: Padding(
          padding: EdgeInsets.all(size * 0.08),
          child: Image.asset(
            'assets/images/mascot_moto.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

/// Moto icon — uses the GO212 moto image instead of generic icon
class GoRideMotoIcon extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  const GoRideMotoIcon({super.key, this.size = 28.0, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/MOTO.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.electric_moped_rounded,
          size: size * 0.8,
          color: const Color(0xFF16A34A),
        ),
      ),
    );
  }
}

