import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class GoBikeTrackingConnectionScreen extends StatefulWidget {
  const GoBikeTrackingConnectionScreen({super.key});

  @override
  State<GoBikeTrackingConnectionScreen> createState() => _GoBikeTrackingConnectionScreenState();
}

class _GoBikeTrackingConnectionScreenState extends State<GoBikeTrackingConnectionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;
  
  final Color primaryGreen = const Color(0xFF009933);
  final Color darkGreen = const Color(0xFF065F46);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    
    // Auto-navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/service/gobike/live-tracking');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF062016), // Very dark premium green
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.2,
            colors: [
              primaryGreen.withOpacity(0.15),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            
            // Pulsing Connection Icon
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer rings
                    Container(
                      width: 140 * _pulse.value,
                      height: 140 * _pulse.value,
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryGreen.withOpacity(0.1), width: 1),
                      ),
                    ),
                    Container(
                      width: 110 * _pulse.value,
                      height: 110 * _pulse.value,
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryGreen.withOpacity(0.2), width: 1),
                      ),
                    ),
                    // Core Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: primaryGreen.withOpacity(0.5), blurRadius: 30, spreadRadius: 5),
                        ],
                      ),
                      child: const Icon(Icons.wifi_tethering, color: Colors.white, size: 36),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 60),

            Text(
              'Connexion au réseau\ndu driver...',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Veuillez patienter pendant que nous\nnous connectons au réseau du driver.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                height: 1.5,
              ),
            ),

            const Spacer(flex: 2),

            // Premium Loading Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == 3 ? Colors.white : Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
