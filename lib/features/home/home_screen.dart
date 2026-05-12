import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/go212_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();
  late AnimationController _floatCtrl;
  late AnimationController _waveCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _float;
  late Animation<double> _wave;
  late Animation<double> _pulse;
  final PageController _adPage = PageController();
  Timer? _adTimer;
  int _adIndex = 0;
  double _scrollOffset = 0;
  Animation<double>? _routeAnimation;

  // Called every time this screen becomes the top route again (pop back)
  void _onRouteAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      if (_scroll.hasClients && _scroll.offset > 0) {
        _scroll.animateTo(0,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic);
      }
      setState(() => _scrollOffset = 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() => setState(() => _scrollOffset = _scroll.offset));

    _floatCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat(reverse: true);
    _float = Tween<double>(begin: -8, end: 8).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _waveCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _wave = Tween<double>(begin: -0.3, end: 0.3).animate(CurvedAnimation(parent: _waveCtrl, curve: Curves.easeInOut));

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.96, end: 1.04).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _adTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      _adIndex = (_adIndex + 1) % 3;
      if (_adPage.hasClients) _adPage.animateToPage(_adIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-subscribe each time dependencies change (e.g. route changes)
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    _routeAnimation = ModalRoute.of(context)?.animation;
    _routeAnimation?.addStatusListener(_onRouteAnimationStatus);
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    _scroll.dispose();
    _floatCtrl.dispose();
    _waveCtrl.dispose();
    _pulseCtrl.dispose();
    _adPage.dispose();
    _adTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background decoration
          Positioned(top: -80, right: -60, child: Container(width: 220, height: 220, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF22C55E).withOpacity(0.06)))),
          Positioned(top: 200, left: -100, child: Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF22C55E).withOpacity(0.04)))),

          CustomScrollView(
            controller: _scroll,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 0, floating: true, snap: true,
                backgroundColor: _scrollOffset > 20 ? Colors.white.withOpacity(0.97) : Colors.transparent,
                elevation: _scrollOffset > 20 ? 1 : 0,
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Row(children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF15803D), Color(0xFF22C55E)]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text('GO', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white))),
                  ),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text('GO212', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                    Row(children: [
                      const Icon(Iconsax.location, size: 11, color: Color(0xFF22C55E)),
                      const SizedBox(width: 3),
                      Text('Casablanca', style: GoogleFonts.nunito(fontSize: 11, color: Go212Colors.neutral500, fontWeight: FontWeight.w600)),
                    ]),
                  ]),
                  const Spacer(),
                  _IconBtn(icon: Iconsax.search_normal, onTap: () {}),
                  const SizedBox(width: 8),
                  _IconBtn(icon: Iconsax.notification, badge: 2, onTap: () {}),
                ]),
              ),

              SliverToBoxAdapter(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 8),
                  _buildHeroSection(),
                  const SizedBox(height: 28),
                  _buildServicesSection(context),
                  const SizedBox(height: 28),
                  _buildAdCarousel(),
                  const SizedBox(height: 28),
                  _buildBoostSection(),
                  const SizedBox(height: 28),
                  _buildTrustBar(),
                  const SizedBox(height: 100),
                ]),
              ),
            ],
          ),

          // ── GoBot FAB — sits just above the bottom nav bar ──
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 70,
            right: 20,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, child) => Transform.scale(
                scale: _pulse.value,
                alignment: Alignment.center,
                child: child,
              ),
              child: GestureDetector(
                onTap: () => _showGoBotSheet(context),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF15803D).withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(5),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/mascot.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0, right: 0,
                      child: Container(
                        width: 14, height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── HERO SECTION ──
  Widget _buildHeroSection() {
    final h = DateTime.now().hour;
    final greet = h < 12 ? 'Bonjour' : h < 18 ? 'Bon après-midi' : 'Bonsoir';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF0FDF4), Colors.white]),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.12)),
          boxShadow: [BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF22C55E).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('🇲🇦 Casablanca', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF15803D))),
              ),
              const SizedBox(height: 10),
              Text('$greet 👋', style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A), height: 1.2)),
              const SizedBox(height: 4),
              Text('Comment on peut t\'aider ?', style: GoogleFonts.nunito(fontSize: 14, color: Go212Colors.neutral500, fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(width: 8),
          AnimatedBuilder(
            animation: Listenable.merge([_floatCtrl, _waveCtrl]),
            builder: (_, __) => Transform.translate(
              offset: Offset(0, _float.value * 0.5),
              child: SizedBox(
                width: 110, height: 110,
                child: Stack(alignment: Alignment.center, children: [
                  Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF22C55E).withOpacity(0.08))),
                  Image.asset('assets/images/mascot.png', width: 100, height: 100, fit: BoxFit.contain),
                  Positioned(top: 0, right: 0, child: Transform.rotate(
                    angle: _wave.value, alignment: Alignment.bottomCenter,
                    child: const Text('👋', style: TextStyle(fontSize: 22)),
                  )),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // ── SERVICES ──
  Widget _buildServicesSection(BuildContext context) {
    final services = [
      _Svc('GoRide',  'Transport',  'assets/images/goride.png',   '/service/goride'),
      _Svc('GoBike',  'Vélo',       'assets/images/gobike.png',   '/service/gobike'),
      _Svc('GoWash',  'Lavage',     'assets/images/gowash.png',   '/service/gowash'),
      _Svc('GoShop',  'Shopping',   'assets/images/goshop.png',   '/service/goshop'),
      _Svc('GoFix',   'Réparation', 'assets/images/gofix.png',    '/service/gofix'),
      _Svc('GoClean', 'Ménage',     'assets/images/goclean.png',  '/service/goclean'),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Text('Nos Services', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
          const Spacer(),
          Text('Voir tout', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF22C55E))),
        ]),
      ),
      const SizedBox(height: 14),
      // 3-column grid — all 6 cards visible at once
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: services.length,
          itemBuilder: (_, i) => _ServiceCard(svc: services[i], delay: i),
        ),
      ),
    ]);
  }

  // ── AD CAROUSEL ──
  Widget _buildAdCarousel() {
    final ads = [
      _Ad('GoRide - Nouveau !', 'Scooter électrique dès 30 DH/h', 'assets/images/goride.png', const Color(0xFF15803D)),
      _Ad('GoWash Express', 'Lavage auto à domicile -20%', 'assets/images/gowash.png', const Color(0xFF0891B2)),
      _Ad('GoShop Promo', 'Livraison gratuite ce weekend !', 'assets/images/goshop.png', const Color(0xFF7C3AED)),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text('Offres & Promos', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
      ),
      const SizedBox(height: 14),
      SizedBox(
        height: 150,
        child: PageView.builder(
          controller: _adPage,
          itemCount: ads.length,
          onPageChanged: (i) => setState(() => _adIndex = i),
          itemBuilder: (_, i) {
            final ad = ads[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ad.color.withOpacity(0.15)),
                  boxShadow: [BoxShadow(color: ad.color.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Row(children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: ad.color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text('PROMO', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w800, color: ad.color)),
                      ),
                      const SizedBox(height: 8),
                      Text(ad.title, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      Text(ad.sub, style: GoogleFonts.nunito(fontSize: 12, color: Go212Colors.neutral500, fontWeight: FontWeight.w600)),
                    ]),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Image.asset(ad.img, width: 100, height: 100, fit: BoxFit.contain),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 10),
      // Dots
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(ads.length, (i) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: _adIndex == i ? 24 : 8, height: 8,
        decoration: BoxDecoration(
          color: _adIndex == i ? const Color(0xFF22C55E) : Go212Colors.neutral200,
          borderRadius: BorderRadius.circular(4),
        ),
      ))),
    ]);
  }

  // ── BOOST SECTION ──
  Widget _buildBoostSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF15803D), Color(0xFF22C55E)]),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('🇲🇦 100% Marocaine', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.8))),
            const SizedBox(height: 6),
            Text('All in One\nqui simplifie\nvotre quotidien', style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, height: 1.25)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Text('Découvrir →', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: const Color(0xFF15803D))),
            ),
          ])),
          AnimatedBuilder(
            animation: _float,
            builder: (_, __) => Transform.translate(
              offset: Offset(0, _float.value * 0.4),
              child: Image.asset('assets/images/mascot.png', width: 110, height: 110, fit: BoxFit.contain),
            ),
          ),
        ]),
      ),
    );
  }

  // ── GOBOT SHEET ──
  void _showGoBotSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Go212Colors.neutral200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header row
            Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: const Color(0xFF22C55E).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                padding: const EdgeInsets.all(4),
                child: ClipOval(
                  child: Image.asset('assets/images/mascot.png', fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('GoBot', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
                Text('Votre assistant GO212 · En ligne', style: GoogleFonts.nunito(fontSize: 12, color: Go212Colors.neutral500, fontWeight: FontWeight.w600)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('Actif', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF15803D))),
                ]),
              ),
            ]),
            const SizedBox(height: 20),
            // Chat bubble
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                constraints: const BoxConstraints(maxWidth: 260),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.15)),
                ),
                child: Text(
                  'Bonjour ! 👋 Je suis GoBot, comment puis-je vous aider aujourd\'hui ?',
                  style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A), height: 1.45),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Quick actions
            Text('Suggestions rapides', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Go212Colors.neutral500)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                _GoBotChip('🛵 Réserver GoRide'),
                _GoBotChip('🚗 GoWash près de moi'),
                _GoBotChip('🔧 GoFix devis'),
                _GoBotChip('🛒 GoShop promo'),
              ],
            ),
            const SizedBox(height: 20),
            // Input row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Go212Colors.neutral200),
              ),
              child: Row(children: [
                Expanded(child: Text('Écrire un message...', style: GoogleFonts.nunito(fontSize: 13, color: Go212Colors.neutral400, fontWeight: FontWeight.w500))),
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF15803D), Color(0xFF22C55E)]),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // ── TRUST BAR ──
  Widget _buildTrustBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.12)),
        ),
        child: Row(children: [
          _TrustItem(icon: Icons.people_rounded, val: '5,000+', label: 'Utilisateurs'),
          Container(width: 1, height: 36, color: const Color(0xFF22C55E).withOpacity(0.15)),
          _TrustItem(icon: Icons.verified_rounded, val: '150+', label: 'Partenaires'),
          Container(width: 1, height: 36, color: const Color(0xFF22C55E).withOpacity(0.15)),
          _TrustItem(icon: Icons.shield_rounded, val: 'CMI', label: 'Sécurisé'),
        ]),
      ),
    );
  }
}

// ── SERVICE CARD ──
class _ServiceCard extends StatefulWidget {
  final _Svc svc;
  final int delay;
  const _ServiceCard({required this.svc, required this.delay});
  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.6)));
    Future.delayed(Duration(milliseconds: 100 * widget.delay), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final s = widget.svc;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, s.route),
            child: Container(
              // No fixed width — fills the grid cell
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF22C55E).withOpacity(0.12),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  // Image — Expanded so it uses all available space proportionally
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.asset(
                        s.img,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s.name,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.sub,
                    style: GoogleFonts.nunito(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Go212Colors.neutral500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── ICON BUTTON ──
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final int? badge;
  final VoidCallback? onTap;
  const _IconBtn({required this.icon, this.badge, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
        child: Stack(children: [
          Center(child: Icon(icon, size: 20, color: const Color(0xFF334155))),
          if (badge != null) Positioned(right: 6, top: 6, child: Container(
            width: 14, height: 14,
            decoration: BoxDecoration(color: const Color(0xFFEF4444), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
            child: Center(child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700))),
          )),
        ]),
      ),
    );
  }
}

// ── TRUST ITEM ──
class _TrustItem extends StatelessWidget {
  final IconData icon; final String val; final String label;
  const _TrustItem({required this.icon, required this.val, required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Icon(icon, color: const Color(0xFF22C55E), size: 22),
      const SizedBox(height: 6),
      Text(val, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
      Text(label, style: GoogleFonts.nunito(fontSize: 10, color: Go212Colors.neutral500, fontWeight: FontWeight.w600)),
    ]));
  }
}

// ── DATA MODELS ──
class _Svc {
  final String name, sub, img, route;
  const _Svc(this.name, this.sub, this.img, this.route);
}

class _Ad {
  final String title, sub, img;
  final Color color;
  const _Ad(this.title, this.sub, this.img, this.color);
}

// ── GOBOT CHIP ──
class _GoBotChip extends StatelessWidget {
  final String label;
  const _GoBotChip(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF15803D)),
      ),
    );
  }
}
