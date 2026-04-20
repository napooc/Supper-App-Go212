import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/go212_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideUp = Tween<double>(begin: 40.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
            colors: [Color(0xFF052E16), Color(0xFF065F46), Color(0xFF047857)],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Opacity(
                opacity: _fadeIn.value,
                child: Transform.translate(
                  offset: Offset(0, _slideUp.value),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        // Logo
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10))],
                          ),
                          child: Center(
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF059669), Color(0xFF047857)]).createShader(bounds),
                              child: Column(mainAxisSize: MainAxisSize.min, children: [
                                Text('GO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, height: 1, letterSpacing: -1)),
                                Text('212', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, height: 1, letterSpacing: -1)),
                              ]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text('Bienvenue sur', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7))),
                        const SizedBox(height: 4),
                        Text('GO212', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 2)),
                        const SizedBox(height: 12),
                        Text('La première super app\n100% marocaine', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7), height: 1.5)),
                        const Spacer(flex: 2),
                        // Frosted glass buttons
                        _FrostButton(
                          label: 'Créer un compte',
                          filled: true,
                          onTap: () => Navigator.pushNamed(context, '/signup'),
                        ),
                        const SizedBox(height: 12),
                        _FrostButton(
                          label: 'Se connecter',
                          filled: false,
                          onTap: () => Navigator.pushNamed(context, '/login'),
                        ),
                        const SizedBox(height: 24),
                        Text('En continuant, vous acceptez nos', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5))),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('Conditions d\'utilisation', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8), decoration: TextDecoration.underline, decorationColor: Colors.white.withOpacity(0.5))),
                          Text(' et ', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5))),
                          Text('Politique de confidentialité', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8), decoration: TextDecoration.underline, decorationColor: Colors.white.withOpacity(0.5))),
                        ]),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FrostButton extends StatefulWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _FrostButton({required this.label, required this.filled, required this.onTap});

  @override
  State<_FrostButton> createState() => _FrostButtonState();
}

class _FrostButtonState extends State<_FrostButton> with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
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
      onTapUp: (_) { _anim.reverse(); widget.onTap(); },
      onTapCancel: () => _anim.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: double.infinity, height: 56,
          decoration: BoxDecoration(
            color: widget.filled ? Colors.white : Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: widget.filled ? null : Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(widget.label, style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600,
              color: widget.filled ? Go212Colors.primary700 : Colors.white,
            )),
          ),
        ),
      ),
    );
  }
}
