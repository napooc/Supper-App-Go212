import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/go212_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _mascotController;
  late AnimationController _floatController;
  late AnimationController _particleController;

  late Animation<double> _entryFade;
  late Animation<double> _entrySlide;
  late Animation<double> _mascotScale;
  late Animation<double> _mascotOpacity;
  late Animation<double> _floatAnim;
  late Animation<double> _particleAnim;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _entryFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _entrySlide = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );

    _mascotScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.elasticOut),
    );
    _mascotOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mascotController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _floatAnim = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _particleAnim =
        Tween<double>(begin: 0.0, end: 1.0).animate(_particleController);

    Future.delayed(const Duration(milliseconds: 300),
        () => _mascotController.forward());
  }

  @override
  void dispose() {
    _entryController.dispose();
    _mascotController.dispose();
    _floatController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // ── Lush green gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.3, -1.0),
                end: Alignment(0.3, 1.0),
                colors: [
                  Color(0xFF052E16),
                  Color(0xFF14532D),
                  Color(0xFF15803D),
                  Color(0xFF16A34A),
                ],
                stops: [0.0, 0.3, 0.65, 1.0],
              ),
            ),
          ),

          // ── Decorative circles
          AnimatedBuilder(
            animation: _floatController,
            builder: (_, __) => Stack(
              children: [
                Positioned(
                  top: -80 + _floatAnim.value * 0.5,
                  right: -50,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.04),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 200 - _floatAnim.value * 0.4,
                  left: -80,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.03),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.3,
                  right: -30,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4ADE80).withOpacity(0.06),
                    ),
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
              painter: _WelcomeParticlePainter(_particleAnim.value),
            ),
          ),

          // ── Content
          SafeArea(
            child: AnimatedBuilder(
              animation: _entryController,
              builder: (_, child) => Opacity(
                opacity: _entryFade.value,
                child: Transform.translate(
                  offset: Offset(0, _entrySlide.value),
                  child: child,
                ),
              ),
              child: Column(
                children: [
                  const Spacer(flex: 1),

                  // ── Lion mascot (waving hi)
                  AnimatedBuilder(
                    animation: Listenable.merge(
                        [_mascotController, _floatController]),
                    builder: (_, __) {
                      return Opacity(
                        opacity: _mascotOpacity.value,
                        child: Transform.scale(
                          scale: _mascotScale.value,
                          child: Transform.translate(
                            offset: Offset(0, _floatAnim.value),
                            child: SizedBox(
                              width: 180,
                              height: 180,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 170,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.08),
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/mascot.png',
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // ── Hi speech bubble
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('👋', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          'Salut ! Je suis ton compagnon GO212',
                          style: GoogleFonts.nunito(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Title
                  Text(
                    'Bienvenue sur',
                    style: GoogleFonts.nunito(
                      fontSize: 17,
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'GO212',
                    style: GoogleFonts.nunito(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 3,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'La première all in one app\n100% marocaine 🇲🇦',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.65),
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ── CTA Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        _WelcomeButton(
                          label: 'Créer un compte',
                          filled: true,
                          onTap: () =>
                              Navigator.pushNamed(context, '/signup'),
                        ),
                        const SizedBox(height: 14),
                        _WelcomeButton(
                          label: 'Se connecter',
                          filled: false,
                          onTap: () =>
                              Navigator.pushNamed(context, '/login'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Legal text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        Text(
                          'En continuant, vous acceptez nos',
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.45),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Text(
                                'Conditions d\'utilisation',
                                style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.75),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ),
                            Text(
                              ' et ',
                              style: GoogleFonts.nunito(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.45),
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                'Politique de confidentialité',
                                style: GoogleFonts.nunito(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.75),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Welcome Button
class _WelcomeButton extends StatefulWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _WelcomeButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  State<_WelcomeButton> createState() => _WelcomeButtonState();
}

class _WelcomeButtonState extends State<_WelcomeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _anim.forward(),
      onTapUp: (_) {
        _anim.reverse();
        widget.onTap();
      },
      onTapCancel: () => _anim.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
            color: widget.filled ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: widget.filled
                ? null
                : Border.all(color: Colors.white.withOpacity(0.35), width: 2),
            boxShadow: widget.filled
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.label,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: widget.filled
                    ? Go212Colors.primary700
                    : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Particle painter
class _WelcomeParticlePainter extends CustomPainter {
  final double progress;
  _WelcomeParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rng = Random(55);
    for (int i = 0; i < 20; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final phase = rng.nextDouble();
      final pulse = sin((progress + phase) * 2 * pi) * 0.5 + 0.5;
      final r = 1.5 + rng.nextDouble() * 2.5;
      paint.color = Colors.white.withOpacity(0.02 + pulse * 0.07);
      canvas.drawCircle(Offset(x, y), r * (0.5 + pulse * 0.6), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WelcomeParticlePainter old) =>
      old.progress != progress;
}
