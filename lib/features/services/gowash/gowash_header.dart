import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/theme/go212_colors.dart';

class GoWashHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? stepText;
  final VoidCallback? onBack;

  const GoWashHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.stepText,
    this.onBack,
  });

  // Official Branding Colors from theme
  static const _primaryGreen = Go212Colors.primary500;
  static const _darkGreen = Go212Colors.primary900;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = topPadding + 165.0;

    return Stack(
      children: [
        // 1. MAIN BACKGROUND WITH PREMIUM GRADIENT & ORGANIC CLIPPER
        ClipPath(
          clipper: PremiumHeaderClipper(),
          child: Container(
            width: double.infinity,
            height: headerHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_darkGreen, _primaryGreen],
              ),
            ),
            child: Stack(
              children: [
                // Layered translucent shapes for depth
                Positioned(
                  top: -60,
                  right: -40,
                  child: _buildGlassCircle(200),
                ),
                Positioned(
                  bottom: 30,
                  left: -50,
                  child: _buildGlassCircle(160),
                ),
                
                // Subtle Pattern
                CustomPaint(
                  size: Size(double.infinity, headerHeight),
                  painter: HeaderPatternPainter(),
                ),
              ],
            ),
          ),
        ),

        // 2. HEADER CONTENT
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Back Button & GoWash Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Glassmorphic Back Button
                    if (onBack != null)
                      _buildTranslucentButton(
                        onTap: onBack!,
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      )
                    else
                      const SizedBox(width: 44),

                    // Official GoWash Logo (Properly Integrated)
                    Hero(
                      tag: 'gowash_logo',
                      child: Container(
                        width: 72,
                        height: 72,
                        padding: const EdgeInsets.all(2), // Subtle border spacing
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _primaryGreen, // Blends with the asset background
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo_go_wash.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.local_car_wash_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Title & Subtitle
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.6,
                              fontFamily: 'Inter',
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (stepText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          stepText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslucentButton({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class PremiumHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 45);
    
    var firstControlPoint = Offset(size.width * 0.35, size.height);
    var firstEndPoint = Offset(size.width * 0.65, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 0.85, size.height - 55);
    var secondEndPoint = Offset(size.width, size.height - 15);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path1 = Path()
      ..moveTo(-30, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width + 30, size.height * 0.6);
    
    final path2 = Path()
      ..moveTo(-30, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.5, size.width + 30, size.height * 0.9);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
