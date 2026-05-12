import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _bgController;
  late AnimationController _mascotController;
  late AnimationController _logoController;
  late AnimationController _floatController;
  late AnimationController _loadingController;
  late AnimationController _particleController;
  late AnimationController _waveController;
  late AnimationController _ringController;

  // Mascot animations
  late Animation<double> _mascotScale;
  late Animation<double> _mascotOpacity;
  late Animation<double> _mascotY;

  // Wave
  late Animation<double> _wave;

  // Logo animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoSlide;

  // Loading
  late Animation<double> _loadingProgress;

  // Float / particles
  late Animation<double> _float;
  late Animation<double> _particles;
  late Animation<double> _ring;

  // BG gradient
  late Animation<double> _bg;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..repeat(reverse: true);

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    // BG
    _bg = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeOut),
    );

    // Mascot
    _mascotScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.elasticOut),
    );
    _mascotOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mascotController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _mascotY = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeOutBack),
    );

    // Wave
    _wave = Tween<double>(begin: -0.35, end: 0.35).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    // Logo
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.bounceOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _logoSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    // Loading
    _loadingProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    // Float
    _float = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Particles
    _particles =
        Tween<double>(begin: 0.0, end: 1.0).animate(_particleController);

    // Ring
    _ring = Tween<double>(begin: 0.0, end: 1.0).animate(_ringController);

    _runSequence();
  }

  void _runSequence() async {
    _bgController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _mascotController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 350));
    _loadingController.forward();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _mascotController.dispose();
    _logoController.dispose();
    _floatController.dispose();
    _loadingController.dispose();
    _particleController.dispose();
    _waveController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _bg,
        builder: (_, __) => Stack(
          children: [
            // ── Background: animated radial green gradient from bottom
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, 1.2),
                    radius: 1.4 * _bg.value + 0.3,
                    colors: const [
                      Color(0xFFDCFCE7),
                      Color(0xFFF0FDF4),
                      Colors.white,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),

            // ── Subtle grid lines (cartoon feel)
            CustomPaint(
              size: size,
              painter: _GridPainter(),
            ),

            // ── Floating decorative blobs
            AnimatedBuilder(
              animation: _floatController,
              builder: (_, __) => Stack(
                children: [
                  Positioned(
                    top: -90 + _float.value * 0.6,
                    right: -60,
                    child: _Blob(
                      size: 260,
                      color: const Color(0xFF22C55E).withOpacity(0.06),
                    ),
                  ),
                  Positioned(
                    bottom: 80 + _float.value * 0.4,
                    left: -80,
                    child: _Blob(
                      size: 210,
                      color: const Color(0xFF16A34A).withOpacity(0.05),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.42,
                    right: -40,
                    child: _Blob(
                      size: 130,
                      color: const Color(0xFFFBBF24).withOpacity(0.06),
                    ),
                  ),
                ],
              ),
            ),

            // ── Sparkle particles
            AnimatedBuilder(
              animation: _particles,
              builder: (_, __) => CustomPaint(
                size: size,
                painter: _SparklePainter(_particles.value),
              ),
            ),

            // ── Spinning ring behind mascot
            AnimatedBuilder(
              animation: _ring,
              builder: (_, __) => Center(
                child: Transform.translate(
                  offset: Offset(0, -size.height * 0.06),
                  child: Transform.rotate(
                    angle: _ring.value * 2 * pi,
                    child: Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF22C55E).withOpacity(0.08),
                          width: 2,
                        ),
                      ),
                      child: CustomPaint(
                        painter: _DashedRingPainter(
                          color: const Color(0xFF22C55E).withOpacity(0.12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Mascot lion
                  AnimatedBuilder(
                    animation: Listenable.merge([
                      _mascotController,
                      _floatController,
                      _waveController,
                    ]),
                    builder: (_, __) {
                      return Opacity(
                        opacity: _mascotOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _mascotY.value + _float.value * 0.4),
                          child: Transform.scale(
                            scale: _mascotScale.value,
                            child: SizedBox(
                              width: 220,
                              height: 220,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Glow
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          const Color(0xFF22C55E)
                                              .withOpacity(0.18),
                                          const Color(0xFF22C55E)
                                              .withOpacity(0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Mascot image
                                  Image.asset(
                                    'assets/images/mascot.png',
                                    width: 195,
                                    height: 195,
                                    fit: BoxFit.contain,
                                  ),
                                  // Waving hand emoji
                                  Positioned(
                                    top: 10,
                                    right: 8,
                                    child: Transform.rotate(
                                      angle: _wave.value,
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        '👋',
                                        style: TextStyle(
                                          fontSize: 30,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Stars
                                  Positioned(
                                    top: 12,
                                    left: 18,
                                    child: _Star(
                                      color: const Color(0xFFFBBF24),
                                      size: 17,
                                      anim: _particles,
                                      phase: 0.0,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 18,
                                    right: 22,
                                    child: _Star(
                                      color: const Color(0xFF22C55E),
                                      size: 13,
                                      anim: _particles,
                                      phase: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // ── Logo + tagline
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (_, __) {
                      return SlideTransition(
                        position: _logoSlide,
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Column(
                              children: [
                                // Main logo image
                                Image.asset(
                                  'assets/images/go212.png',
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 14),
                                // Tagline
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF15803D)
                                        .withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '🇲🇦  All in One 100% Marocaine',
                                    style: GoogleFonts.nunito(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF15803D),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // ── Loading section
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_loadingController, _floatController]),
                    builder: (_, __) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 56),
                        child: Column(
                          children: [
                            // Bouncing dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (i) {
                                final bounce = sin(
                                      (_float.value / 10 * 2 * pi) +
                                          (i * pi / 1.5),
                                    ) *
                                    7;
                                final delay = i * 0.28;
                                final prog = ((_loadingProgress.value - delay)
                                        .clamp(0.0, 0.4) /
                                    0.4);
                                return Transform.translate(
                                  offset: Offset(0, bounce),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF22C55E)
                                          .withOpacity(0.25 + prog * 0.75),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 14),
                            // Progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                height: 5,
                                child: LinearProgressIndicator(
                                  value: _loadingProgress.value,
                                  backgroundColor:
                                      const Color(0xFF22C55E).withOpacity(0.10),
                                  valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFF22C55E)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 52),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  Helper Widgets & Painters
// ─────────────────────────────────────────

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

class _Star extends StatelessWidget {
  final Color color;
  final double size;
  final Animation<double> anim;
  final double phase;
  const _Star(
      {required this.color,
      required this.size,
      required this.anim,
      required this.phase});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        final pulse = sin((anim.value + phase) * 2 * pi) * 0.5 + 0.5;
        return Opacity(
          opacity: 0.35 + pulse * 0.65,
          child: Transform.scale(
            scale: 0.7 + pulse * 0.5,
            child: Icon(Icons.star_rounded, color: color, size: size),
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF22C55E).withOpacity(0.025)
      ..strokeWidth = 1;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _SparklePainter extends CustomPainter {
  final double progress;
  _SparklePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rng = Random(42);
    const colors = [
      Color(0xFF22C55E),
      Color(0xFF4ADE80),
      Color(0xFF86EFAC),
      Color(0xFFFBBF24),
      Color(0xFFFDE68A),
    ];
    for (int i = 0; i < 26; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final phase = rng.nextDouble();
      final pulse = sin((progress + phase) * 2 * pi) * 0.5 + 0.5;
      final radius = 1.5 + rng.nextDouble() * 3.5;
      final color = colors[i % colors.length];
      paint.color = color.withOpacity(0.03 + pulse * 0.11);
      canvas.drawCircle(Offset(x, y), radius * (0.5 + pulse * 0.7), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter old) =>
      old.progress != progress;
}

class _DashedRingPainter extends CustomPainter {
  final Color color;
  _DashedRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const dashCount = 20;
    const dashAngle = 2 * pi / dashCount;
    for (int i = 0; i < dashCount; i++) {
      final start = i * dashAngle;
      final end = start + dashAngle * 0.45;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        end - start,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
