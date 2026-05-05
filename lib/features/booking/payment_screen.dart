import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/go212_colors.dart';
import '../../core/theme/go212_shadows.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Go212Colors.neutral50, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_rounded, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Paiement', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Choisissez votre moyen\nde paiement', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral900)),
                const SizedBox(height: 24),
                _PaymentOption(
                  index: 0,
                  selected: _selectedMethod == 0,
                  icon: Iconsax.card,
                  title: 'Carte bancaire',
                  subtitle: 'Visa •••• 4521',
                  onTap: () => setState(() => _selectedMethod = 0),
                ),
                const SizedBox(height: 10),
                _PaymentOption(
                  index: 1,
                  selected: _selectedMethod == 1,
                  icon: Iconsax.card_add,
                  title: 'Ajouter une carte',
                  subtitle: 'Visa, Mastercard',
                  onTap: () => setState(() => _selectedMethod = 1),
                ),
                const SizedBox(height: 10),
                _PaymentOption(
                  index: 2,
                  selected: _selectedMethod == 2,
                  icon: Iconsax.money_recive,
                  title: 'Paiement en cash',
                  subtitle: 'À la livraison du service',
                  onTap: () => setState(() => _selectedMethod = 2),
                ),
                const SizedBox(height: 10),
                _PaymentOption(
                  index: 3,
                  selected: _selectedMethod == 3,
                  icon: Iconsax.wallet_3,
                  title: 'GO212 Wallet',
                  subtitle: 'Solde: 0.00 DH',
                  onTap: () => setState(() => _selectedMethod = 3),
                  disabled: true,
                ),
                const SizedBox(height: 32),
                // Security badge
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Go212Colors.primary50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.shield_tick, size: 24, color: Go212Colors.primary600),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Paiement 100% sécurisé', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
                            Text('Certifié CMI · Visa · Mastercard', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Go212Colors.neutral500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(color: Colors.white, boxShadow: Go212Shadows.bottomNav),
            child: SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/success'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Go212Colors.primary600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.lock_1, size: 18),
                    const SizedBox(width: 8),
                    Text('Confirmer · 110 DH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final int index;
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool disabled;

  const _PaymentOption({
    required this.index,
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: disabled ? Go212Colors.neutral50 : selected ? Go212Colors.primary50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Go212Colors.primary500 : Go212Colors.neutral200,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected ? Go212Shadows.glowSubtle : [],
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: disabled ? Go212Colors.neutral100 : selected ? Go212Colors.primary100 : Go212Colors.neutral100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: disabled ? Go212Colors.neutral400 : selected ? Go212Colors.primary600 : Go212Colors.neutral600),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: disabled ? Go212Colors.neutral400 : Go212Colors.neutral800)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Go212Colors.neutral500)),
                ],
              ),
            ),
            if (selected)
              Container(width: 24, height: 24, decoration: BoxDecoration(color: Go212Colors.primary600, shape: BoxShape.circle), child: Icon(Icons.check_rounded, size: 16, color: Colors.white))
            else
              Container(width: 24, height: 24, decoration: BoxDecoration(border: Border.all(color: disabled ? Go212Colors.neutral300 : Go212Colors.neutral300, width: 2), shape: BoxShape.circle)),
          ],
        ),
      ),
    );
  }
}
