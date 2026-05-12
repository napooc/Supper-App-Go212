import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gobike_header.dart';

class GoBikePacksScreen extends StatefulWidget {
  const GoBikePacksScreen({super.key});

  @override
  State<GoBikePacksScreen> createState() => _GoBikePacksScreenState();
}

class _GoBikePacksScreenState extends State<GoBikePacksScreen> {
  int? _selectedPackIndex = 0; // First pack selected by default
  final Color primaryGreen = const Color(0xFF009933);
  final Color bgColor = const Color(0xFFF6F7F8);
  final Color greenBorderColor = const Color(0xFF1DB954);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          GoBikeHeader(
            title: 'Nos Packs Premium',
            subtitle: 'GoBike',
            stepText: '3 / 6',
            onBack: () => Navigator.pop(context),
          ),

          // ─── PACKS LIST ───
          Expanded(
            child: AnimationLimiter(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildLargePackCard(
                    index: 0,
                    imagePath: 'assets/images/tour1.png',
                  ),
                  const SizedBox(height: 16),
                  _buildLargePackCard(
                    index: 1,
                    imagePath: 'assets/images/tour2.png',
                  ),
                  const SizedBox(height: 16),
                  _buildLargePackCard(
                    index: 2,
                    imagePath: 'assets/images/tour3.png',
                  ),
                ],
              ),
            ),
          ),

          GoBikeCTA(
            label: 'Continuer',
            enabled: _selectedPackIndex != null,
            onPressed: () => Navigator.pushNamed(context, '/service/gobike/customize'),
          ),
        ],
      ),
    );
  }

  Widget _buildLargePackCard({
    required int index,
    required String imagePath,
  }) {
    bool isSelected = _selectedPackIndex == index;

    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: () => setState(() => _selectedPackIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isSelected ? greenBorderColor : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Original Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Selection Marker (Top Right)
                  if (isSelected)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: greenBorderColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 20),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
