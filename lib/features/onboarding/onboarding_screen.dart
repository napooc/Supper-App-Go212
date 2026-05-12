import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/go212_colors.dart';

// ─────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────
class _OnboardData {
  final String mascot;
  final String service1;
  final String service2;
  final String title;
  final String subtitle;
  final String emoji;
  final String tag;
  final Color accent;

  const _OnboardData({
    required this.mascot,
    required this.service1,
    required this.service2,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.tag,
    required this.accent,
  });
}

// ─────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _floatCtrl;
  late AnimationController _entryCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _shimmerCtrl;

  late Animation<double> _floatAnim;
  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;
  late Animation<double> _particleAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _shimmerAnim;

  static const _pages = [
    _OnboardData(
      mascot: 'assets/images/mascot.png',
      service1: 'assets/images/goride.png',
      service2: 'assets/images/gowash.png',
      title: 'Bienvenue dans\nGO212 !',
      subtitle:
          'L\'app all in one 100% marocaine.\nTransport, lavage, shopping et plus.',
      emoji: '🇲🇦',
      tag: '⚡ ALL IN ONE',
      accent: Color(0xFF22C55E),
    ),
    _OnboardData(
      mascot: 'assets/images/goride.png',
      service1: 'assets/images/gobike.png',
      service2: 'assets/images/gofix.png',
      title: 'Tous tes services\nau bout des doigts',
      subtitle:
          'GoRide, GoWash, GoFix, GoBike,\nGoShop et bien plus encore.',
      emoji: '🛵',
      tag: '🚀 MOBILITY',
      accent: Color(0xFF16A34A),
    ),
    _OnboardData(
      mascot: 'assets/images/goshop.png',
      service1: 'assets/images/gowash.png',
      service2: 'assets/images/goride.png',
      title: 'Simple, sûr &\nultra rapide',
      subtitle:
          'Paiement CMI sécurisé.\nSupport 7j/7 · Suivi en temps réel.',
      emoji: '🛡️',
      tag: '✅ SÉCURISÉ',
      accent: Color(0xFF15803D),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _floatAnim = Tween<double>(begin: -12.0, end: 12.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    _entryFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );

    _entrySlide =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
    );

    _particleAnim =
        Tween<double>(begin: 0.0, end: 1.0).animate(_particleCtrl);

    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _shimmerAnim =
        Tween<double>(begin: -2.0, end: 2.0).animate(_shimmerCtrl);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _entryCtrl.dispose();
    _particleCtrl.dispose();
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _entryCtrl.reset();
      _pageController
          .nextPage(
            duration: const Duration(milliseconds: 460),
            curve: Curves.easeInOutCubic,
          )
          .then((_) => _entryCtrl.forward());
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  void _onSkip() => Navigator.pushReplacementNamed(context, '/welcome');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 550),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  page.accent.withOpacity(0.05),
                  page.accent.withOpacity(0.09),
                ],
              ),
            ),
          ),

          // ── Subtle grid overlay
          CustomPaint(
            size: size,
            painter: _LightGridPainter(page.accent),
          ),

          // ── Floating blobs
          AnimatedBuilder(
            animation: _floatCtrl,
            builder: (_, __) => Stack(
              children: [
                Positioned(
                  top: -110 + _floatAnim.value * 0.4,
                  left: -70,
                  child: _GlowBlob(
                    size: 300,
                    color: page.accent.withOpacity(0.07),
                  ),
                ),
                Positioned(
                  top: 80,
                  right: -90,
                  child: _GlowBlob(
                    size: 200,
                    color: page.accent.withOpacity(0.05),
                  ),
                ),
                Positioned(
                  bottom: 130 - _floatAnim.value * 0.3,
                  right: -50,
                  child: _GlowBlob(
                    size: 160,
                    color: const Color(0xFFFBBF24).withOpacity(0.06),
                  ),
                ),
              ],
            ),
          ),

          // ── Particles
          AnimatedBuilder(
            animation: _particleAnim,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _ParticlePainter(_particleAnim.value, _currentPage),
            ),
          ),

          // ── Safe area content
          SafeArea(
            child: Column(
              children: [
                // ── Top bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      // Logo pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              page.accent,
                              page.accent.withOpacity(0.75)
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: page.accent.withOpacity(0.32),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          'GO212',
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Skip
                      GestureDetector(
                        onTap: _onSkip,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 9),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Go212Colors.neutral200, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            'Passer',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Go212Colors.neutral500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) =>
                        setState(() => _currentPage = i),
                    itemCount: _pages.length,
                    itemBuilder: (_, i) =>
                        _buildPage(_pages[i], size),
                  ),
                ),

                // ── Bottom navigation
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 14, 28, 32),
                  child: Row(
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _pages.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: page.accent,
                          dotColor: Go212Colors.neutral200,
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 4,
                          spacing: 5,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _onNext,
                        child: AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (_, child) => Transform.scale(
                            scale: _currentPage == _pages.length - 1
                                ? _pulseAnim.value
                                : 1.0,
                            child: child,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 320),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  _currentPage == _pages.length - 1 ? 28 : 22,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  page.accent,
                                  page.accent.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: page.accent.withOpacity(0.42),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_currentPage == _pages.length - 1) ...[
                                  Text(
                                    'Commencer',
                                    style: GoogleFonts.nunito(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                const Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardData page, Size size) {
    return FadeTransition(
      opacity: _entryFade,
      child: SlideTransition(
        position: _entrySlide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 4),

              // ── Hero image cluster
              Expanded(
                flex: 5,
                child: AnimatedBuilder(
                  animation: _floatAnim,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(0, _floatAnim.value * 0.5),
                    child: child,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow ring
                      Container(
                        width: min(size.width * 0.72, 290),
                        height: min(size.width * 0.72, 290),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: page.accent.withOpacity(0.06),
                        ),
                      ),
                      // Inner ring
                      Container(
                        width: min(size.width * 0.56, 225),
                        height: min(size.width * 0.56, 225),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: page.accent.withOpacity(0.07),
                        ),
                      ),

                      // Main mascot / service image
                      Container(
                        width: min(size.width * 0.54, 215),
                        height: min(size.width * 0.54, 215),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: page.accent.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: ClipOval(
                          child: Image.asset(
                            page.mascot,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Floating bubble – bottom left
                      Positioned(
                        bottom: 10,
                        left: 0,
                        child: _FloatingServiceBubble(
                          imagePath: page.service1,
                          floatAnim: _floatAnim,
                          phase: 0.0,
                          accent: page.accent,
                        ),
                      ),

                      // Floating bubble – top right
                      Positioned(
                        top: 22,
                        right: 0,
                        child: _FloatingServiceBubble(
                          imagePath: page.service2,
                          floatAnim: _floatAnim,
                          phase: pi,
                          accent: page.accent,
                        ),
                      ),

                      // Tag badge
                      Positioned(
                        top: 10,
                        left: 10,
                        child: _TagChip(
                          text: page.tag,
                          color: page.accent,
                        ),
                      ),

                      // Emoji badge
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: _EmojiBadge(page.emoji, page.accent),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Text content
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      page.subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        color: Go212Colors.neutral500,
                        height: 1.65,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  Supporting Widgets
// ─────────────────────────────────────────

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowBlob({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

class _FloatingServiceBubble extends StatelessWidget {
  final String imagePath;
  final Animation<double> floatAnim;
  final double phase;
  final Color accent;

  const _FloatingServiceBubble({
    required this.imagePath,
    required this.floatAnim,
    required this.phase,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatAnim,
      builder: (_, child) {
        final offset = sin(floatAnim.value / 12 + phase) * 8.0;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: Container(
        width: 74,
        height: 74,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: accent.withOpacity(0.14), width: 2),
          boxShadow: [
            BoxShadow(
                color: accent.withOpacity(0.16),
                blurRadius: 22,
                offset: const Offset(0, 8)),
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  final Color color;
  const _TagChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _EmojiBadge extends StatelessWidget {
  final String emoji;
  final Color color;
  const _EmojiBadge(this.emoji, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
    );
  }
}

// ── Particle painter
class _ParticlePainter extends CustomPainter {
  final double progress;
  final int seed;
  _ParticlePainter(this.progress, this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rng = Random(seed * 19 + 7);
    const colors = [Color(0xFF22C55E), Color(0xFF4ADE80), Color(0xFFFBBF24)];
    for (int i = 0; i < 16; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final phase = rng.nextDouble();
      final pulse = sin((progress + phase) * 2 * pi) * 0.5 + 0.5;
      final r = 2.0 + rng.nextDouble() * 3.5;
      paint.color = colors[i % colors.length].withOpacity(0.04 + pulse * 0.09);
      canvas.drawCircle(Offset(x, y), r * (0.6 + pulse * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.progress != progress || old.seed != seed;
}

// ── Light grid painter
class _LightGridPainter extends CustomPainter {
  final Color accent;
  _LightGridPainter(this.accent);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accent.withOpacity(0.025)
      ..strokeWidth = 1;
    const step = 44.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LightGridPainter old) =>
      old.accent != accent;
}
