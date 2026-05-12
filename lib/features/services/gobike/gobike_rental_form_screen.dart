import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gobike_header.dart';

class GoBikeRentalFormScreen extends StatefulWidget {
  const GoBikeRentalFormScreen({super.key});

  @override
  State<GoBikeRentalFormScreen> createState() => _GoBikeRentalFormScreenState();
}

class _GoBikeRentalFormScreenState extends State<GoBikeRentalFormScreen> {
  int _selectedFormIndex = 0; // Solo by default

  static const _green = Color(0xFF009933);
  static const _greenDark = Color(0xFF065F46);
  static const _bg = Color(0xFFF6F7F8);

  final _options = const [
    _RentalOption(
      index: 0,
      title: 'Solo',
      subtitle: '1 vélo · Votre balade en toute liberté',
      infoText: 'Idéal pour explorer la ville seul(e)',
      emoji: '🚲',
      imagePath: 'assets/images/solo.png',
      badgeText: 'POPULAIRE',
      badgeColor: Color(0xFFDCFCE7),
      badgeTextColor: Color(0xFF166534),
      accent: Color(0xFF009933),
      accentLight: Color(0xFFF0FDF4),
    ),
    _RentalOption(
      index: 1,
      title: 'Groupe',
      subtitle: 'Plusieurs vélos · Pour vous et vos proches',
      infoText: 'Jusqu\'à 10 vélos disponibles',
      emoji: '👥',
      imagePath: 'assets/images/groupe.png',
      badgeText: 'MULTI',
      badgeColor: Color(0xFFDBEAFE),
      badgeTextColor: Color(0xFF1E40AF),
      accent: Color(0xFF2563EB),
      accentLight: Color(0xFFEFF6FF),
    ),
    _RentalOption(
      index: 2,
      title: 'Nos Packs',
      subtitle: 'Packs exclusifs · Expérience GoBike ultime',
      infoText: 'Accès e-Bikes & avantages VIP inclus',
      emoji: '🏆',
      imagePath: 'assets/images/nos_pack.png',
      badgeText: 'PREMIUM',
      badgeColor: Color(0xFFFEF3C7),
      badgeTextColor: Color(0xFF92400E),
      accent: Color(0xFFD97706),
      accentLight: Color(0xFFFFFBEB),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          GoBikeHeader(
            title: 'Qui monte ?',
            subtitle: 'GoBike',
            stepText: '1 / 6',
            onBack: () => Navigator.pop(context),
          ),

          // ── Subtitle ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
            child: Text(
              'Choisissez votre mode de location',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF94A3B8),
              ),
            ),
          ),

          // ── 3 Cards filling ALL available space ─────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
              child: Column(
                children: List.generate(_options.length, (i) {
                  final isLast = i == _options.length - 1;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
                      child: _buildOptionCard(_options[i]),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── CTA ─────────────────────────────────────────────────────────
          GoBikeCTA(
            label: 'Continuer',
            enabled: true,
            onPressed: () {
              if (_selectedFormIndex == 2) {
                Navigator.pushNamed(context, '/service/gobike/packs');
              } else if (_selectedFormIndex == 1) {
                Navigator.pushNamed(context, '/service/gobike/duration',
                    arguments: {'isGroupe': true});
              } else {
                Navigator.pushNamed(context, '/service/gobike/duration',
                    arguments: {'isGroupe': false});
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(_RentalOption opt) {
    final isSelected = _selectedFormIndex == opt.index;
    final accentDark = Color.lerp(opt.accent, Colors.black, 0.35)!;

    // Each card has a slightly different gradient angle for variety
    final gradientBegin = [
      Alignment.centerLeft,
      Alignment.bottomLeft,
      Alignment.topLeft,
    ][opt.index];
    final gradientEnd = [
      Alignment.centerRight,
      Alignment.topRight,
      Alignment.bottomRight,
    ][opt.index];

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedFormIndex = opt.index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? opt.accent.withOpacity(0.40)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isSelected ? 24 : 10,
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

              // ── 1. FULL-BLEED IMAGE ──────────────────────────────────────
              Image.asset(
                opt.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: opt.accent.withOpacity(0.15),
                  child: Center(
                    child: Text(opt.emoji,
                        style: const TextStyle(fontSize: 52)),
                  ),
                ),
              ),

              // ── 2. CINEMATIC GRADIENT (diagonal, unique per card) ────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: gradientBegin,
                    end: gradientEnd,
                    stops: const [0.0, 0.38, 0.68, 1.0],
                    colors: [
                      accentDark.withOpacity(0.97),
                      opt.accent.withOpacity(0.88),
                      opt.accent.withOpacity(0.40),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // ── 3. CONTENT ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Frosted badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.28),
                        ),
                      ),
                      child: Text(
                        opt.badgeText,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Title
                    Text(
                      opt.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.05,
                        shadows: [
                          Shadow(
                            color: Color(0x66000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Subtitle
                    Text(
                      opt.subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.white.withOpacity(0.80),
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    // Info pill (glassmorphic)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.22)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 11,
                              color: Colors.white.withOpacity(0.90)),
                          const SizedBox(width: 5),
                          Text(
                            opt.infoText,
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

              // ── 4. SELECTION INNER GLOW BORDER ───────────────────────────
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withOpacity(0.72)
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
              ),

              // ── 5. RADIO (top-right) ─────────────────────────────────────
              Positioned(
                top: 12,
                right: 14,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.18),
                    border: Border.all(
                      color:
                          Colors.white.withOpacity(isSelected ? 1.0 : 0.45),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: opt.accent.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                            )
                          ]
                        : [],
                  ),
                  child: isSelected
                      ? Icon(Icons.check_rounded,
                          color: opt.accent, size: 16)
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

class _RentalOption {
  final int index;
  final String title;
  final String subtitle;
  final String infoText;
  final String emoji;
  final String imagePath;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final Color accent;
  final Color accentLight;

  const _RentalOption({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.infoText,
    required this.emoji,
    required this.imagePath,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.accent,
    required this.accentLight,
  });
}
