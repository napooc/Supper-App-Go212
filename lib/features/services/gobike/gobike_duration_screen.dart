import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gobike_header.dart';
import 'gobike_pricing_data.dart';

class GoBikeDurationScreen extends StatefulWidget {
  const GoBikeDurationScreen({super.key});

  @override
  State<GoBikeDurationScreen> createState() => _GoBikeDurationScreenState();
}

class _GoBikeDurationScreenState extends State<GoBikeDurationScreen>
    with TickerProviderStateMixin {
  int? _selectedDurationIndex;
  int _quantity = 1;
  bool _isGroupe = false;

  // Per-duration accent colors for counter gradient
  static const _accentColors = [
    Color(0xFF0369A1), // Heures  — blue
    Color(0xFF166534), // Jours   — green
    Color(0xFF92400E), // Semaines — amber
    Color(0xFF7C3AED), // Mois    — purple
  ];
  static const _prices  = [30, 150, 700, 2500];
  static const _maxQty  = [24, 30, 12, 12];

  static const _green = Color(0xFF009933);
  static const _greenDark = Color(0xFF065F46);
  static const _greenLight = Color(0xFFDCFCE7);
  static const _bg = Color(0xFFF5F7F8);

  final _durations = const [
    _DurationOption(
      index: 0,
      title: 'Heures',
      price: '30 DH/h',
      description: 'Petits trajets urbains',
      emoji: '⏱️',
      imagePath: 'assets/images/heure.jpeg',
      badgeText: 'FLEXIBLE',
      badgeColor: Color(0xFFE0F2FE),
      badgeTextColor: Color(0xFF0369A1),
    ),
    _DurationOption(
      index: 1,
      title: 'Jours',
      price: '150 DH/j',
      description: 'Explorer Casablanca librement',
      emoji: '📅',
      imagePath: 'assets/images/jours.jpeg',
      badgeText: 'POPULAIRE',
      badgeColor: Color(0xFFDCFCE7),
      badgeTextColor: Color(0xFF166534),
    ),
    _DurationOption(
      index: 2,
      title: 'Semaines',
      price: '700 DH/s',
      description: 'Meilleur rapport qualité-prix',
      emoji: '📆',
      imagePath: 'assets/images/semaines.jpeg',
      badgeText: 'ÉCONOMIQUE',
      badgeColor: Color(0xFFFEF3C7),
      badgeTextColor: Color(0xFF92400E),
    ),
    _DurationOption(
      index: 3,
      title: 'Mois',
      price: '2500 DH/m',
      description: 'Expérience GoBike illimitée',
      emoji: '🏆',
      imagePath: 'assets/images/mois.jpeg',
      badgeText: 'PREMIUM',
      badgeColor: Color(0xFFF3E8FF),
      badgeTextColor: Color(0xFF7C3AED),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) _isGroupe = args['isGroupe'] == true;
    else if (args is int) _isGroupe = args == 1;

    final stepLabel = _isGroupe ? '2 / 7' : '2 / 6';

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          GoBikeHeader(
            title: 'Quelle durée ?',
            subtitle: 'GoBike${_isGroupe ? ' · Groupe' : ''}',
            stepText: stepLabel,
            onBack: () => Navigator.pop(context),
          ),

          // ── Subtitle hint ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
            child: Row(
              children: [
                Text(
                  'Choisissez votre formule de location',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          // ── 4 Cards filling ALL available space ────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildCard(_durations[0])),
                        const SizedBox(width: 10),
                        Expanded(child: _buildCard(_durations[1])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildCard(_durations[2])),
                        const SizedBox(width: 10),
                        Expanded(child: _buildCard(_durations[3])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Quantity counter (slides in when selected) ───────────────────
          _buildQuantityCounter(),

          GoBikeCTA(
            label: _buildCtaLabel(),
            enabled: _selectedDurationIndex != null,
            onPressed: () {
              final idx = _selectedDurationIndex!;
              // ✅ Set singleton — single source of truth for all downstream screens
              GoBikePricingData.set(
                durationIndex: idx,
                quantity: _quantity,
                bikeCount: 1, // group screen will update this if isGroupe
              );
              if (_isGroupe) {
                Navigator.pushNamed(
                  context, '/service/gobike/group-reservation',
                );
              } else {
                Navigator.pushNamed(
                  context, '/service/gobike/customize',
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Correct French singular / plural for counter label
  String _getDurationLabel(String pluralTitle, int qty) {
    if (qty == 1) {
      const singular = {
        'Heures': 'Heure',
        'Jours': 'Jour',
        'Semaines': 'Semaine',
        'Mois': 'Mois',
      };
      return singular[pluralTitle] ?? pluralTitle;
    }
    return pluralTitle;
  }

  // CTA label reflects current selection
  String _buildCtaLabel() {
    if (_selectedDurationIndex == null) return 'Choisissez une durée';
    final idx = _selectedDurationIndex!;
    final label = _getDurationLabel(_durations[idx].title, _quantity);
    final total = _prices[idx] * _quantity;
    if (_isGroupe) return 'Continuer — Nombre de vélos';
    return '$_quantity $label · $total DH';
  }

  Widget _buildCard(_DurationOption opt) {
    final isSelected = _selectedDurationIndex == opt.index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedDurationIndex = opt.index;
          _quantity = 1; // reset on each new selection
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? _green : const Color(0xFFEDF0F5),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? _green.withOpacity(0.15)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            children: [
              // ── Selected glow overlay ──
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _green.withOpacity(0.04),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Badge (top-left) ──
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: opt.badgeColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    opt.badgeText,
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: opt.badgeTextColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              // ── Check (top-right) ──
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? _green : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? _green : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 13)
                      : null,
                ),
              ),

              // ── Content ──
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 36, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Image fills most of the card
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Image.asset(
                          opt.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(opt.emoji,
                                style: const TextStyle(fontSize: 40)),
                          ),
                        ),
                      ),
                    ),

                    // Text section — ClipRect prevents overflow on small screens
                    Expanded(
                      flex: 3,
                      child: ClipRect(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                opt.title,
                                style: GoogleFonts.nunito(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected
                                      ? _greenDark
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                opt.price,
                                style: GoogleFonts.nunito(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: _green,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                opt.description,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunito(
                                  fontSize: 10.5,
                                  color: const Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Animated Quantity Counter ─────────────────────────────────────────────
  Widget _buildQuantityCounter() {
    if (_selectedDurationIndex == null) return const SizedBox.shrink();

    final idx = _selectedDurationIndex!;
    final opt = _durations[idx];
    final maxQty = _maxQty[idx];
    final totalPrice = _prices[idx] * _quantity;
    final accent = _accentColors[idx];
    final accentDark = Color.lerp(accent, Colors.black, 0.28)!;
    final canDecrease = _quantity > 1;
    final canIncrease = _quantity < maxQty;

    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: Container(
          height: 78,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accentDark, accent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.38),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [

              // ── [−] Decrease ────────────────────────────────────────
              GestureDetector(
                onTap: canDecrease
                    ? () {
                        HapticFeedback.lightImpact();
                        setState(() => _quantity--);
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 72,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(canDecrease ? 0.18 : 0.05),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(22)),
                  ),
                  child: Icon(
                    Icons.remove_rounded,
                    color: Colors.white
                        .withOpacity(canDecrease ? 1.0 : 0.28),
                    size: 30,
                  ),
                ),
              ),

              // ── Center: number + label + price ──────────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$_quantity ',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          TextSpan(
                            text: _getDurationLabel(opt.title, _quantity),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.88),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Total estimé : $totalPrice DH',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.65),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              // ── [+] Increase ─────────────────────────────────────────
              GestureDetector(
                onTap: canIncrease
                    ? () {
                        HapticFeedback.lightImpact();
                        setState(() => _quantity++);
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 72,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(canIncrease ? 0.18 : 0.05),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(22)),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white
                        .withOpacity(canIncrease ? 1.0 : 0.28),
                    size: 30,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _DurationOption {
  final int index;
  final String title;
  final String price;
  final String description;
  final String emoji;
  final String imagePath;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;

  const _DurationOption({
    required this.index,
    required this.title,
    required this.price,
    required this.description,
    required this.emoji,
    required this.imagePath,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
  });
}
