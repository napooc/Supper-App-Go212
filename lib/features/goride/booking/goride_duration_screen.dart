// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/go212_colors.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_header.dart';
import 'goride_booking_shell.dart';

class GoRideDurationScreen extends StatefulWidget {
  const GoRideDurationScreen({super.key});
  @override
  State<GoRideDurationScreen> createState() => _GoRideDurationScreenState();
}

class _GoRideDurationScreenState extends State<GoRideDurationScreen>
    with SingleTickerProviderStateMixin {
  String? _selected;
  int _quantity = 1;
  late AnimationController _anim;
  late Animation<double> _fade;

  static const _items = [
    _DItem(key: 'heure', image: 'assets/images/hours.png'),
    _DItem(key: 'jour', image: 'assets/images/days.png'),
    _DItem(key: 'semaine', image: 'assets/images/weeks.png'),
    _DItem(key: 'mois', image: 'assets/images/months.png'),
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();
    return GoRideBookingShell(
      step: 2,
      totalSteps: 6,
      title: 'Choisissez la période',
      subtitle: 'Sélectionnez la durée qui correspond à vos besoins',
      child: FadeTransition(
        opacity: _fade,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 10),
          child: Column(
            children: [
              // ── Mascot hint row ──
              _buildMascotHint(),
              const SizedBox(height: 18),
              // ── 2x2 Grid of image cards ──
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.92,
                children: _items
                    .map((item) => _ImageCard(
                          item: item,
                          isSelected: _selected == item.key,
                          onTap: () => setState(() {
                            _selected = item.key;
                            _quantity = 1; // reset on each selection
                          }),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 14),
              // ── Quantity counter (slides in when selected) ──
              if (_selected != null) _buildQuantityCounter(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      onNext: _selected != null
          ? () => Navigator.pushNamed(context, '/goride/booking/details',
              arguments: booking.copyWith(
                duration: _selected,
                durationQuantity: _quantity,
              ))
          : null,
    );
  }

  Widget _buildMascotHint() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Go212Colors.primary200),
      ),
      child: Row(
        children: [
          // Mascot
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Go212Colors.primary300, width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: Go212Colors.primary400.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: const GoRideMascotBadge(size: 44),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quelle période vous convient ?',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Go212Colors.primary800)),
                const SizedBox(height: 2),
                Text('Touchez une carte pour sélectionner',
                    style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Animated Quantity Counter ────────────────────────────────────────────
  Widget _buildQuantityCounter() {
    // Prices per unit (must match GoRideBooking.unitPrice)
    const priceMap  = {'heure': 30,      'jour': 150,   'semaine': 700, 'mois': 2500};
    const maxQtyMap = {'heure': 24,      'jour': 30,    'semaine': 12,  'mois': 12};
    const singular  = {'heure': 'Heure', 'jour': 'Jour','semaine': 'Semaine','mois': 'Mois'};
    const plural    = {'heure': 'Heures','jour': 'Jours','semaine': 'Semaines','mois': 'Mois'};

    final maxQty    = maxQtyMap[_selected] ?? 24;
    final unitPrice = priceMap[_selected]  ?? 0;
    final totalPrice = unitPrice * _quantity;
    // Correct French singular/plural
    final label     = _quantity == 1
        ? (singular[_selected] ?? _selected!)
        : (plural[_selected]   ?? _selected!);
    final canDecrease = _quantity > 1;
    final canIncrease = _quantity < maxQty;

    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      child: Container(
        height: 78,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(Go212Colors.primary600, Colors.black, 0.22)!,
              Go212Colors.primary500,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Go212Colors.primary500.withOpacity(0.35),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── [−] Decrease ─────────────────────────────────────────────
            GestureDetector(
              onTap: canDecrease
                  ? () { HapticFeedback.lightImpact(); setState(() => _quantity--); }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 72,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(canDecrease ? 0.18 : 0.05),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(22)),
                ),
                child: Icon(Icons.remove_rounded,
                    color: Colors.white.withOpacity(canDecrease ? 1.0 : 0.28), size: 30),
              ),
            ),
            // ── Center ───────────────────────────────────────────────────
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: '$_quantity ',
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w900,
                            color: Colors.white, height: 1.0),
                      ),
                      TextSpan(
                        text: label,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.88)),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 3),
                  Text('Total estimé : $totalPrice DH',
                      style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.white.withOpacity(0.65),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            // ── [+] Increase ─────────────────────────────────────────────
            GestureDetector(
              onTap: canIncrease
                  ? () { HapticFeedback.lightImpact(); setState(() => _quantity++); }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 72,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(canIncrease ? 0.18 : 0.05),
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(22)),
                ),
                child: Icon(Icons.add_rounded,
                    color: Colors.white.withOpacity(canIncrease ? 1.0 : 0.28), size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Image Card Widget ───────────────────────────────────────────────
class _ImageCard extends StatelessWidget {
  final _DItem item;
  final bool isSelected;
  final VoidCallback onTap;
  const _ImageCard(
      {required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? Go212Colors.primary500
                : const Color(0xFFE8EDE8),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Go212Colors.primary500.withOpacity(0.22),
                      blurRadius: 22,
                      offset: const Offset(0, 8)),
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
        ),
        child: Stack(
          children: [
            // The card image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.expand(
                child: Image.asset(
                  item.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported_rounded,
                            size: 36,
                            color: const Color(0xFFCBD5E1)),
                        const SizedBox(height: 6),
                        Text(item.key.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Selected overlay + check
            if (isSelected) ...[
              // Subtle green overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Go212Colors.primary500.withOpacity(0.06),
                  ),
                ),
              ),
              // Check badge top-right
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Go212Colors.primary500,
                        Go212Colors.primary600,
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Go212Colors.primary600.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3)),
                    ],
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 18, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DItem {
  final String key;
  final String image;
  const _DItem({required this.key, required this.image});
}
