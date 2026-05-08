import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeDurationScreen extends StatefulWidget {
  const GoBikeDurationScreen({super.key});

  @override
  State<GoBikeDurationScreen> createState() => _GoBikeDurationScreenState();
}

class _GoBikeDurationScreenState extends State<GoBikeDurationScreen> {
  int? _selectedDurationIndex;
  final Color primaryGreen = const Color(0xFF009933);
  final Color bgColor = const Color(0xFFF5F7F8);
  final Color selectedCardColor = const Color(0xFFF3FBF4);
  final Color greenBorderColor = const Color(0xFF1DB954);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ─── HEADER ───
          Container(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: primaryGreen,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GoBike',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Réservation',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/lion.jpeg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Quelle durée ?',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choisissez votre formule de location',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: List.generate(6, (index) {
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(right: index == 5 ? 0 : 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(index <= 1 ? 1.0 : 0.2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '2 / 6',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ─── GRID ───
          Expanded(
            child: AnimationLimiter(
              child: GridView.count(
                padding: const EdgeInsets.all(20),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.82,
                children: [
                  _buildDurationCard(
                    index: 0,
                    title: 'Heures',
                    price: '30 DH/h',
                    description: 'Parfait pour les petits trajets',
                    imagePath: 'assets/images/heure.jpeg',
                  ),
                  _buildDurationCard(
                    index: 1,
                    title: 'Jours',
                    price: '150 DH/j',
                    description: 'Explorez Casablanca librement',
                    imagePath: 'assets/images/jours.jpeg',
                  ),
                  _buildDurationCard(
                    index: 2,
                    title: 'Semaines',
                    price: '700 DH/s',
                    description: 'Le meilleur choix économique',
                    imagePath: 'assets/images/semaines.jpeg',
                  ),
                  _buildDurationCard(
                    index: 3,
                    title: 'Mois',
                    price: '2500 DH/m',
                    description: 'Expérience GoBike illimitée',
                    imagePath: 'assets/images/mois.jpeg',
                  ),
                ],
              ),
            ),
          ),

          // ─── BUTTON ───
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedDurationIndex != null
                    ? () {
                        final rentalType = ModalRoute.of(context)?.settings.arguments as int?;
                        if (rentalType == 1) {
                          // It's a group reservation
                          Navigator.pushNamed(context, '/service/gobike/group-reservation');
                        } else {
                          // It's a solo reservation, go to customize
                          Navigator.pushNamed(context, '/service/gobike/customize');
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE2E8F0),
                  elevation: 2,
                  shadowColor: primaryGreen.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(flex: 1),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationCard({
    required int index,
    required String title,
    required String price,
    required String description,
    required String imagePath,
  }) {
    bool isSelected = _selectedDurationIndex == index;

    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 500),
      columnCount: 2,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: () => setState(() => _selectedDurationIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? selectedCardColor : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? greenBorderColor : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Clock Icon (Top Left)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF166534).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.access_time, size: 14, color: primaryGreen),
                    ),
                  ),
                  // Radio/Check (Top Right)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? greenBorderColor : Colors.white,
                        border: Border.all(
                          color: isSelected ? greenBorderColor : const Color(0xFFE2E8F0),
                          width: isSelected ? 0 : 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                  ),
                  // Content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        price,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
