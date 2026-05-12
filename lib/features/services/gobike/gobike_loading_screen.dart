import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class GoBikeLoadingScreen extends StatefulWidget {
  const GoBikeLoadingScreen({super.key});

  @override
  State<GoBikeLoadingScreen> createState() => _GoBikeLoadingScreenState();
}

class _GoBikeLoadingScreenState extends State<GoBikeLoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Pricing lives in GoBikePricingData singleton — no args needed
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context, '/service/gobike/delivery-choice',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F16), // Dark premium green
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lion Mascot in Circle
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
                Image.asset(
                  'assets/images/hero_header.png',
                  width: 140,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 40),
            
            // Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📦', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(
                  'Réservation de votre\npack en cours...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Veuillez patienter quelques instants',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Spinning Loader
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF009933)),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
