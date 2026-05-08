const fs = require('fs');
const base = 'C:/Users/HP ElieBook/Desktop/goo212/Supper-App-Go212/lib';

// Helper: write + log
function write(rel, content) {
  const full = base + '/' + rel;
  fs.writeFileSync(full, content, 'utf8');
  console.log('Written: ' + rel.split('/').pop());
}

// ════════════════════════════════════════════════════════
// 1. TRANSITION SCREEN — vidéo + mascot overlays
// ════════════════════════════════════════════════════════
write('features/goride/transition/goride_transition_screen.dart', `
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../models/goride_booking_model.dart';

class GoRideTransitionScreen extends StatefulWidget {
  const GoRideTransitionScreen({super.key});

  @override
  State<GoRideTransitionScreen> createState() => _GoRideTransitionScreenState();
}

class _GoRideTransitionScreenState extends State<GoRideTransitionScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeOut;
  bool _initialized = false;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeOut = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn));
    _initVideo();
  }

  Future<void> _initVideo() async {
    _videoCtrl = VideoPlayerController.asset('assets/video/Transition.mp4');
    try {
      await _videoCtrl.initialize();
      if (mounted) {
        setState(() => _initialized = true);
        _videoCtrl.setVolume(0.0);
        _videoCtrl.play();
        _videoCtrl.addListener(_checkVideoEnd);
      }
    } catch (e) {
      if (mounted) {
        await Future.delayed(const Duration(seconds: 2));
        _goToBooking(null);
      }
    }
  }

  void _checkVideoEnd() {
    if (!mounted || _navigating) return;
    final pos = _videoCtrl.value.position;
    final dur = _videoCtrl.value.duration;
    if (dur > Duration.zero && pos >= dur - const Duration(milliseconds: 200)) {
      _goToBooking(null);
    }
  }

  void _goToBooking(GoRideBooking? booking) {
    if (_navigating) return;
    _navigating = true;
    _fadeCtrl.forward().then((_) {
      if (mounted) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/goride/booking/persons',
          (route) => route.settings.name == '/main',
        );
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _videoCtrl.removeListener(_checkVideoEnd);
    _videoCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeOut,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video background ──
            if (_initialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoCtrl.value.size.width == 0
                      ? 1
                      : _videoCtrl.value.size.width,
                  height: _videoCtrl.value.size.height == 0
                      ? 1
                      : _videoCtrl.value.size.height,
                  child: VideoPlayer(_videoCtrl),
                ),
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0D3D26), Color(0xFF16A34A)],
                  ),
                ),
              ),
            // ── Dark overlay for readability ──
            // ignore: deprecated_member_use
            Container(color: Colors.black.withOpacity(0.18)),
            // ── Mascots bottom-center ──
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/mascot.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // ── Skip button ──
            Positioned(
              bottom: 24,
              right: 24,
              child: GestureDetector(
                onTap: () => _goToBooking(null),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.4)),
                  ),
                  child: const Text(
                    'Passer →',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
`.trim());

// ════════════════════════════════════════════════════════
// 2. DURATION SCREEN — cartes 2×2 carrées
// ════════════════════════════════════════════════════════
write('features/goride/booking/goride_duration_screen.dart', `
import 'package:flutter/material.dart';
import '../models/goride_booking_model.dart';
import 'goride_booking_shell.dart';

class GoRideDurationScreen extends StatefulWidget {
  const GoRideDurationScreen({super.key});
  @override
  State<GoRideDurationScreen> createState() => _GoRideDurationScreenState();
}

class _GoRideDurationScreenState extends State<GoRideDurationScreen>
    with SingleTickerProviderStateMixin {
  String? _selected;
  late AnimationController _anim;
  late Animation<double> _fade;

  static const _items = [
    _DItem('heure',  '⚡', 'À l\\'heure',  '30 DH',  '/h',    Color(0xFF3B82F6), ''),
    _DItem('jour',   '☀️', 'Journée',      '150 DH', '/j',    Color(0xFFF59E0B), 'POPULAIRE'),
    _DItem('semaine','🌟', 'Semaine',      '800 DH', '/sem',  Color(0xFF8B5CF6), 'TOP'),
    _DItem('mois',   '💎', 'Mois',         '2 500',  'DH/mois',Color(0xFF10B981), 'PROMO'),
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)?.settings.arguments as GoRideBooking?
        ?? const GoRideBooking();
    return GoRideBookingShell(
      step: 2,
      totalSteps: 6,
      title: 'Quelle durée ?',
      subtitle: 'Choisissez votre formule',
      child: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.0,
              children: _items.map((item) => _DurCard(
                item: item,
                isSelected: _selected == item.key,
                onTap: () => setState(() => _selected = item.key),
              )).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      onNext: _selected != null
          ? () => Navigator.pushNamed(context, '/goride/booking/details',
              arguments: booking.copyWith(duration: _selected))
          : null,
    );
  }
}

class _DurCard extends StatelessWidget {
  final _DItem item;
  final bool isSelected;
  final VoidCallback onTap;
  const _DurCard({required this.item, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [item.color, item.color.withValues(alpha: 0.75)],
                )
              : const LinearGradient(colors: [Colors.white, Colors.white]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? item.color : const Color(0xFFE2E8F0),
            width: isSelected ? 0 : 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: item.color.withValues(alpha: 0.30), blurRadius: 18, offset: const Offset(0, 6))]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: emoji + badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 26)),
                  if (item.badge.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : item.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.badge,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : item.color,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              // Label
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              // Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.price,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.white : item.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2, left: 3),
                    child: Text(
                      item.unit,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.75)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
              // Check
              if (isSelected) ...[
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, size: 13, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DItem {
  final String key, emoji, label, price, unit, badge;
  final Color color;
  const _DItem(this.key, this.emoji, this.label, this.price, this.unit, this.color, this.badge);
}
`.trim());

// ════════════════════════════════════════════════════════
// 3. DELIVERY SCREEN — icônes améliorées, moins de texte
// ════════════════════════════════════════════════════════
write('features/goride/booking/goride_delivery_screen.dart', `
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_btn.dart';
import '../widgets/zellige_header.dart';

class GoRideDeliveryScreen extends StatefulWidget {
  const GoRideDeliveryScreen({super.key});
  @override
  State<GoRideDeliveryScreen> createState() => _GoRideDeliveryScreenState();
}

class _GoRideDeliveryScreenState extends State<GoRideDeliveryScreen>
    with SingleTickerProviderStateMixin {
  String? _selected;
  late AnimationController _anim;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final booking = ModalRoute.of(context)?.settings.arguments as GoRideBooking?
        ?? const GoRideBooking();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildCard(
                      key: 'livraison',
                      icon: Icons.electric_moped_rounded,
                      emoji: '🏍️',
                      title: 'Livraison à domicile',
                      sub: '30–45 min · Zone Casa',
                      badge: 'Recommandé',
                      badgeColor: Go212Colors.primary600,
                      color: Go212Colors.primary600,
                    ),
                    const SizedBox(height: 14),
                    _buildCard(
                      key: 'agence',
                      icon: Icons.storefront_rounded,
                      emoji: '🏪',
                      title: 'Retrait en agence',
                      sub: '611, Rue Goulmima, Bourgogne',
                      badge: 'Gratuit',
                      badgeColor: const Color(0xFF8B5CF6),
                      color: const Color(0xFF8B5CF6),
                    ),
                    const SizedBox(height: 20),
                    if (_selected == 'agence') _buildAgenceBanner(),
                    if (_selected == 'livraison') _buildLivraisonBanner(),
                  ],
                ),
              ),
            ),
          ),
          _buildFooter(context, booking),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ZelligeHeader(
      gradientColors: const [Color(0xFF0D3D26), Color(0xFF166534), Color(0xFF16A34A)],
      patternOpacity: 0.08,
      tileSize: 28.0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        border: Border.all(color: Colors.white.withOpacity(0.25)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const Spacer(),
                  const MotoMascotBadge(size: 36),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('4 / 6',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Comment recevoir\\nla moto ?',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
              const SizedBox(height: 4),
              Text('Livraison ou retrait en agence',
                  // ignore: deprecated_member_use
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String key,
    required IconData icon,
    required String emoji,
    required String title,
    required String sub,
    required String badge,
    required Color badgeColor,
    required Color color,
  }) {
    final isSelected = _selected == key;
    return GestureDetector(
      onTap: () => setState(() => _selected = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: isSelected ? color.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              // ignore: deprecated_member_use
              ? [BoxShadow(color: color.withOpacity(0.14), blurRadius: 16, offset: const Offset(0, 6))]
              // ignore: deprecated_member_use
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            // Big emoji icon
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(isSelected ? 0.12 : 0.07),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 28)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(title,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: badgeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(badge,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: badgeColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(sub,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? color : const Color(0xFFCBD5E1), width: 2),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgenceBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: const Row(
        children: [
          Text('🗺️', style: TextStyle(fontSize: 22)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('611, Rue Goulmima', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4C1D95))),
                Text('Bourgogne · Casablanca · Lun-Sam 8h-20h', style: TextStyle(fontSize: 11, color: Color(0xFF6D28D9))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivraisonBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: const Row(
        children: [
          Text('⏱️', style: TextStyle(fontSize: 22)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Livraison rapide', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF166534))),
                Text('30–45 min · Assurance incluse · Casablanca', style: TextStyle(fontSize: 11, color: Color(0xFF4B7A5A))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, GoRideBooking booking) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: Colors.white,
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: GoRideBtn(
        label: 'Continuer',
        onTap: _selected != null
            ? () {
                final updated = booking.copyWith(deliveryType: _selected);
                if (_selected == 'agence') {
                  Navigator.pushNamed(context, '/goride/booking/agence', arguments: updated);
                } else {
                  Navigator.pushNamed(context, '/goride/booking/summary', arguments: updated);
                }
              }
            : null,
      ),
    );
  }
}
`.trim());

// ════════════════════════════════════════════════════════
// 4. KYC SCAN — ZelligeHeader vert foncé
// ════════════════════════════════════════════════════════
const kycScanOld = fs.readFileSync(
  base + '/features/goride/kyc/kyc_scan_screen.dart', 'utf8'
);
// Replace header method and add import
let kycScan = kycScanOld;
if (!kycScan.includes("import '../widgets/zellige_header.dart'")) {
  kycScan = kycScan.replace(
    "import '../widgets/goride_btn.dart';",
    "import '../widgets/goride_btn.dart';\nimport '../widgets/zellige_header.dart';"
  );
}
kycScan = kycScan.replace(
  `  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15803D), Color(0xFF22C55E)],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Scan de la CIN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      Text('Étape 2 — Caméra uniquement',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('2 / 5',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: KycProgressBar(currentStep: 2, totalSteps: 5),
          ),
        ],
      ),
    );
  }`,
  `  Widget _buildHeader(BuildContext context) {
    return ZelligeHeader(
      gradientColors: const [Color(0xFF0D3D26), Color(0xFF166534), Color(0xFF16A34A)],
      patternOpacity: 0.08,
      tileSize: 28.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 44, 20, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      // ignore: deprecated_member_use
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text('Scan de la CIN',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const MotoMascotBadge(size: 34),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('2 / 5',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: KycProgressBar(currentStep: 2, totalSteps: 5),
          ),
        ],
      ),
    );
  }`
);
write('features/goride/kyc/kyc_scan_screen.dart', kycScan);

// ════════════════════════════════════════════════════════
// 5. KYC SELFIE — read and patch header
// ════════════════════════════════════════════════════════
const kycSelfieRaw = fs.readFileSync(base + '/features/goride/kyc/kyc_selfie_screen.dart', 'utf8');
let kycSelfie = kycSelfieRaw;
if (!kycSelfie.includes("import '../widgets/zellige_header.dart'")) {
  kycSelfie = kycSelfie.replace(
    "import '../widgets/goride_btn.dart';",
    "import '../widgets/goride_btn.dart';\nimport '../widgets/zellige_header.dart';"
  );
}
// Replace old header gradient with ZelligeHeader (find Container gradient pattern)
kycSelfie = kycSelfie.replace(
  /Widget _buildHeader\(BuildContext context\) \{[\s\S]*?return Container\(\s*decoration: const BoxDecoration\(\s*gradient: LinearGradient\(\s*begin: Alignment\.topLeft,\s*end: Alignment\.bottomRight,\s*colors: \[Color\(0xFF15803D\), Color\(0xFF22C55E\)\],\s*\),\s*\),[\s\S]*?(?=\s*Widget _build)/,
  `Widget _buildHeader(BuildContext context) {
    return ZelligeHeader(
      gradientColors: const [Color(0xFF0D3D26), Color(0xFF166534), Color(0xFF16A34A)],
      patternOpacity: 0.08,
      tileSize: 28.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 44, 20, 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      // ignore: deprecated_member_use
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text('Selfie de vérification',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ),
                const MotoMascotBadge(size: 34),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('3 / 5',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: KycProgressBar(currentStep: 3, totalSteps: 5),
          ),
        ],
      ),
    );
  }

  `
);
write('features/goride/kyc/kyc_selfie_screen.dart', kycSelfie);

console.log('Batch 1 done (transition, duration, delivery, kyc scan+selfie)');
