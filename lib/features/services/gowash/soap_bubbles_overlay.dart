import 'dart:math';
import 'package:flutter/material.dart';

class SoapBubblesOverlay extends StatefulWidget {
  const SoapBubblesOverlay({super.key});

  @override
  State<SoapBubblesOverlay> createState() => _SoapBubblesOverlayState();
}

class _SoapBubblesOverlayState extends State<SoapBubblesOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Bubble> _bubbles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize bubbles with random properties
    for (int i = 0; i < 25; i++) {
      _bubbles.add(_Bubble.random(_random));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Update bubble positions
            for (var bubble in _bubbles) {
              bubble.update(constraints.maxWidth, constraints.maxHeight, _controller.value);
            }
            return RepaintBoundary(
              child: CustomPaint(
                painter: _BubblePainter(_bubbles),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              ),
            );
          },
        );
      },
    );
  }
}

class _Bubble {
  late double x;
  late double y;
  late double radius;
  late double speed;
  late double wobbleAmplitude;
  late double wobbleSpeed;
  late double initialX;
  late double opacity;

  _Bubble.random(Random random) {
    _reset(random, initial: true);
  }

  void _reset(Random random, {bool initial = false, double? height}) {
    radius = 5.0 + random.nextDouble() * 15.0; // 5px to 20px
    initialX = random.nextDouble();
    // Start at bottom or randomly distributed if initial
    y = initial ? random.nextDouble() : 1.1; 
    speed = 0.001 + random.nextDouble() * 0.002;
    wobbleAmplitude = 0.01 + random.nextDouble() * 0.03;
    wobbleSpeed = 2.0 + random.nextDouble() * 5.0;
    opacity = 0.1 + random.nextDouble() * 0.3;
  }

  void update(double width, double height, double animationValue) {
    y -= speed;
    if (y < -0.1) {
      y = 1.1;
      initialX = Random().nextDouble();
    }
    // Sinusoidal wobble
    double wobble = sin(y * wobbleSpeed * pi) * wobbleAmplitude;
    x = initialX + wobble;
  }
}

class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;

  _BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    final emeraldGreen = const Color(0xFF158F5A);
    
    for (var bubble in bubbles) {
      final center = Offset(bubble.x * size.width, bubble.y * size.height);
      final radius = bubble.radius;
      
      // Mix of white and a touch of emerald
      final isEmerald = bubble.initialX % 0.5 > 0.3; 
      final baseColor = isEmerald 
          ? emeraldGreen.withOpacity(bubble.opacity * 0.4) 
          : Colors.white.withOpacity(bubble.opacity);

      // Soap bubble effect using RadialGradient
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            baseColor.withOpacity(0.1),
            baseColor,
            baseColor.withOpacity(0.2),
          ],
          stops: const [0.0, 0.8, 1.0],
          center: const Alignment(-0.3, -0.3),
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      
      canvas.drawCircle(center, radius, paint);

      // Thin highlight border
      final borderPaint = Paint()
        ..color = baseColor.withOpacity(bubble.opacity * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      
      canvas.drawCircle(center, radius, borderPaint);

      // Small specular reflection (shine)
      final shinePaint = Paint()
        ..color = Colors.white.withOpacity(bubble.opacity * 1.2)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        center - Offset(radius * 0.4, radius * 0.4),
        radius * 0.15,
        shinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
