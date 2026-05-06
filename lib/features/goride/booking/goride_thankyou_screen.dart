// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
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
  late Animation<Offset> _slideAnim;
  Timer? _redirectTimer;
  final String _viewId = 'bye-video-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();

    // Fade in
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    // Slide up for text
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _slideCtrl.forward();
    });

    // Register HTML video element
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final video = html.VideoElement()
        ..src = 'assets/assets/video/bye.mp4'
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.borderRadius = '24px'
        ..setAttribute('playsinline', 'true');
      video.play();
      return video;
    });

    // Auto-redirect after 10 seconds
    _redirectTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/main', (r) => false);
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
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
            colors: [
              Color(0xFF052E16),
              Color(0xFF14532D),
              Color(0xFF166534),
              Color(0xFF15803D),
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              // ── GO212 Badge ──
              FadeTransition(
                opacity: _fadeCtrl,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: const Text(
                    '🦁  GO212 GoRide',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              // ── Video Frame ──
              FadeTransition(
                opacity: _fadeCtrl,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 15),
                      ),
                      BoxShadow(
                        color: const Color(0xFF4ADE80).withOpacity(0.15),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: HtmlElementView(viewType: _viewId),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              // ── Thank you text ──
              SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeCtrl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const Text(
                          'Merci & À bientôt ! 👋',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Votre expérience GO212 GoRide est terminée.\n'
                          'On se retrouve pour votre prochaine aventure ! 🚀',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.65),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // ── Divider ──
                        Container(
                          width: 50,
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4ADE80),
                                Color(0xFF86EFAC)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // ── Return home button ──
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/main', (r) => false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.home_rounded,
                                    color: Go212Colors.primary700, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'Retour à l\'accueil',
                                  style: TextStyle(
                                    color: Go212Colors.primary700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // ── Auto-redirect label ──
              FadeTransition(
                opacity: _fadeCtrl,
                child: Text(
                  'Redirection automatique dans quelques secondes…',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
