import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/go212_colors.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Transform.scale(
                    scale: _scale.value,
                    child: Opacity(
                      opacity: _opacity.value,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          color: Go212Colors.primary600,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Go212Colors.primary600.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
                        ),
                        child: const Icon(Icons.check_rounded, size: 48, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text('Réservation\nconfirmée ! 🎉', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral900)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Go212Colors.neutral50, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    _summaryRow(context, 'Service', 'GoWash · Extra'),
                    _summaryRow(context, 'Date', '20 avril 2026 · 14h00'),
                    _summaryRow(context, 'Véhicule', 'Berline'),
                    _summaryRow(context, 'Montant', '110 DH'),
                    const Divider(height: 20),
                    Row(children: [
                      Icon(Iconsax.copy, size: 16, color: Go212Colors.primary600),
                      const SizedBox(width: 8),
                      Text('Réf: #GW-2026-0420', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Go212Colors.primary600, fontWeight: FontWeight.w600)),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Votre laveur arrivera à l\'heure prévue.\nVous serez notifié par SMS.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Go212Colors.neutral500, height: 1.5)),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false),
                  style: ElevatedButton.styleFrom(backgroundColor: Go212Colors.primary600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Suivre ma commande', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ]),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false),
                child: Text('Retour à l\'accueil', style: TextStyle(color: Go212Colors.neutral500, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Go212Colors.neutral500)),
          Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
        ],
      ),
    );
  }
}
