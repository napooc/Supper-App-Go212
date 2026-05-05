import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/go212_colors.dart';
import '../../core/theme/go212_shadows.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Go212Colors.surfacePage,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Notifications',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Go212Colors.neutral900,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            // Filter chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _FilterChip(label: 'Tout', isSelected: true),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Commandes', isSelected: false),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Offres', isSelected: false),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                children: [
                  _SectionHeader(title: "Aujourd'hui"),
                  const SizedBox(height: 12),
                  _NotifCard(
                    icon: Iconsax.colorfilter,
                    iconColor: Go212Colors.primary600,
                    title: 'Votre laveur est en route',
                    subtitle: 'GoWash Extra · Berline · ETA 12 min',
                    time: 'Il y a 5 min',
                    isUnread: true,
                  ),
                  const SizedBox(height: 10),
                  _NotifCard(
                    icon: Iconsax.discount_shape,
                    iconColor: Go212Colors.warning,
                    title: '-20% sur GoWash',
                    subtitle: 'Code: AVRIL20 · Valable jusqu\'au 30 avril',
                    time: 'Il y a 2h',
                    isUnread: true,
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Cette semaine'),
                  const SizedBox(height: 12),
                  _NotifCard(
                    icon: Iconsax.tick_circle,
                    iconColor: Go212Colors.success,
                    title: 'GoRide terminée',
                    subtitle: 'Merci pour votre confiance ! Évaluez votre expérience.',
                    time: 'Il y a 2j',
                    isUnread: false,
                  ),
                  const SizedBox(height: 10),
                  _NotifCard(
                    icon: Iconsax.wallet_3,
                    iconColor: Go212Colors.info,
                    title: 'Paiement confirmé',
                    subtitle: '60 DH · GoRide · Carte •••• 4521',
                    time: 'Il y a 2j',
                    isUnread: false,
                  ),
                  const SizedBox(height: 10),
                  _NotifCard(
                    icon: Iconsax.star_1,
                    iconColor: Go212Colors.warning,
                    title: 'Gagnez des crédits',
                    subtitle: 'Parrainez un ami et recevez 20 DH.',
                    time: 'Il y a 5j',
                    isUnread: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Go212Colors.primary600 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isSelected ? Go212Shadows.glowSubtle : Go212Shadows.elevation1,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isSelected ? Colors.white : Go212Colors.neutral600,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Go212Colors.neutral400,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;

  const _NotifCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? Go212Colors.primary50.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isUnread
            ? Border.all(color: Go212Colors.primary100, width: 1)
            : null,
        boxShadow: Go212Shadows.elevation1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                              color: Go212Colors.neutral800,
                            ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Go212Colors.primary500,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Go212Colors.neutral500,
                      ),
                  maxLines: 2,
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Go212Colors.neutral400,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
