import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/go212_colors.dart';
import '../../../core/theme/go212_shadows.dart';

class GoRideDetailScreen extends StatelessWidget {
  const GoRideDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Go212Colors.surfacePage,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── HERO with real image ───
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                backgroundColor: const Color(0xFF0F172A),
                leading: IconButton(
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('assets/images/goride_hero.png', fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF0F172A).withOpacity(0.3),
                              const Color(0xFF0F172A).withOpacity(0.5),
                              const Color(0xFF0F172A).withOpacity(0.95),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Glass badges
                              Row(children: [
                                _GlassPill(child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(Icons.bolt_rounded, size: 14, color: Go212Colors.primary400),
                                  const SizedBox(width: 4),
                                  Text('100% ÉLECTRIQUE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                                ])),
                                const SizedBox(width: 8),
                                _GlassPill(child: Text('FLOW 2026', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5))),
                              ]),
                              const SizedBox(height: 16),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: 'Roulez\n', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, height: 1.2)),
                                  TextSpan(text: 'électrique ', style: TextStyle(color: Go212Colors.primary400, fontSize: 34, fontWeight: FontWeight.w800, height: 1.2)),
                                  TextSpan(text: 'dès\nmaintenant', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 34, fontWeight: FontWeight.w800, height: 1.2)),
                                ]),
                              ),
                              const SizedBox(height: 20),
                              // Stats row
                              Row(children: [
                                _StatGlass('30', 'DH/HEURE'),
                                const SizedBox(width: 10),
                                Container(width: 1, height: 36, color: Colors.white.withOpacity(0.2)),
                                const SizedBox(width: 10),
                                _StatGlass('15', 'MIN'),
                                const SizedBox(width: 10),
                                Container(width: 1, height: 36, color: Colors.white.withOpacity(0.2)),
                                const SizedBox(width: 10),
                                _StatGlass('2', 'PLACES'),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Features
                      Text('Ce qui est inclus', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
                      const SizedBox(height: 16),
                      _FeatureCard(Icons.electric_scooter, 'Scooter électrique', 'Flow 2026 — puissant et silencieux', Go212Colors.primary600),
                      _FeatureCard(Icons.battery_charging_full_rounded, 'Swap batterie', 'Échangez en 10 secondes', const Color(0xFF6366F1)),
                      _FeatureCard(Icons.all_inclusive_rounded, 'Autonomie illimitée', 'Réseau GoSwap en ville', const Color(0xFF0EA5E9)),
                      _FeatureCard(Icons.shield_rounded, 'Assurance incluse', 'Roulez l\'esprit tranquille', const Color(0xFF10B981)),
                      _FeatureCard(Icons.sports_motorsports_rounded, 'Casque fourni', '2 casques avec chaque location', const Color(0xFFF59E0B)),
                      const SizedBox(height: 28),

                      // Pricing
                      Text('Nos tarifs', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: _PricingCard('2h', '60', 'Minimum', false)),
                        const SizedBox(width: 10),
                        Expanded(child: _PricingCard('4h', '100', 'Demi-journée', true)),
                        const SizedBox(width: 10),
                        Expanded(child: _PricingCard('24h', '200', 'Journée', false)),
                      ]),
                      const SizedBox(height: 28),

                      // Gallery
                      Text('Galerie', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 160,
                        child: ListView(scrollDirection: Axis.horizontal, children: [
                          _GalleryImg('assets/images/goride_hero.png'),
                          const SizedBox(width: 12),
                          _GalleryImg('assets/images/gobike_hero.png'),
                          const SizedBox(width: 12),
                          _GalleryImg('assets/images/gowash_hero.png'),
                        ]),
                      ),
                      const SizedBox(height: 28),

                      // How it works
                      Text('Comment ça marche', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
                      const SizedBox(height: 16),
                      _Step(1, 'Réservez en ligne', 'Choisissez durée et mode de retrait'),
                      _Step(2, 'Livraison ou retrait', 'En 15 min chez vous ou en agence'),
                      _Step(3, 'Roulez', 'Profitez de Casablanca en électrique'),
                      _Step(4, 'Retour', 'Retournez le scooter ou swappez la batterie'),
                      const SizedBox(height: 28),

                      // Trust bar
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          _DarkTrust(Icons.shield_rounded, 'Assuré'),
                          Container(width: 1, height: 36, color: Colors.white.withOpacity(0.15)),
                          _DarkTrust(Icons.star_rounded, '4.9/5'),
                          Container(width: 1, height: 36, color: Colors.white.withOpacity(0.15)),
                          _DarkTrust(Icons.bolt_rounded, 'Instantané'),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky CTA
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
              decoration: BoxDecoration(color: Colors.white, boxShadow: Go212Shadows.bottomNav),
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text('À partir de', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Go212Colors.neutral500)),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('60', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Go212Colors.primary600, height: 1)),
                    Padding(padding: const EdgeInsets.only(bottom: 2), child: Text(' DH', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Go212Colors.primary600))),
                  ]),
                ]),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(height: 52, child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Go212Colors.primary600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Réserver', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ]),
                  )),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  final Widget child;
  const _GlassPill({required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.2))),
          child: child,
        ),
      ),
    );
  }
}

class _StatGlass extends StatelessWidget {
  final String val; final String label;
  const _StatGlass(this.val, this.label);
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(val, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
    ]);
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon; final String title; final String sub; final Color color;
  const _FeatureCard(this.icon, this.title, this.sub, this.color);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: Go212Shadows.elevation1),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 22, color: color)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
            Text(sub, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Go212Colors.neutral500)),
          ])),
        ]),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final String duration; final String price; final String label; final bool pop;
  const _PricingCard(this.duration, this.price, this.label, this.pop);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pop ? Go212Colors.primary50 : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: pop ? Go212Colors.primary500 : Go212Colors.neutral200, width: pop ? 2 : 1),
        boxShadow: pop ? [BoxShadow(color: Go212Colors.primary600.withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 6))] : Go212Shadows.elevation1,
      ),
      child: Column(children: [
        Text(duration, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
        const SizedBox(height: 4),
        Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(price, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Go212Colors.primary600, height: 1)),
          Text(' DH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Go212Colors.primary600)),
        ]),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Go212Colors.neutral400)),
        if (pop) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: Go212Colors.primary600, borderRadius: BorderRadius.circular(4)),
            child: Text('BEST', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800)),
          ),
        ],
      ]),
    );
  }
}

class _GalleryImg extends StatelessWidget {
  final String asset;
  const _GalleryImg(this.asset);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), boxShadow: Go212Shadows.elevation2),
      child: ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.asset(asset, fit: BoxFit.cover)),
    );
  }
}

class _Step extends StatelessWidget {
  final int n; final String t; final String s;
  const _Step(this.n, this.t, this.s);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: Go212Colors.primary50, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text('$n', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Go212Colors.primary600)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
          Text(s, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Go212Colors.neutral500)),
        ])),
      ]),
    );
  }
}

class _DarkTrust extends StatelessWidget {
  final IconData icon; final String label;
  const _DarkTrust(this.icon, this.label);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Go212Colors.primary400, size: 20)),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w600)),
    ]);
  }
}
