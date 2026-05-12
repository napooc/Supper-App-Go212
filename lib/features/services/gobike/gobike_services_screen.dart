import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gobike_header.dart';

class GoBikeServicesScreen extends StatefulWidget {
  const GoBikeServicesScreen({super.key});

  @override
  State<GoBikeServicesScreen> createState() => _GoBikeServicesScreenState();
}

class _GoBikeServicesScreenState extends State<GoBikeServicesScreen> {
  int? _selectedServiceIndex;
  final Color primaryGreen = const Color(0xFF008333);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          GoBikeHeader(
            title: 'Nos services',
            subtitle: 'GoBike',
            stepText: '0 / 6',
            onBack: () => Navigator.pop(context),
          ),

          // ── Subtitle ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
            child: Text(
              'Que souhaitez-vous faire aujourd\'hui ?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
              ),
            ),
          ),

          // ── 2 Cards filling ALL available space ──────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
              child: Column(
                children: [
                  Expanded(
                    child: _buildServiceCard(
                      title: 'Location Normale',
                      description: 'Réservez un vélo\nExplorez Casablanca en toute liberté',
                      secondaryText: 'Heures · Jours · Semaines · Mois',
                      badgeText: 'DISPONIBLE',
                      imagePath: 'assets/images/normal.png',
                      isSelected: _selectedServiceIndex == 0,
                      onTap: () => setState(() => _selectedServiceIndex = 0),
                      accent: primaryGreen,
                      icon: Icons.pedal_bike_rounded,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _buildServiceCard(
                      title: 'Bike Mapping',
                      description: 'Trouvez les vélos et stations\nautour de vous en temps réel',
                      secondaryText: 'Carte interactive · Disponibilité live',
                      badgeText: '🔴 LIVE',
                      imagePath: 'assets/images/bikemaping.png',
                      isSelected: _selectedServiceIndex == 1,
                      onTap: () => setState(() => _selectedServiceIndex = 1),
                      accent: const Color(0xFF2563EB),
                      icon: Icons.map_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),

          GoBikeCTA(
            label: 'Continuer',
            enabled: _selectedServiceIndex != null,
            onPressed: () {
              if (_selectedServiceIndex == 0) {
                Navigator.pushNamed(context, '/service/gobike/rental-form');
              } else {
                Navigator.pushNamed(context, '/service/gobike/bike-map');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String description,
    required String secondaryText,
    required String badgeText,
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
    required Color accent,
    required IconData icon,
  }) {
    // Darker version for richer gradient
    final accentDark = Color.lerp(accent, Colors.black, 0.3)!;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? accent.withOpacity(0.40)
                  : Colors.black.withOpacity(0.10),
              blurRadius: isSelected ? 24 : 12,
              spreadRadius: isSelected ? 1 : 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [

              // ── 1. FULL-BLEED IMAGE ─────────────────────────────────────
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: accent.withOpacity(0.15),
                  child: Icon(icon, size: 64, color: accent.withOpacity(0.4)),
                ),
              ),

              // ── 2. CINEMATIC GRADIENT (left solid → right transparent) ──
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.42, 0.72, 1.0],
                    colors: [
                      accentDark.withOpacity(0.97),
                      accent.withOpacity(0.88),
                      accent.withOpacity(0.45),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // ── 3. CONTENT (white text on gradient) ────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.30),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        badgeText,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color: Color(0x55000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Description
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.78),
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Info pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon,
                              size: 12, color: Colors.white.withOpacity(0.9)),
                          const SizedBox(width: 5),
                          Text(
                            secondaryText,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.90),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── 4. SELECTION INNER BORDER (frosted white glow) ──────────
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withOpacity(0.70)
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
              ),

              // ── 5. RADIO CHECK (top-right, always white) ────────────────
              Positioned(
                top: 12,
                right: 14,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.20),
                    border: Border.all(
                      color: Colors.white.withOpacity(isSelected ? 1.0 : 0.50),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check_rounded,
                          color: accent, size: 15)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

