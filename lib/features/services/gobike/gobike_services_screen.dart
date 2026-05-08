import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GoBikeServicesScreen extends StatefulWidget {
  const GoBikeServicesScreen({super.key});

  @override
  State<GoBikeServicesScreen> createState() => _GoBikeServicesScreenState();
}

class _GoBikeServicesScreenState extends State<GoBikeServicesScreen> {
  int? _selectedServiceIndex;
  final Color primaryGreen = const Color(0xFF008333);
  final Color purpleBg = const Color(0xFFF3E8FF);
  final Color purpleText = const Color(0xFF9333EA);
  final Color greenBadgeBg = const Color(0xFFE8F5E9);
  final Color greenBadgeText = const Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // ─── HEADER ───
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 24),
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Titles
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'GoBike',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'Réservation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Mascot
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/lion.jpeg',
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Nos services',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choisissez votre service de location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
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
                                color: Colors.white.withOpacity(index == 0 ? 0.3 : 0.15),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '0 / 6',
                        style: TextStyle(
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

          // ─── SERVICES LIST ───
          Expanded(
            child: AnimationLimiter(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                children: [
                  AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _ServiceCard(
                          title: 'Location Normale',
                          description: 'Réservez un vélo · Explorez\nCasablanca en toute liberté',
                          secondaryText: 'Plusieurs formules disponibles\n(heures, jours, semaines, mois)',
                          badgeText: 'DISPONIBLE',
                          badgeBgColor: greenBadgeBg,
                          badgeTextColor: greenBadgeText,
                          secondaryTextColor: greenBadgeText,
                          imagePath: 'assets/images/normal.png',
                          isSelected: _selectedServiceIndex == 0,
                          onTap: () => setState(() => _selectedServiceIndex = 0),
                          primaryGreen: primaryGreen,
                          icon: Icons.info_outline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _ServiceCard(
                          title: 'Bike Mapping',
                          description: 'Trouvez les vélos et stations\nautour de vous en temps réel',
                          secondaryText: 'Carte interactive avec\ndisponibilité en direct',
                          badgeText: 'BIENTÔT',
                          badgeBgColor: purpleBg,
                          badgeTextColor: purpleText,
                          secondaryTextColor: purpleText,
                          imagePath: 'assets/images/bikemaping.png',
                          isSelected: _selectedServiceIndex == 1,
                          onTap: () => setState(() => _selectedServiceIndex = 1),
                          primaryGreen: primaryGreen,
                          icon: Icons.info_outline,
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
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _selectedServiceIndex != null
                    ? () {
                        if (_selectedServiceIndex == 0) {
                          Navigator.pushNamed(context, '/service/gobike/rental-form');
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE0E0E0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Continuer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _selectedServiceIndex != null ? Colors.white : Colors.white,
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

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String secondaryText;
  final String badgeText;
  final Color badgeBgColor;
  final Color badgeTextColor;
  final Color secondaryTextColor;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  final Color primaryGreen;
  final IconData icon;

  const _ServiceCard({
    required this.title,
    required this.description,
    required this.secondaryText,
    required this.badgeText,
    required this.badgeBgColor,
    required this.badgeTextColor,
    required this.secondaryTextColor,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    required this.primaryGreen,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              color: badgeTextColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 16, color: secondaryTextColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          secondaryText,
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Radio
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryGreen : const Color(0xFFE2E8F0),
                  width: isSelected ? 8 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
