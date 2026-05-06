// ignore_for_file: deprecated_member_use
import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─── ZelligePainter ──────────────────────────────────────────────────────────
/// Static Moroccan 8-pointed star (zellige) pattern — safe for Flutter Web
class ZelligePainter extends CustomPainter {
  final Color color;
  final double tileSize;

  const ZelligePainter({
    this.color = const Color(0x12FFFFFF),
    this.tileSize = 30.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final cols = (size.width / tileSize).ceil() + 2;
    final rows = (size.height / tileSize).ceil() + 2;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        _drawCell(canvas, paint, col * tileSize, row * tileSize);
      }
    }
  }

  void _drawCell(Canvas canvas, Paint paint, double ox, double oy) {
    final cx = ox + tileSize / 2;
    final cy = oy + tileSize / 2;
    final r = tileSize * 0.36;

    // Outer diamond
    final diamond = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r, cy)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r, cy)
      ..close();
    canvas.drawPath(diamond, paint);

    // Inner square (rotated 45° = diamond inside diamond = 8-star illusion)
    final r2 = r * 0.60;
    final inner = Path()
      ..moveTo(cx - r2, cy - r2)
      ..lineTo(cx + r2, cy - r2)
      ..lineTo(cx + r2, cy + r2)
      ..lineTo(cx - r2, cy + r2)
      ..close();
    canvas.drawPath(inner, paint);

    // Four petal arcs connecting cells (Moroccan flair)
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final arcR = tileSize * 0.22;
    // Top petal
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(cx, oy), width: arcR * 2, height: arcR * 2),
        0,
        math.pi,
        false,
        arcPaint);
    // Bottom petal
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(cx, oy + tileSize),
            width: arcR * 2,
            height: arcR * 2),
        math.pi,
        math.pi,
        false,
        arcPaint);
    // Left petal
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(ox, cy), width: arcR * 2, height: arcR * 2),
        math.pi / 2,
        math.pi,
        false,
        arcPaint);
    // Right petal
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(ox + tileSize, cy),
            width: arcR * 2,
            height: arcR * 2),
        -math.pi / 2,
        math.pi,
        false,
        arcPaint);
  }

  @override
  bool shouldRepaint(ZelligePainter old) => false;
}

// ─── ZelligeHeader ────────────────────────────────────────────────────────────
/// Drop-in replacement for a green gradient header Container.
/// Overlays a subtle zellige pattern on top of the gradient.
class ZelligeHeader extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double patternOpacity;
  final double tileSize;

  const ZelligeHeader({
    super.key,
    required this.child,
    this.gradientColors = const [Color(0xFF15803D), Color(0xFF22C55E)],
    this.patternOpacity = 0.10,
    this.tileSize = 30.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: ZelligePainter(
                color: Colors.white.withOpacity(patternOpacity),
                tileSize: tileSize,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

// ─── MotoMascotBadge ──────────────────────────────────────────────────────────
/// Small circular moto mascot for GoRide headers
class MotoMascotBadge extends StatelessWidget {
  final double size;
  const MotoMascotBadge({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.40),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/MOTO.png',
          width: size * 0.6,
          height: size * 0.6,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(
            Icons.two_wheeler_rounded,
            color: Colors.white,
            size: size * 0.52,
          ),
        ),
      ),
    );
  }
}
