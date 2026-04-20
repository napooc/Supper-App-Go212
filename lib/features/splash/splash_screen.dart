import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/go212_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _particleController;
  late AnimationController _progressController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;
  late Animation<double> _particleAnim;
  late Animation<double> _progressValue;
  late Animation<double> _textSlide;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _primaryController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _particleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat();
    _progressController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _primaryController, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _primaryController, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)));
    _ringScale = Tween<double>(begin: 0.6, end: 1.6).animate(CurvedAnimation(parent: _primaryController, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)));
    _ringOpacity = Tween<double>(begin: 0.6, end: 0.0).animate(CurvedAnimation(parent: _primaryController, curve: const Interval(0.3, 0.8, curve: Curves.easeOut)));
    _particleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_particleController);
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));
    _textSlide = Tween<double>(begin: 30.0, end: 0.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _primaryController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _progressController.forward();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) Navigator.of(context).pushReplacementNamed('/onboarding');
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _particleController.dispose();
    _progressController.dispose();
    _textController.dispose();
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
            begin: Alignment(-0.5, -1.0),
            end: Alignment(0.5, 1.0),
            colors: [Color(0xFF052E16), Color(0xFF065F46), Color(0xFF047857), Color(0xFF059669)],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated particle background
            AnimatedBuilder(
              animation: _particleAnim,
              builder: (_, __) => CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _ParticlePainter(_particleAnim.value),
              ),
            ),
            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  // Logo with expanding ring
                  AnimatedBuilder(
                    animation: _primaryController,
                    builder: (_, __) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Expanding ring
                          Transform.scale(
                            scale: _ringScale.value,
                            child: Container(
                              width: 120, height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(_ringOpacity.value * 0.4), width: 2),
                              ),
                            ),
                          ),
                          // Outer glow
                          Container(
                            width: 120, height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.white.withOpacity(0.15 * _logoOpacity.value), blurRadius: 60, spreadRadius: 20),
                                BoxShadow(color: Go212Colors.primary400.withOpacity(0.2 * _logoOpacity.value), blurRadius: 80, spreadRadius: 30),
                              ],
                            ),
                          ),
                          // Logo container
                          Transform.scale(
                            scale: _logoScale.value,
                            child: Opacity(
                              opacity: _logoOpacity.value,
                              child: Container(
                                width: 100, height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10)),
                                  ],
                                ),
                                child: Center(
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFF059669), Color(0xFF047857)],
                                    ).createShader(bounds),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('GO', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1, letterSpacing: -1.5)),
                                        Text('212', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1, letterSpacing: -1.5)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // Text
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (_, __) {
                      return Transform.translate(
                        offset: Offset(0, _textSlide.value),
                        child: Opacity(
                          opacity: _textOpacity.value,
                          child: Column(
                            children: [
                              Text('GO212', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 3)),
                              const SizedBox(height: 8),
                              Text('La Super App 100% Marocaine', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7), letterSpacing: 0.5)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(flex: 2),
                  // Progress
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (_, __) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 4,
                                child: LinearProgressIndicator(
                                  value: _progressValue.value,
                                  backgroundColor: Colors.white.withOpacity(0.15),
                                  valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.9)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Floating particle painter
class _ParticlePainter extends CustomPainter {
  final double progress;
  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rng = Random(42);
    for (int i = 0; i < 30; i++) {
      final x = rng.nextDouble() * size.width;
      final baseY = rng.nextDouble() * size.height;
      final speed = 0.3 + rng.nextDouble() * 0.7;
      final y = (baseY - progress * size.height * speed) % size.height;
      final radius = 1.0 + rng.nextDouble() * 2.5;
      final opacity = 0.05 + rng.nextDouble() * 0.12;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.progress != progress;
}
