import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeRentalFormScreen extends StatefulWidget {
  const GoBikeRentalFormScreen({super.key});

  @override
  State<GoBikeRentalFormScreen> createState() => _GoBikeRentalFormScreenState();
}

class _GoBikeRentalFormScreenState extends State<GoBikeRentalFormScreen> {
  int? _selectedFormIndex = 0; // Solo selected by default
  final Color primaryGreen = const Color(0xFF009933);
  final Color bgColor = const Color(0xFFF6F7F8);
  final Color selectedCardColor = const Color(0xFFF3FBF4);
  final Color greenBorderColor = const Color(0xFF1DB954);
  final Color textGrey = const Color(0xFF64748B);
  final Color titleBlack = const Color(0xFF1E293B);

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
                    // Back Button
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
                    // Titles
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Avatar
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
                  'Qui monte ?',
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
                                color: Colors.white.withOpacity(index == 0 ? 1.0 : 0.2),
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
                        '1 / 6',
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

          // ─── OPTIONS LIST ───
          Expanded(
            child: AnimationLimiter(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                children: [
                  AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 30.0,
                      child: FadeInAnimation(
                        child: _RentalFormCard(
                          title: 'Solo',
                          badgeText: 'POPULAIRE',
                          badgeColor: const Color(0xFFDCFCE7),
                          badgeTextColor: const Color(0xFF166534),
                          description: '1 vélo · Votre balade en toute liberté',
                          infoText: 'Idéal pour explorer la ville seul',
                          imagePath: 'assets/images/solo.png',
                          isSelected: _selectedFormIndex == 0,
                          onTap: () => setState(() => _selectedFormIndex = 0),
                          selectedCardColor: selectedCardColor,
                          greenBorderColor: greenBorderColor,
                          textGrey: textGrey,
                          titleBlack: titleBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 30.0,
                      child: FadeInAnimation(
                        child: _RentalFormCard(
                          title: 'Groupe',
                          badgeText: 'MULTI',
                          badgeColor: const Color(0xFFDBEAFE),
                          badgeTextColor: const Color(0xFF1E40AF),
                          description: 'Plusieurs vélos · Pour vous et vos proches',
                          infoText: 'Jusqu\'à 5 vélos disponibles simultanément',
                          imagePath: 'assets/images/groupe.png',
                          isSelected: _selectedFormIndex == 1,
                          onTap: () => setState(() => _selectedFormIndex = 1),
                          selectedCardColor: selectedCardColor,
                          greenBorderColor: greenBorderColor,
                          textGrey: textGrey,
                          titleBlack: titleBlack,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimationConfiguration.staggeredList(
                    position: 2,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 30.0,
                      child: FadeInAnimation(
                        child: _RentalFormCard(
                          title: 'Nos Packs',
                          badgeText: 'PREMIUM',
                          badgeColor: const Color(0xFFFEF3C7),
                          badgeTextColor: const Color(0xFF92400E),
                          description: 'Packs exclusifs · Expérience GoBike ultime',
                          infoText: 'Accès e-Bikes illimité et avantages VIP',
                          imagePath: 'assets/images/nos_pack.png',
                          isSelected: _selectedFormIndex == 2,
                          onTap: () => setState(() => _selectedFormIndex = 2),
                          selectedCardColor: selectedCardColor,
                          greenBorderColor: greenBorderColor,
                          textGrey: textGrey,
                          titleBlack: titleBlack,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── BUTTON ───
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selectedFormIndex != null
                    ? () {
                        if (_selectedFormIndex == 2) {
                          Navigator.pushNamed(context, '/service/gobike/packs');
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/service/gobike/duration',
                            arguments: _selectedFormIndex,
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE2E8F0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: Text(
                  'Continuer',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RentalFormCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String description;
  final String infoText;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedCardColor;
  final Color greenBorderColor;
  final Color textGrey;
  final Color titleBlack;

  const _RentalFormCard({
    required this.title,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.description,
    required this.infoText,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    required this.selectedCardColor,
    required this.greenBorderColor,
    required this.textGrey,
    required this.titleBlack,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
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
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[100],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: titleBlack,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badgeText,
                          style: GoogleFonts.poppins(
                            color: badgeTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: textGrey,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 15, color: greenBorderColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          infoText,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: greenBorderColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Radio / Check
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? greenBorderColor : Colors.white,
                border: Border.all(
                  color: isSelected ? greenBorderColor : const Color(0xFFE2E8F0),
                  width: isSelected ? 0 : 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
