import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeGroupReservationScreen extends StatefulWidget {
  const GoBikeGroupReservationScreen({super.key});

  @override
  State<GoBikeGroupReservationScreen> createState() => _GoBikeGroupReservationScreenState();
}

class _GoBikeGroupReservationScreenState extends State<GoBikeGroupReservationScreen> {
  int _bikeCount = 2;
  final int _maxBikes = 6;
  final Color primaryGreen = const Color(0xFF009933);

  @override
  Widget build(BuildContext context) {
    // Get full screen size
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black, // Set to black to avoid white flashes
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // ─── HERO BACKGROUND (FULL SCREEN) ───
            Positioned.fill(
              child: Image.asset(
                'assets/images/groupe.png',
                width: size.width,
                height: size.height,
                fit: BoxFit.cover, // Ensures it covers the entire screen area
              ),
            ),
            
            // ─── FULL SCREEN OVERLAY ───
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryGreen.withOpacity(0.8),
                      primaryGreen.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black.withOpacity(0.2), // Slight shadow at the bottom
                    ],
                    stops: const [0.0, 0.25, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            // ─── CONTENT (SCROLLABLE) ───
            Positioned.fill(
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 30), // Extra space at bottom
                  child: Column(
                    children: [
                      // ─── HEADER ───
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/lion.jpeg',
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'GoBike',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Réservation groupe',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Nombre de vélos à réserver',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Progress Bar
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: List.generate(6, (index) {
                                      return Expanded(
                                        child: Container(
                                          height: 4,
                                          margin: EdgeInsets.only(right: index == 5 ? 0 : 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(index <= 1 ? 1.0 : 0.3),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Text(
                                    '2 / 6',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 70), // Visual space for hero image

                      // ─── FLOATING CARD ───
                      AnimationConfiguration.staggeredList(
                        position: 0,
                        child: FadeInAnimation(
                          child: SlideAnimation(
                            verticalOffset: 40,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.96),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 25,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: primaryGreen,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.group, color: Colors.white, size: 18),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Combien de vélos ?',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(0xFF1E293B),
                                                  ),
                                                ),
                                                Text(
                                                  '1 vélo = 1 personne',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: const Color(0xFF64748B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      // Counter
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildCompactCounterButton(
                                            icon: Icons.remove,
                                            onPressed: () {
                                              if (_bikeCount > 1) setState(() => _bikeCount--);
                                            },
                                          ),
                                          Text(
                                            '$_bikeCount',
                                            style: GoogleFonts.poppins(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                              color: primaryGreen,
                                            ),
                                          ),
                                          _buildCompactCounterButton(
                                            icon: Icons.add,
                                            onPressed: () {
                                              if (_bikeCount < _maxBikes) setState(() => _bikeCount++);
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Bike Icons Row
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(_maxBikes, (index) {
                                          bool isActive = index < _bikeCount;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                            child: Icon(
                                              Icons.pedal_bike,
                                              size: 22,
                                              color: isActive ? primaryGreen : Colors.grey.withOpacity(0.25),
                                            ),
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 16),
                                      // Status Capsule
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: primaryGreen.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.check_circle, color: primaryGreen, size: 14),
                                            const SizedBox(width: 5),
                                            Text(
                                              '$_bikeCount vélos sélectionnés',
                                              style: GoogleFonts.poppins(
                                                color: primaryGreen,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Continue Button
                                      SizedBox(
                                        width: double.infinity,
                                        height: 52,
                                        child: ElevatedButton(
                                          onPressed: () {
                                      Navigator.pushNamed(context, '/service/gobike/customize');
                                    },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryGreen,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(26),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Spacer(flex: 2),
                                              Text(
                                                'Continuer',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Spacer(flex: 1),
                                              Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.arrow_forward, color: primaryGreen, size: 16),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCounterButton({required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF475569), size: 22),
      ),
    );
  }
}
