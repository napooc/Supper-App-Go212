import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../../../core/theme/go212_shadows.dart';

class GoWashDetailScreen extends StatelessWidget {
  const GoWashDetailScreen({super.key});

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
                expandedHeight: 340,
                pinned: true,
                backgroundColor: Go212Colors.primary700,
                leading: IconButton(
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white, size: 20),
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
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.share_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('assets/images/gowash.png',
                          fit: BoxFit.cover),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.75),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      // Content overlay
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Glass badges row
                              Row(
                                children: [
                                  _GlassBadge(
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                        Icon(Icons.eco_rounded,
                                            size: 14,
                                            color: Go212Colors.primary300),
                                        const SizedBox(width: 4),
                                        Text('ÉCOLOGIQUE',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.5)),
                                      ])),
                                  const SizedBox(width: 8),
                                  _GlassBadge(
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                        Icon(Icons.star_rounded,
                                            size: 14, color: Colors.amber),
                                        const SizedBox(width: 4),
                                        Text('4.9',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700)),
                                        Text(' (2.1k)',
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                fontSize: 10)),
                                      ])),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Text('GoWash',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      height: 1,
                                      letterSpacing: -0.5)),
                              const SizedBox(height: 6),
                              Text(
                                  'Lavage auto écologique à domicile.\nSans eau. Résultat impeccable.',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 14,
                                      height: 1.5)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── CONTENT ───
              SliverToBoxAdapter(child: _buildContent(context)),
            ],
          ),

          // ─── STICKY CTA ───
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: Go212Shadows.bottomNav,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('À partir de',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Go212Colors.neutral500)),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('60',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Go212Colors.primary600,
                                    height: 1)),
                            Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(' DH',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Go212Colors.primary600))),
                          ]),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/booking/gowash'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Go212Colors.primary600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Réserver',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── FORMULAS ───
          Text('Nos formules',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
          const SizedBox(height: 16),
          _FormulaCard(
            name: 'Essentiel',
            price: '60',
            features: ['Lavage extérieur', 'Nettoyage vitres', 'Jantes'],
            color: Go212Colors.primary500,
            isPopular: false,
          ),
          const SizedBox(height: 12),
          _FormulaCard(
            name: 'Extra',
            price: '110',
            features: [
              'Formule Essentiel +',
              'Aspiration intérieur',
              'Tableau de bord',
              'Traitement cuir'
            ],
            color: Go212Colors.primary600,
            isPopular: true,
          ),
          const SizedBox(height: 12),
          _FormulaCard(
            name: 'Premium',
            price: '150',
            features: [
              'Formule Extra +',
              'Shampooing sièges',
              'Désodorisant',
              'Protection carrosserie'
            ],
            color: Go212Colors.primary700,
            isPopular: false,
          ),

          const SizedBox(height: 32),

          // ─── HOW IT WORKS ───
          Text('Comment ça marche',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
          const SizedBox(height: 16),
          _HowItWorksStep(
              1,
              'Choisissez',
              'Sélectionnez votre formule et véhicule',
              Icons.touch_app_rounded),
          _HowItWorksStep(2, 'Planifiez', 'Choisissez date, heure et adresse',
              Icons.schedule_rounded),
          _HowItWorksStep(3, 'Confirmez', 'Payez en ligne ou en cash',
              Icons.payment_rounded),
          _HowItWorksStep(4, 'Profitez', 'Notre équipe arrive chez vous',
              Icons.local_car_wash_rounded),

          const SizedBox(height: 32),

          // ─── GALLERY ───
          Text('Résultats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _GalleryCard('assets/images/gowash.png'),
                const SizedBox(width: 12),
                _GalleryCard('assets/images/goride.png'),
                const SizedBox(width: 12),
                _GalleryCard('assets/images/gowash.png'),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ─── TRUST & FAQ ───
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Go212Colors.primary600, Go212Colors.primary500],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TrustItem(Icons.eco_rounded, 'Sans eau'),
                      _TrustItem(Icons.access_time_rounded, '45 min'),
                      _TrustItem(Icons.shield_rounded, 'Assuré'),
                      _TrustItem(Icons.star_rounded, '4.9/5'),
                    ]),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // FAQ
          Text('Questions fréquentes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
          const SizedBox(height: 16),
          _FaqItem('Comment fonctionne le lavage sans eau ?',
              'Nous utilisons des produits biodégradables haute performance qui nettoient et protègent votre carrosserie sans aucune goutte d\'eau.'),
          _FaqItem('Combien de temps dure le lavage ?',
              'En moyenne 45 minutes pour la formule Essentiel, 1h pour Extra et 1h30 pour Premium.'),
          _FaqItem('Quelles zones couvrez-vous ?',
              'Nous couvrons toute la zone urbaine de Casablanca et ses environs.'),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Glass badge
// ═══════════════════════════════════════════════════════════════
class _GlassBadge extends StatelessWidget {
  final Widget child;
  const _GlassBadge({required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Formula card with glassmorphism
// ═══════════════════════════════════════════════════════════════
class _FormulaCard extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;
  final Color color;
  final bool isPopular;

  const _FormulaCard({
    required this.name,
    required this.price,
    required this.features,
    required this.color,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isPopular ? color.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isPopular ? color : Go212Colors.neutral200,
            width: isPopular ? 2 : 1),
        boxShadow: isPopular
            ? [
                BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8))
              ]
            : Go212Shadows.elevation1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Go212Colors.neutral800)),
              if (isPopular) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(6)),
                  child: Text('★ Populaire',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
              ],
              const Spacer(),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(price,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: color,
                        height: 1)),
                Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(' DH',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: color))),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Icon(Icons.check_rounded, size: 14, color: color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(f,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Go212Colors.neutral600,
                                  fontWeight: FontWeight.w500))),
                ]),
              )),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// How it works step
// ═══════════════════════════════════════════════════════════════
class _HowItWorksStep extends StatelessWidget {
  final int number;
  final String title;
  final String subtitle;
  final IconData icon;
  const _HowItWorksStep(this.number, this.title, this.subtitle, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: Go212Colors.primary50,
                    borderRadius: BorderRadius.circular(14)),
                child: Center(
                    child: Text('$number',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Go212Colors.primary600))),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                    color: Go212Colors.primary600,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.white, width: 2)),
                child: Icon(icon, size: 12, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Go212Colors.neutral800)),
                Text(subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Go212Colors.neutral500)),
              ])),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Gallery card
// ═══════════════════════════════════════════════════════════════
class _GalleryCard extends StatelessWidget {
  final String imageAsset;
  const _GalleryCard(this.imageAsset);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: Go212Shadows.elevation2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(imageAsset, fit: BoxFit.cover),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Trust item (white on green)
// ═══════════════════════════════════════════════════════════════
class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      const SizedBox(height: 6),
      Text(label,
          style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════
// FAQ accordion
// ═══════════════════════════════════════════════════════════════
class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _expanded ? Go212Colors.primary50 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: _expanded
                    ? Go212Colors.primary300
                    : Go212Colors.neutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Text(widget.question,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Go212Colors.neutral800))),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 22, color: Go212Colors.neutral500),
                ),
              ]),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(widget.answer,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Go212Colors.neutral600, height: 1.5)),
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
