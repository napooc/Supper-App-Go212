import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gobike_pricing_data.dart';

class GoBikeGroupReservationScreen extends StatefulWidget {
  const GoBikeGroupReservationScreen({super.key});

  @override
  State<GoBikeGroupReservationScreen> createState() =>
      _GoBikeGroupReservationScreenState();
}

class _GoBikeGroupReservationScreenState
    extends State<GoBikeGroupReservationScreen> with TickerProviderStateMixin {
  int _bikeCount = 2;
  final int _maxBikes = 10;

  late final AnimationController _pulseCtrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 3))
        ..repeat(reverse: true);
  late final AnimationController _bounceCtrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  late final AnimationController _floatCtrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))
        ..repeat(reverse: true);
  late final AnimationController _entryCtrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
        ..forward();

  late final Animation<double> _pulseAnim =
      Tween<double>(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  late final Animation<double> _bounceAnim =
      Tween<double>(begin: 1.0, end: 1.3).animate(
          CurvedAnimation(parent: _bounceCtrl, curve: Curves.elasticOut));
  late final Animation<double> _floatAnim =
      Tween<double>(begin: -6.0, end: 6.0).animate(
          CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  late final Animation<double> _entryAnim =
      Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutBack));

  static const _green = Color(0xFF00C853);
  static const _darkGreen = Color(0xFF065F46);
  static const _bg = Color(0xFF0A1628);

  // ── All pricing via singleton (set by duration screen) ────────────────────
  int get _groupTotal => GoBikePricingData.current
      .groupHint(_bikeCount).contains('DH')
          ? GoBikePricingData(  // preview with current bike count
              durationIndex: GoBikePricingData.current.durationIndex,
              quantity: GoBikePricingData.current.quantity,
              bikeCount: _bikeCount,
            ).rentalTotal
          : 0;

  String get _priceHint =>
      GoBikePricingData.current.groupHint(_bikeCount);

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _bounceCtrl.dispose();
    _floatCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  void _set(int n) {
    if (n < 1 || n > _maxBikes) return;
    HapticFeedback.lightImpact();
    setState(() => _bikeCount = n);
    _bounceCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: AnimatedBuilder(
        animation: _entryAnim,
        builder: (_, child) => Opacity(
          opacity: _entryAnim.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _entryAnim.value)),
            child: child,
          ),
        ),
        child: Stack(
          children: [
            // Background orbs
            AnimatedBuilder(
              animation: _floatAnim,
              builder: (_, __) => Stack(children: [
                Positioned(top: 60 + _floatAnim.value, right: -50,
                    child: _Orb(200, _green.withOpacity(0.07))),
                Positioned(bottom: 200 - _floatAnim.value, left: -60,
                    child: _Orb(160, const Color(0xFF16A34A).withOpacity(0.05))),
              ]),
            ),

            SafeArea(
              child: Column(
                children: [
                  _header(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 28),
                          _counterHero(),
                          const SizedBox(height: 32),
                          _bikeGrid(),
                          const SizedBox(height: 28),
                          _quickPick(),
                          const SizedBox(height: 28),
                          _infoCard(),
                          const SizedBox(height: 28),
                          _ctaButton(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
    child: Row(children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('GoBike · Groupe', style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w500)),
          Text('Nombre de vélos', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_darkGreen, _green]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('3 / 7', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
      ),
    ]),
  );

  Widget _counterHero() {
    return GestureDetector(
      onVerticalDragUpdate: (d) {
        if (d.delta.dy < -8) _set(_bikeCount + 1);
        if (d.delta.dy > 8) _set(_bikeCount - 1);
      },
      child: Column(children: [
        Text('Combien de vélos ?',
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13, letterSpacing: 1.2)),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: Listenable.merge([_pulseAnim, _bounceAnim]),
          builder: (_, __) => Stack(alignment: Alignment.center, children: [
            // Glow ring
            Transform.scale(
              scale: _pulseAnim.value,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    _green.withOpacity(0.18),
                    _green.withOpacity(0.0),
                  ]),
                ),
              ),
            ),
            // Border ring
            Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _green.withOpacity(0.3), width: 1.5),
              ),
            ),
            // Number
            Transform.scale(
              scale: _bounceAnim.value,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (c, a) => ScaleTransition(
                    scale: a, child: FadeTransition(opacity: a, child: c)),
                child: Text(
                  '$_bikeCount',
                  key: ValueKey(_bikeCount),
                  style: GoogleFonts.nunito(fontSize: 100, fontWeight: FontWeight.w900,
                      color: Colors.white, height: 1),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            '$_bikeCount vélo${_bikeCount > 1 ? 's' : ''} · ${_bikeCount == 1 ? 'Solo' : 'Groupe'}',
            key: ValueKey(_bikeCount),
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 20),
        // +/- row
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _roundBtn(Icons.remove_rounded, _bikeCount > 1, () => _set(_bikeCount - 1)),
          const SizedBox(width: 36),
          _roundBtn(Icons.add_rounded, _bikeCount < _maxBikes, () => _set(_bikeCount + 1)),
        ]),
        const SizedBox(height: 8),
        Text('↕  Glissez le cercle pour changer',
            style: GoogleFonts.poppins(color: Colors.white24, fontSize: 10)),
      ]),
    );
  }

  Widget _roundBtn(IconData icon, bool enabled, VoidCallback onTap) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 58, height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: enabled
              ? const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [_green, _darkGreen])
              : null,
          color: enabled ? null : Colors.white.withOpacity(0.06),
          boxShadow: enabled
              ? [BoxShadow(color: _green.withOpacity(0.4), blurRadius: 18, offset: const Offset(0, 5))]
              : [],
        ),
        child: Icon(icon, color: enabled ? Colors.white : Colors.white24, size: 26),
      ),
    );
  }

  Widget _bikeGrid() {
    return Column(children: [
      // Animated bike icons (2 rows of 5)
      ...List.generate(2, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (col) {
              final idx = row * 5 + col;
              final active = idx < _bikeCount;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: () => _set(idx + 1),
                  child: AnimatedBuilder(
                    animation: _floatAnim,
                    builder: (_, __) {
                      final offset = active
                          ? math.sin((_floatAnim.value / 6) + idx * 0.7) * 4.0
                          : 0.0;
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOutBack,
                          width: active ? 46 : 38,
                          height: active ? 46 : 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: active
                                ? const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFFA3E635), _green])
                                : null,
                            color: active ? null : Colors.white.withOpacity(0.06),
                            border: Border.all(
                              color: active ? Colors.transparent : Colors.white.withOpacity(0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: active ? _green.withOpacity(0.5) : Colors.transparent,
                                blurRadius: 12,
                                spreadRadius: active ? 1 : 0,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.pedal_bike_rounded,
                            size: active ? 22 : 18,
                            color: active ? Colors.white : Colors.white24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        );
      }),
      const SizedBox(height: 12),
      // Progress bar
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: _bikeCount / _maxBikes,
          backgroundColor: Colors.white.withOpacity(0.08),
          valueColor: const AlwaysStoppedAnimation<Color>(_green),
          minHeight: 5,
        ),
      ),
      const SizedBox(height: 6),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('1 min', style: GoogleFonts.poppins(color: Colors.white24, fontSize: 10)),
        Text('$_bikeCount / $_maxBikes vélos', style: GoogleFonts.poppins(color: _green, fontSize: 11, fontWeight: FontWeight.w700)),
        Text('10 max', style: GoogleFonts.poppins(color: Colors.white24, fontSize: 10)),
      ]),
    ]);
  }

  Widget _quickPick() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('SÉLECTION RAPIDE', style: GoogleFonts.poppins(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
      const SizedBox(height: 12),
      Row(
        children: List.generate(10, (i) {
          final n = i + 1;
          final sel = n == _bikeCount;
          return Expanded(
            child: GestureDetector(
              onTap: () => _set(n),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: sel ? const LinearGradient(colors: [_green, _darkGreen]) : null,
                  color: sel ? null : Colors.white.withOpacity(0.06),
                  border: Border.all(color: sel ? Colors.transparent : Colors.white.withOpacity(0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: sel ? _green.withOpacity(0.35) : Colors.transparent,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text('$n',
                      style: GoogleFonts.nunito(
                          fontSize: sel ? 16 : 13,
                          fontWeight: FontWeight.w900,
                          color: sel ? Colors.white : Colors.white38)),
                ),
              ),
            ),
          );
        }),
      ),
    ]);
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(children: [
        _infoRow(Icons.local_offer_outlined, _priceHint, const Color(0xFFFBBF24)),
        const SizedBox(height: 12),
        _infoRow(Icons.verified_outlined, 'Vélos vérifiés · prêts à rouler', const Color(0xFF60A5FA)),
        const SizedBox(height: 12),
        _infoRow(Icons.group_outlined, '1 vélo = 1 personne · guidon inclus', const Color(0xFFA78BFA)),
      ]),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 16),
      ),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500))),
    ]);
  }

  Widget _ctaButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        // ✅ Update singleton with selected bike count — pricing stays consistent
        GoBikePricingData.updateBikeCount(_bikeCount);
        Navigator.pushNamed(context, '/service/gobike/customize');
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFA3E635), _green, _darkGreen],
            stops: [0.0, 0.5, 1.0],
          ),
          boxShadow: [BoxShadow(color: _green.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 10))],
        ),
        child: Row(children: [
          const SizedBox(width: 24),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Continuer avec $_bikeCount vélo${_bikeCount > 1 ? 's' : ''}',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(_priceHint, key: ValueKey(_bikeCount),
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10)),
              ),
            ]),
          ),
          Container(
            width: 44, height: 44,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
          ),
        ]),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb(this.size, this.color);
  @override
  Widget build(BuildContext context) =>
      Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}
