// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_btn.dart';
import '../widgets/goride_header.dart';

class GoRideDeliveryScreen extends StatefulWidget {
  const GoRideDeliveryScreen({super.key});
  @override
  State<GoRideDeliveryScreen> createState() => _GoRideDeliveryScreenState();
}

class _GoRideDeliveryScreenState extends State<GoRideDeliveryScreen>
    with SingleTickerProviderStateMixin {
  String? _selected;
  late AnimationController _anim;
  late Animation<double> _fade;
  final _addressCtrl = TextEditingController();
  final _addressFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _addressCtrl.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  children: [
                    _buildCard(
                      key: 'livraison',
                      emoji: '🛵',
                      title: 'Livraison à domicile',
                      info: '30–45 min · Zone Casablanca',
                      badge: '20 DH',
                      badgeColor: const Color(0xFFF59E0B),
                      color: Go212Colors.primary600,
                    ),
                    // ── Champ adresse si livraison sélectionnée ──
                    if (_selected == 'livraison') ...[
                      const SizedBox(height: 14),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Go212Colors.primary600.withOpacity(0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded, color: Go212Colors.primary600, size: 20),
                                const SizedBox(width: 8),
                                Text('Adresse de livraison',
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Go212Colors.primary600)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _addressCtrl,
                              focusNode: _addressFocus,
                              decoration: InputDecoration(
                                hintText: 'Ex: 23 Rue Mohammed V, Casablanca',
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Go212Colors.primary600, width: 1.5),
                                ),
                                prefixIcon: Icon(Icons.home_rounded, color: Colors.grey[400]),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              ),
                              textInputAction: TextInputAction.done,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: 6),
                            Text('La moto sera livrée à cette adresse',
                                style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    _buildCard(
                      key: 'agence',
                      emoji: '🏪',
                      title: 'Retrait en agence',
                      info: '611, Rue Goulmima · Bourgogne',
                      badge: 'Gratuit',
                      badgeColor: const Color(0xFF0D9488),
                      color: const Color(0xFF0D9488),
                    ),

                  ],
                ),
              ),
            ),
          ),
          _buildFooter(context, booking),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GoRideHeader(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GoRideBackBtn(onTap: () => Navigator.pop(context)),
                  const Spacer(),
                  Image.asset('assets/images/goride.png',
                      height: 36, fit: BoxFit.contain),
                  const SizedBox(width: 10),
                  const GoRideStepBadge(step: 4, total: 6),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Réception de la moto',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Livraison ou retrait',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String key,
    required String emoji,
    required String title,
    required String info,
    required String badge,
    required Color badgeColor,
    required Color color,
  }) {
    final isSelected = _selected == key;
    return GestureDetector(
      onTap: () {
        if (key == 'livraison' && _selected != 'livraison') {
          _showGpsDialog().then((granted) {
            if (granted && mounted) setState(() => _selected = key);
          });
        } else {
          setState(() => _selected = key);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: color.withOpacity(0.14),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: color.withOpacity(isSelected ? 0.12 : 0.07),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 32))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(title,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B))),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(badge,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: badgeColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(info,
                      style: const TextStyle(
                          fontSize: 12.5, color: Color(0xFF64748B))),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected ? color : const Color(0xFFCBD5E1),
                    width: 2),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgenceBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: const Row(
        children: [
          Text('🗺️', style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GO212 Bourgogne',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4C1D95))),
                SizedBox(height: 2),
                Text('611, Rue Goulmima · Lun–Sam 8h–20h',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6D28D9))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── GPS Permission Dialog ──────────────────────────────────────────
  Future<bool> _showGpsDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Animated GPS icon ──
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Go212Colors.primary500,
                      Go212Colors.primary700,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Go212Colors.primary600.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.my_location_rounded,
                    color: Colors.white, size: 36),
              ),
              const SizedBox(height: 24),
              // ── Title ──
              const Text(
                'Activer la localisation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),
              // ── Description ──
              Text(
                'Pour vous livrer la moto, nous avons besoin '
                'de votre position GPS afin de localiser '
                'votre adresse de livraison.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              // ── Info chip ──
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_rounded,
                        size: 14, color: Go212Colors.primary600),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        'Votre position reste confidentielle',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // ── Activate button ──
              GestureDetector(
                onTap: () => Navigator.pop(ctx, true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Go212Colors.primary700,
                        Go212Colors.primary500,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Go212Colors.primary600.withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.gps_fixed_rounded,
                          color: Colors.white, size: 18),
                      SizedBox(width: 10),
                      Text('Activer le GPS',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // ── Later button ──
              GestureDetector(
                onTap: () => Navigator.pop(ctx, false),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text('Plus tard',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }

  Widget _buildFooter(BuildContext context, GoRideBooking booking) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4))
        ],
      ),
      child: GoRideBtn(
        label: 'Continuer',
        onTap: (_selected != null && (_selected != 'livraison' || _addressCtrl.text.trim().isNotEmpty))
            ? () {
                final updated = booking.copyWith(
                  deliveryType: _selected,
                  deliveryAddress: _selected == 'livraison' ? _addressCtrl.text.trim() : null,
                );
                if (_selected == 'agence') {
                  Navigator.pushNamed(context, '/goride/booking/agence',
                      arguments: updated);
                } else {
                  Navigator.pushNamed(context, '/goride/booking/summary',
                      arguments: updated);
                }
              }
            : null,
      ),
    );
  }
}
