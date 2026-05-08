import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_header.dart';
import 'goride_booking_shell.dart';

class GoRidePersonsScreen extends StatefulWidget {
  const GoRidePersonsScreen({super.key});

  @override
  State<GoRidePersonsScreen> createState() => _GoRidePersonsScreenState();
}

class _GoRidePersonsScreenState extends State<GoRidePersonsScreen>
    with SingleTickerProviderStateMixin {
  int _selected = -1;
  int _groupCount = 2;
  late AnimationController _anim;
  late Animation<double> _fade;

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
    return GoRideBookingShell(
      step: 1,
      totalSteps: 6,
      title: 'Qui monte ?',
      subtitle: 'Choisissez votre formule de location',
      child: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildOptionCard(
              index: 0,
              icon: Icons.two_wheeler_rounded,
              title: 'Solo',
              subtitle: '1 moto · Votre balade en toute liberté',
              badge: 'POPULAIRE',
              badgeColor: Go212Colors.primary600,
              color: Go212Colors.primary600,
              detail: 'Idéal pour explorer la ville seul',
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              index: 1,
              icon: Icons.two_wheeler_rounded,
              title: 'Groupe',
              subtitle: 'Plusieurs motos · Pour vous et vos proches',
              badge: 'MULTI',
              badgeColor: const Color(0xFF0D9488),
              color: const Color(0xFF0D9488),
              detail: 'Jusqu\'à 5 motos disponibles simultanément',
            ),
            if (_selected == 1) ...[
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
      onNext: _selected >= 0
          ? () {
              final booking =
                  GoRideBooking(persons: _selected == 0 ? 1 : 2);
              Navigator.pushNamed(context, '/goride/booking/duration',
                  arguments: booking);
            }
          : null,
    );
  }

  Widget _buildOptionCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required Color color,
    required String detail,
  }) {
    final isSelected = _selected == index;
    return GestureDetector(
      onTap: () => setState(() => _selected = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: isSelected ? color.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      // ignore: deprecated_member_use
                      color: color.withOpacity(0.14),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ]
              : [
                  BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(isSelected ? 0.12 : 0.07),
                borderRadius: BorderRadius.circular(16),
              ),
              child: index == 0
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset('assets/images/mascot.png',
                          fit: BoxFit.contain),
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        // Multiple mascots for group
                        Positioned(
                          left: 4,
                          bottom: 6,
                          child: Opacity(
                            opacity: 0.4,
                            child: Image.asset('assets/images/mascot.png',
                                width: 24, height: 24, fit: BoxFit.contain),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 6,
                          child: Opacity(
                            opacity: 0.4,
                            child: Image.asset('assets/images/mascot.png',
                                width: 24, height: 24, fit: BoxFit.contain),
                          ),
                        ),
                        Image.asset('assets/images/mascot.png',
                            width: 34, height: 34, fit: BoxFit.contain),
                      ],
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
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
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF64748B))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          // ignore: deprecated_member_use
                          size: 12,
                          color: color.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          detail,
                          style: TextStyle(
                              fontSize: 11,
                              // ignore: deprecated_member_use
                              color: color.withOpacity(0.8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? color : const Color(0xFFCBD5E1),
                  width: 2,
                ),
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

  Widget _buildGroupCounter() {
    const color = Color(0xFF0D9488);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const GoRideMotoIcon(size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre de motos',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B))),
                Text('2 à 5 motos',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          Row(
            children: [
              _CounterBtn(
                icon: Icons.remove_rounded,
                onTap: _groupCount > 2
                    ? () => setState(() => _groupCount--)
                    : null,
                color: color,
              ),
              Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$_groupCount',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color),
                  ),
                ),
              ),
              _CounterBtn(
                icon: Icons.add_rounded,
                onTap: _groupCount < 5
                    ? () => setState(() => _groupCount++)
                    : null,
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Go212Colors.primary100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shield_rounded,
                size: 18, color: Color(0xFF16A34A)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Assurance incluse',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF166534))),
                SizedBox(height: 2),
                Text('Toutes les motos sont assurées et vérifiées',
                    style: TextStyle(fontSize: 11, color: Color(0xFF4B7A5A))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  const _CounterBtn({required this.icon, this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: disabled ? const Color(0xFFF1F5F9) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              // ignore: deprecated_member_use
              color:
                  disabled ? const Color(0xFFE2E8F0) : color.withOpacity(0.3)),
        ),
        child: Icon(icon,
            size: 18, color: disabled ? const Color(0xFFCBD5E1) : color),
      ),
    );
  }
}
