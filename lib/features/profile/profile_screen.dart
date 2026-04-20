import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/go212_colors.dart';
import '../../core/theme/go212_shadows.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Go212Colors.surfacePage,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            Text(
              'Mon Profil',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Go212Colors.neutral900,
                  ),
            ),
            const SizedBox(height: 24),
            // Profile header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: Go212Shadows.elevation1,
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: Go212Colors.heroGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        'YK',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yassine Kabbaj',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Go212Colors.neutral800,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+212 6 XX XX XX XX',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Go212Colors.neutral500,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Iconsax.location, size: 12, color: Go212Colors.primary600),
                            const SizedBox(width: 4),
                            Text(
                              'Casablanca',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Go212Colors.primary600,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Go212Colors.neutral50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Iconsax.edit_2, size: 18, color: Go212Colors.neutral600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Wallet
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: Go212Colors.promoGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: Go212Shadows.glowSubtle,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Iconsax.wallet_3, size: 22, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GO212 Wallet',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          '0.00 DH',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Recharger',
                      style: TextStyle(
                        color: Go212Colors.primary600,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Settings sections
            _SettingsSection(
              title: 'Mon Compte',
              items: [
                _SettingsItem(Iconsax.location, 'Adresses enregistrées'),
                _SettingsItem(Iconsax.card, 'Moyens de paiement'),
                _SettingsItem(Iconsax.global, 'Langue', trailing: 'Français'),
                _SettingsItem(Iconsax.notification, 'Notifications'),
                _SettingsItem(Iconsax.lock_1, 'Sécurité'),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsSection(
              title: 'Support',
              items: [
                _SettingsItem(Iconsax.message_question, 'Centre d\'aide'),
                _SettingsItem(Iconsax.messages_1, 'Contacter le support'),
                _SettingsItem(Iconsax.document_text, 'CGU & Confidentialité'),
                _SettingsItem(Iconsax.info_circle, 'À propos de GO212'),
              ],
            ),
            const SizedBox(height: 24),
            // Sign out
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: Go212Shadows.elevation1,
              ),
              child: ListTile(
                onTap: () {},
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Go212Colors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Iconsax.logout, size: 20, color: Go212Colors.error),
                ),
                title: Text(
                  'Se déconnecter',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Go212Colors.error,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                trailing: Icon(Icons.chevron_right_rounded,
                    color: Go212Colors.neutral400),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'GO212 v1.0.0',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Go212Colors.neutral400,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;
  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Go212Colors.neutral400,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: Go212Shadows.elevation1,
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Go212Colors.primary50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 20, color: Go212Colors.primary600),
                    ),
                    title: Text(
                      item.label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Go212Colors.neutral700,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.trailing != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              item.trailing!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Go212Colors.neutral400,
                                  ),
                            ),
                          ),
                        Icon(Icons.chevron_right_rounded,
                            size: 20, color: Go212Colors.neutral400),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  if (i < items.length - 1)
                    Divider(
                      indent: 68,
                      endIndent: 16,
                      height: 0,
                      color: Go212Colors.neutral100,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final String? trailing;
  _SettingsItem(this.icon, this.label, {this.trailing});
}
