import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/go212_colors.dart';
import '../../core/theme/go212_shadows.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() => setState(() => _scrollOffset = _scrollController.offset));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── TOP BAR ───
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            snap: true,
            backgroundColor: _scrollOffset > 20 ? Colors.white.withOpacity(0.97) : Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF047857)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text('GO', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, height: 1))),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('GO212', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Go212Colors.neutral800, letterSpacing: 0.5)),
                    Row(children: [
                      Icon(Iconsax.location, size: 12, color: Go212Colors.primary600),
                      const SizedBox(width: 3),
                      Text('Casablanca', style: TextStyle(fontSize: 11, color: Go212Colors.neutral500, fontWeight: FontWeight.w500)),
                    ]),
                  ],
                ),
                const Spacer(),
                _TopBtn(icon: Iconsax.search_normal, onTap: () {}),
                const SizedBox(width: 8),
                _TopBtn(icon: Iconsax.notification, badge: 2, onTap: () {}),
              ],
            ),
          ),

          // ─── CONTENT ───
          SliverToBoxAdapter(
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 450),
                  childAnimationBuilder: (w) => SlideAnimation(verticalOffset: 25, child: FadeInAnimation(child: w)),
                  children: [
                    const SizedBox(height: 8),
                    _buildGreeting(context),
                    const SizedBox(height: 20),
                    _buildHeroCard(context),
                    const SizedBox(height: 28),
                    _sectionHead(context, 'Services Populaires'),
                    const SizedBox(height: 14),
                    _buildPopularRow(context),
                    const SizedBox(height: 28),
                    _sectionHead(context, 'Tous les Services'),
                    const SizedBox(height: 14),
                    _buildAllServices(context),
                    const SizedBox(height: 28),
                    _buildActiveOrder(context),
                    const SizedBox(height: 28),
                    _buildTrustBar(context),
                    const SizedBox(height: 24),
                    _buildSupportCard(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── GREETING ───
  Widget _buildGreeting(BuildContext context) {
    final h = DateTime.now().hour;
    final g = h < 12 ? 'Bonjour' : h < 18 ? 'Bon après-midi' : 'Bonsoir';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$g 👋', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral900)),
          const SizedBox(height: 2),
          Text('De quoi avez-vous besoin ?', style: TextStyle(fontSize: 14, color: Go212Colors.neutral500)),
        ],
      ),
    );
  }

  // ─── HERO CARD — Premium gradient with image ───
  Widget _buildHeroCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/service/goride'),
        child: Container(
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: const Color(0xFF059669).withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 10))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('assets/images/goride_hero.png', fit: BoxFit.cover),
                Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Colors.transparent, Colors.black.withOpacity(0.75)]))),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _GlassChip('⚡ NOUVEAU · GORIDE'),
                      const Spacer(),
                      Text('Scooter électrique\ndès 30 DH/h', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.25)),
                      const SizedBox(height: 12),
                      _GlassCta('Découvrir'),
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

  // ─── POPULAR SERVICES — Horizontal scroll image cards ───
  Widget _buildPopularRow(BuildContext context) {
    final items = [
      _PopService('GoWash', 'Dès 60 DH', 'assets/images/gowash_hero.png', '/service/gowash', const Color(0xFF06B6D4)),
      _PopService('GoClean', 'Dès 150 DH', 'assets/images/goclean_hero.png', '/service/goclean', const Color(0xFF8B5CF6)),
      _PopService('GoFix', 'Devis gratuit', 'assets/images/gofix_hero.png', '/service/gofix', const Color(0xFFF59E0B)),
      _PopService('GoBike', '30 DH/h', 'assets/images/gobike_hero.png', '/service/gobike', const Color(0xFF008333)),
    ];
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _PopularCard(item: items[i]),
      ),
    );
  }

  // ─── ALL SERVICES — 3×3 Image-based grid with real photos ───
  Widget _buildAllServices(BuildContext context) {
    final services = [
      _SvcData('GoRide', 'Scooter', Icons.electric_scooter, Go212Colors.primary600, 'assets/images/goride_hero.png', '/service/goride'),
      _SvcData('GoWash', 'Lavage', Icons.water_drop_rounded, const Color(0xFF06B6D4), 'assets/images/gowash_hero.png', '/service/gowash'),
      _SvcData('GoClean', 'Ménage', Icons.cleaning_services_rounded, const Color(0xFF8B5CF6), 'assets/images/goclean_hero.png', '/service/goclean'),
      _SvcData('GoFix', 'Réparation', Icons.build_rounded, const Color(0xFFF59E0B), 'assets/images/gofix_hero.png', '/service/gofix'),
      _SvcData('GoBike', 'Vélo', Icons.pedal_bike_rounded, const Color(0xFF008333), 'assets/images/gobike_hero.png', '/service/gobike'),
      _SvcData('GoPrint', 'Impression', Icons.print_rounded, const Color(0xFFEC4899), 'assets/images/goride_hero.png', '/service/goprint'),
      _SvcData('GoEvent', 'Events', Icons.celebration_rounded, const Color(0xFFF43F5E), 'assets/images/goclean_hero.png', '/service/goevent'),
      _SvcData('GoShop', 'Shopping', Icons.shopping_bag_rounded, const Color(0xFF10B981), 'assets/images/gobike_hero.png', '/service/goshop'),
      _SvcData('GoSwap', 'Batterie', Icons.battery_charging_full_rounded, const Color(0xFF6366F1), 'assets/images/goride_hero.png', '/service/goswap'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.82,
        ),
        itemCount: services.length,
        itemBuilder: (_, i) => _ServiceTile(data: services[i]),
      ),
    );
  }

  // ─── ACTIVE ORDER ───
  Widget _buildActiveOrder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Go212Colors.primary200, width: 1.5),
          boxShadow: Go212Shadows.elevation2,
        ),
        child: Row(children: [
          ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.asset('assets/images/gowash_hero.png', width: 52, height: 52, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('GoWash · Extra', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Go212Colors.primary100, borderRadius: BorderRadius.circular(6)),
                child: Text('En cours', style: TextStyle(fontSize: 10, color: Go212Colors.primary700, fontWeight: FontWeight.w600))),
            ]),
            const SizedBox(height: 4),
            Text('Demain 14h · Berline', style: TextStyle(fontSize: 12, color: Go212Colors.neutral500)),
            const SizedBox(height: 8),
            ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: 0.4, backgroundColor: Go212Colors.neutral100, valueColor: AlwaysStoppedAnimation(Go212Colors.primary500), minHeight: 4)),
          ])),
        ]),
      ),
    );
  }

  // ─── TRUST BAR ───
  Widget _buildTrustBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF047857)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: const Color(0xFF059669).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(children: [
          _TrustCol(Icons.people_rounded, '5,000+', 'Utilisateurs'),
          _div(),
          _TrustCol(Icons.verified_rounded, '150+', 'Partenaires'),
          _div(),
          _TrustCol(Icons.shield_rounded, 'CMI', 'Sécurisé'),
        ]),
      ),
    );
  }

  Widget _div() => Container(width: 1, height: 36, color: Colors.white.withOpacity(0.2));

  // ─── SUPPORT ───
  Widget _buildSupportCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Go212Colors.primary50, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: Go212Colors.primary100, borderRadius: BorderRadius.circular(12)),
            child: Icon(Iconsax.message_question, size: 22, color: Go212Colors.primary600)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Besoin d\'aide ?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
            Text('Support 7j/7 · 9h à 22h', style: TextStyle(fontSize: 12, color: Go212Colors.neutral500)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Go212Colors.primary600, borderRadius: BorderRadius.circular(10)),
            child: Text('Chat', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }

  Widget _sectionHead(BuildContext context, String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Text(t, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
        const Spacer(),
        Text('Voir tout', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Go212Colors.primary600)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TOP BAR BUTTON
// ═══════════════════════════════════════════════════════════════
class _TopBtn extends StatelessWidget {
  final IconData icon;
  final int? badge;
  final VoidCallback? onTap;
  const _TopBtn({required this.icon, this.badge, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: Go212Colors.neutral100, borderRadius: BorderRadius.circular(12)),
        child: Stack(children: [
          Center(child: Icon(icon, size: 20, color: Go212Colors.neutral700)),
          if (badge != null)
            Positioned(right: 6, top: 6, child: Container(
              width: 14, height: 14,
              decoration: BoxDecoration(color: Go212Colors.error, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
              child: Center(child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700))),
            )),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// GLASS CHIP & CTA
// ═══════════════════════════════════════════════════════════════
class _GlassChip extends StatelessWidget {
  final String text;
  const _GlassChip(this.text);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Go212Colors.primary600.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ),
      ),
    );
  }
}

class _GlassCta extends StatelessWidget {
  final String label;
  const _GlassCta(this.label);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.3))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// POPULAR CARD — Real image with gradient
// ═══════════════════════════════════════════════════════════════
class _PopularCard extends StatefulWidget {
  final _PopService item;
  const _PopularCard({required this.item});
  @override
  State<_PopularCard> createState() => _PopularCardState();
}

class _PopularCardState extends State<_PopularCard> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 120)); _s = Tween(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)); }
  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final i = widget.item;
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) { _c.reverse(); Navigator.pushNamed(context, i.route); },
      onTapCancel: () => _c.reverse(),
      child: AnimatedBuilder(
        animation: _s,
        builder: (_, ch) => Transform.scale(scale: _s.value, child: ch),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: i.accent.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 8))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(i.img, fit: BoxFit.cover),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)]))),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Spacer(),
                  Text(i.name, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                    child: Text(i.price, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SERVICE TILE — Image background with icon overlay
// ═══════════════════════════════════════════════════════════════
class _ServiceTile extends StatefulWidget {
  final _SvcData data;
  const _ServiceTile({required this.data});
  @override
  State<_ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<_ServiceTile> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;
  @override void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 100)); _s = Tween(begin: 1.0, end: 0.92).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)); }
  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) { _c.reverse(); Navigator.pushNamed(context, d.route); },
      onTapCancel: () => _c.reverse(),
      child: AnimatedBuilder(
        animation: _s,
        builder: (_, ch) => Transform.scale(scale: _s.value, child: ch),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: d.color.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 5))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image background
                Image.asset(d.img, fit: BoxFit.cover),
                // Gradient overlay matching service color
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        d.color.withOpacity(0.3),
                        d.color.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon circle
                      Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(d.icon, size: 18, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(d.name, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, height: 1)),
                      const SizedBox(height: 2),
                      Text(d.sub, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.w500)),
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

// ─── Trust Column ───
class _TrustCol extends StatelessWidget {
  final IconData icon; final String val; final String label;
  const _TrustCol(this.icon, this.val, this.label);
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Icon(icon, color: Colors.white, size: 22),
      const SizedBox(height: 6),
      Text(val, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
    ]));
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA
// ═══════════════════════════════════════════════════════════════
class _PopService {
  final String name, price, img, route;
  final Color accent;
  const _PopService(this.name, this.price, this.img, this.route, this.accent);
}

class _SvcData {
  final String name, sub;
  final IconData icon;
  final Color color;
  final String img, route;
  const _SvcData(this.name, this.sub, this.icon, this.color, this.img, this.route);
}
