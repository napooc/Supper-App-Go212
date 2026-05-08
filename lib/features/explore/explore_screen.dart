import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/go212_colors.dart';
import '../../core/theme/go212_shadows.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedCategory = 0;

  final _categories = ['Tout', 'Mobilité', 'Maison', 'Shopping', 'Énergie'];

  final List<_ExploreService> _all = [
    _ExploreService('GoRide', 'Scooter électrique 100% autonome.', 'À partir de 30 DH/h', Icons.electric_scooter, true, 'Mobilité',
        'assets/images/goride.png', Go212Colors.primary600, '/service/goride'),
    _ExploreService('GoWash', 'Lavage auto écologique à domicile. Sans eau.', 'Dès 60 DH', Icons.water_drop_rounded, true, 'Maison',
        'assets/images/gowash.png', const Color(0xFF06B6D4), '/service/gowash'),
    _ExploreService('GoBike', 'Location de vélos classiques & E-Bikes en ville.', 'À partir de 30 DH/h', Icons.pedal_bike_rounded, true, 'Mobilité',
        'assets/images/gobike_hero.png', const Color(0xFF008333), '/service/gobike'),
    _ExploreService('GoClean', 'Nettoyage Airbnb & résidentiel professionnel.', 'Dès 150 DH', Icons.cleaning_services_rounded, true, 'Maison',
        'assets/images/gowash.png', const Color(0xFF8B5CF6), '/service/goclean'),
    _ExploreService('GoFix', 'Plomberie, électricité, peinture à domicile.', 'Devis gratuit', Icons.build_rounded, true, 'Maison',
        'assets/images/gofix.png', const Color(0xFFF59E0B), '/service/gofix'),
    _ExploreService('GoPrint', 'Impression et personnalisation.', 'Dès 120 DH', Icons.print_rounded, false, 'Shopping',
        'assets/images/goride.png', const Color(0xFFEC4899), '/service/goprint'),
    _ExploreService('GoEvent', 'Billetterie d\'événements 100% digital.', 'Billetterie', Icons.celebration_rounded, false, 'Shopping',
        'assets/images/gowash.png', const Color(0xFFF43F5E), '/service/goevent'),
    _ExploreService('GoShop', 'Livraison de produits locaux.', 'Livraison express', Icons.shopping_bag_rounded, false, 'Shopping',
        'assets/images/gobike.png', const Color(0xFF10B981), '/service/goshop'),
    _ExploreService('GoSwap', 'Échange de batteries instantané.', '19 stations', Icons.battery_charging_full_rounded, true, 'Énergie',
        'assets/images/goride.png', const Color(0xFF6366F1), '/service/goswap'),
  ];

  List<_ExploreService> get _filtered {
    if (_selectedCategory == 0) return _all;
    return _all.where((s) => s.category == _categories[_selectedCategory]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Go212Colors.surfacePage,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explorer', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral900)),
                  const SizedBox(height: 4),
                  Text('Découvrez tous nos 9 services', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Go212Colors.neutral500)),
                  const SizedBox(height: 16),
                  // Search
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: Go212Shadows.elevation1,
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.search_normal, size: 20, color: Go212Colors.neutral400),
                        const SizedBox(width: 12),
                        Expanded(child: Text('Rechercher un service...', style: TextStyle(color: Go212Colors.neutral400, fontSize: 14))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Category chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final selected = _selectedCategory == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: selected ? Go212Colors.primary600 : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: selected ? Go212Colors.primary600 : Go212Colors.neutral200),
                        boxShadow: selected ? [BoxShadow(color: Go212Colors.primary600.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))] : [],
                      ),
                      child: Center(
                        child: Text(
                          _categories[index],
                          style: TextStyle(color: selected ? Colors.white : Go212Colors.neutral600, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Service list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                physics: const BouncingScrollPhysics(),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final s = _filtered[index];
                  return _ExploreCard(service: s);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreCard extends StatefulWidget {
  final _ExploreService service;
  const _ExploreCard({required this.service});

  @override
  State<_ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<_ExploreCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        Navigator.pushNamed(context, s.route);
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: Go212Shadows.elevation2,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                Image.asset(s.imageAsset, fit: BoxFit.cover),
                // Dark gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.85),
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: s.color.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                          child: Icon(s.icon, size: 18, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(s.name, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        if (s.available)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: Go212Colors.primary600, borderRadius: BorderRadius.circular(6)),
                            child: Text('Disponible', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                          ),
                      ]),
                      const SizedBox(height: 8),
                      Text(s.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      // Glass price pill
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Text(s.price, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
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
      ),
    );
  }
}

class _ExploreService {
  final String name;
  final String subtitle;
  final String price;
  final IconData icon;
  final bool available;
  final String category;
  final String imageAsset;
  final Color color;
  final String route;
  _ExploreService(this.name, this.subtitle, this.price, this.icon, this.available, this.category, this.imageAsset, this.color, this.route);
}
