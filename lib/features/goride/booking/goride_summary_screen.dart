import 'package:flutter/material.dart';
import '../models/goride_booking_model.dart';
import 'goride_booking_shell.dart';

class GoRideSummaryScreen extends StatefulWidget {
  const GoRideSummaryScreen({super.key});

  @override
  State<GoRideSummaryScreen> createState() => _GoRideSummaryScreenState();
}

class _GoRideSummaryScreenState extends State<GoRideSummaryScreen>
    with SingleTickerProviderStateMixin {
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
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();

    return GoRideBookingShell(
      step: 5,
      totalSteps: 6,
      title: 'Votre résumé',
      subtitle: 'Vérifiez votre réservation avant de confirmer',
      child: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildPriceCard(booking),
            const SizedBox(height: 20),
            _buildSectionTitle('Détails de la réservation'),
            const SizedBox(height: 12),
            _buildSummaryCard(booking),
            if (booking.deliveryFee > 0) ...[
              const SizedBox(height: 14),
              _buildDeliveryFeeCard(booking),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
      onNext: () => Navigator.pushNamed(context, '/goride/booking/payment',
          arguments: booking),
      nextLabel: 'Confirmer la réservation',
    );
  }

  Widget _buildPriceCard(GoRideBooking booking) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D3D26), Color(0xFF16A34A)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              // ignore: deprecated_member_use
              color: const Color(0xFF16A34A).withOpacity(0.30),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.payments_rounded,
                size: 26, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.pricePerUnit,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5),
                ),
                const SizedBox(height: 3),
                Text(
                  'Formule ${booking.durationLabel} · ${booking.totalMotos} moto${booking.totalMotos > 1 ? "s" : ""}',
                  style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 12.5),
                ),
                if (booking.deliveryFee > 0) ...[                  const SizedBox(height: 4),
                  Text(
                    '+ ${booking.deliveryFeeLabel} frais de livraison',
                    style: TextStyle(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
    );
  }

  Widget _buildDeliveryFeeCard(GoRideBooking booking) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.delivery_dining_rounded,
                size: 18, color: Color(0xFFF59E0B)),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Text('Frais de livraison',
                style: TextStyle(fontSize: 13, color: Color(0xFF92400E))),
          ),
          Text(booking.deliveryFeeLabel,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB45309))),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(GoRideBooking booking) {
    final rows = [
      _SRow(
          Icons.people_rounded,
          'Passagers',
          booking.persons == 1 ? 'Solo (1 pers.)' : 'Groupe',
          const Color(0xFF16A34A),
          '/goride/booking/persons'),
      _SRow(Icons.timer_rounded, 'Formule', booking.durationLabel,
          const Color(0xFF3B82F6), '/goride/booking/duration'),
      _SRow(Icons.calendar_today_rounded, 'Date de départ',
          booking.formattedDate, const Color(0xFFF59E0B), '/goride/booking/details'),
      _SRow(Icons.access_time_rounded, 'Heure de départ',
          booking.startTime ?? '—', const Color(0xFF8B5CF6), '/goride/booking/details'),
      _SRow(
          booking.deliveryType == 'livraison'
              ? Icons.delivery_dining_rounded
              : Icons.store_rounded,
          'Mode de réception',
          booking.deliveryLabel,
          const Color(0xFFEF4444),
          '/goride/booking/delivery'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          final r = e.value;
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: r.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(r.icon, size: 17, color: r.color),
                    ),
                    const SizedBox(width: 13),
                    Text(r.label,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF64748B))),
                    const Spacer(),
                    Text(r.value,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A))),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.popUntil(
                          context, (route) => route.settings.name == r.route),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.edit_rounded,
                            size: 14, color: Color(0xFF94A3B8)),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                    height: 1,
                    color: Color(0xFFF1F5F9),
                    indent: 18,
                    endIndent: 18),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildModifySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Modifier',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildChip(context, 'Personnes', Icons.people_rounded,
                '/goride/booking/persons'),
            _buildChip(context, 'Durée', Icons.timer_rounded,
                '/goride/booking/duration'),
            _buildChip(context, 'Date & Heure', Icons.calendar_today_rounded,
                '/goride/booking/details'),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(
      BuildContext context, String label, IconData icon, String route) {
    return GestureDetector(
      onTap: () => Navigator.popUntil(context, (r) => r.settings.name == route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF16A34A)),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155))),
            const SizedBox(width: 4),
            const Icon(Icons.edit_rounded, size: 11, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _SRow {
  final IconData icon;
  final String label, value;
  final Color color;
  final String route;
  const _SRow(this.icon, this.label, this.value, this.color, this.route);
}
