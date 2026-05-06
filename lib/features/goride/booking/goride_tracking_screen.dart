// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_header.dart';

class GoRideTrackingScreen extends StatefulWidget {
  const GoRideTrackingScreen({super.key});
  @override
  State<GoRideTrackingScreen> createState() => _GoRideTrackingScreenState();
}

class _GoRideTrackingScreenState extends State<GoRideTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _motoCtrl;
  late Animation<double> _motoPos;
  late Timer _etaTimer;

  int _etaMinutes = 18;
  int _statusIndex = 0;
  bool _showReturnPanel = false;
  DateTime _returnDate = DateTime.now().add(const Duration(days: 3));

  final _rider = const _RiderInfo(
    name: 'Mohamed El Amrani',
    phone: '+212612345678',
    whatsapp: '+212612345678',
    motoPlate: '42-A-25',
    rating: 4.9,
    trips: 234,
  );

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _motoCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
    _motoPos = CurvedAnimation(parent: _motoCtrl, curve: Curves.easeInOut);

    // Phase 0: Searching for a rider (6 seconds)
    Timer(const Duration(seconds: 6), () {
      if (mounted) setState(() => _statusIndex = 1);
    });
    // Phase 1: Rider found, preparation (4s more)
    Timer(const Duration(seconds: 10), () {
      if (mounted) setState(() => _statusIndex = 2);
    });
    // Phase 2: En route -> delivered after 20s
    Timer(const Duration(seconds: 30), () {
      if (mounted)
        setState(() {
          _statusIndex = 3;
          _etaMinutes = 0;
        });
    });
    _etaTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted && _etaMinutes > 0) setState(() => _etaMinutes--);
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _motoCtrl.dispose();
    _etaTimer.cancel();
    super.dispose();
  }

  void _openUrl(String url) => debugPrint('Opening: $url');

  void _pickReturnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: Go212Colors.primary600),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) setState(() => _returnDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                _buildTopBar(context),
                if (_statusIndex >= 1) ...[
                  _buildStatusTimeline(),
                  Expanded(child: _buildMapArea()),
                  _buildRiderCard(booking),
                  _buildReturnCard(),
                ] else ...[
                  Expanded(child: _buildSearchingOverlay()),
                ],
                SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
          if (_showReturnPanel)
            _ReturnScheduleSheet(
              date: _returnDate,
              booking: booking,
              onClose: () => setState(() => _showReturnPanel = false),
              onPickDate: _pickReturnDate,
              onConfirm: () {
                setState(() => _showReturnPanel = false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Retour planifié le ${_returnDate.day}/${_returnDate.month}/${_returnDate.year}'),
                  backgroundColor: Go212Colors.primary600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ));
              },
            ),
        ],
      ),
    );
  }

  // ─── Searching overlay ─────────────────────────────────────────────
  Widget _buildSearchingOverlay() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF062E16),
            Color(0xFF14532D),
            Color(0xFF166534),
            Color(0xFF16A34A),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Driver icon with pulse rings ──
            AnimatedBuilder(
              animation: _pulseCtrl,
              builder: (_, __) => Stack(
                alignment: Alignment.center,
                children: [
                  // Outer pulse
                  Container(
                    width: 260 + _pulseCtrl.value * 30,
                    height: 260 + _pulseCtrl.value * 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white
                            .withOpacity(0.04 + _pulseCtrl.value * 0.06),
                        width: 1.5,
                      ),
                    ),
                  ),
                  // Middle pulse
                  Container(
                    width: 220 + _pulseCtrl.value * 15,
                    height: 220 + _pulseCtrl.value * 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white
                            .withOpacity(0.06 + _pulseCtrl.value * 0.08),
                        width: 1.5,
                      ),
                    ),
                  ),
                  // Inner glow
                  Container(
                    width: 185,
                    height: 185,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white
                              .withOpacity(0.04 + _pulseCtrl.value * 0.06),
                          blurRadius: 40,
                          spreadRadius: _pulseCtrl.value * 10,
                        ),
                      ],
                    ),
                  ),
                  // ── DRIVERapp.png icon ──
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: const Color(0xFF4ADE80).withOpacity(0.25),
                          blurRadius: 50,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Image.asset(
                        'assets/images/logodriver.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.white,
                          child: Icon(
                            Icons.two_wheeler_rounded,
                            size: 64,
                            color: Go212Colors.primary600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Online dot
                  Positioned(
                    bottom: 48,
                    right: 48,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4ADE80),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4ADE80).withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // ── Title ──
            const Text(
              'Connexion au réseau Driver',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Recherche du livreur le plus proche...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 28),
            // ── Animated scanning bar ──
            Container(
              width: 180,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white.withOpacity(0.15),
              ),
              child: AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) => FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.15 + _pulseCtrl.value * 0.7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF86EFAC), Colors.white],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top bar ──────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/goride/review'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Color(0xFF334155), size: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        _statusIndex == 0
                            ? 'Recherche en cours...'
                            : 'Suivi en direct',
                        style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    Text(
                        _statusIndex == 0
                            ? 'Connexion au réseau GO212'
                            : 'Moto N\u00b0 ${_rider.motoPlate}',
                        style: const TextStyle(
                            color: Color(0xFF64748B), fontSize: 12)),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) {
                  final isSearching = _statusIndex == 0;
                  final badgeColor = isSearching
                      ? const Color(0xFFF59E0B)
                      : Go212Colors.primary600;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: badgeColor
                          .withOpacity(0.08 + _pulseCtrl.value * 0.06),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: badgeColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                              color: badgeColor,
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(isSearching ? 'Recherche' : 'En direct',
                            style: TextStyle(
                                color: isSearching
                                    ? const Color(0xFFB45309)
                                    : Go212Colors.primary700,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Status timeline ──────────────────────────────────────────────
  Widget _buildStatusTimeline() {
    final statuses = [
      (Icons.search_rounded, 'Recherche', 'Recherche d\'un livreur...'),
      (Icons.build_circle_rounded, 'Préparation', 'Livreur trouvé !'),
      (Icons.two_wheeler_rounded, 'En route', 'Livraison en cours'),
      (Icons.check_circle_rounded, 'Livré', 'Moto à votre adresse'),
    ];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: List.generate(statuses.length, (i) {
          final done = i <= _statusIndex;
          final active = i == _statusIndex;
          final icon = statuses[i].$1;
          final label = statuses[i].$2;
          final sub = statuses[i].$3;
          return Expanded(
            child: Row(
              children: [
                Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.elasticOut,
                      width: active ? 38 : 32,
                      height: active ? 38 : 32,
                      decoration: BoxDecoration(
                        color: done
                            ? (active
                                ? Go212Colors.primary600
                                : Go212Colors.primary100)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: active
                            ? Border.all(
                                color: Go212Colors.primary300, width: 2.5)
                            : null,
                        boxShadow: active
                            ? [
                                BoxShadow(
                                    color:
                                        Go212Colors.primary600.withOpacity(0.3),
                                    blurRadius: 12)
                              ]
                            : null,
                      ),
                      child: Icon(icon,
                          size: active ? 18 : 15,
                          color: done
                              ? (active ? Colors.white : Go212Colors.primary600)
                              : const Color(0xFFCBD5E1)),
                    ),
                    const SizedBox(height: 5),
                    Text(label,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                active ? FontWeight.w800 : FontWeight.w500,
                            color: done
                                ? (active
                                    ? Go212Colors.primary700
                                    : Go212Colors.primary600)
                                : const Color(0xFF94A3B8))),
                    if (active) ...[
                      const SizedBox(height: 1),
                      Text(sub,
                          style: const TextStyle(
                              fontSize: 8.5, color: Color(0xFF64748B))),
                    ],
                  ],
                ),
                if (i < statuses.length - 1)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        height: 2.5,
                        decoration: BoxDecoration(
                          color: i < _statusIndex
                              ? Go212Colors.primary500
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ─── Map area ─────────────────────────────────────────────────────
  Widget _buildMapArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _LightMapPainter(),
            ),
            AnimatedBuilder(
              animation: _motoPos,
              builder: (_, __) {
                return LayoutBuilder(builder: (ctx, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;
                  final t = _motoPos.value;
                  final x = w * 0.1 + (w * 0.6) * t;
                  final y = h * 0.68 - math.sin(t * math.pi) * h * 0.32;
                  return Positioned(
                    left: x - 20,
                    top: y - 20,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Go212Colors.primary600,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Go212Colors.primary600.withOpacity(0.45),
                              blurRadius: 14,
                              spreadRadius: 2),
                        ],
                      ),
                      child: const GoRideMotoIcon(size: 26),
                    ),
                  );
                });
              },
            ),
            Positioned(
              right: 42,
              top: 28,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8)
                      ],
                    ),
                    child: const Text('Vous',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A))),
                  ),
                  const SizedBox(height: 3),
                  const Icon(Icons.location_pin,
                      color: Color(0xFFEF4444), size: 28),
                ],
              ),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.12), blurRadius: 12)
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_rounded,
                          color: Go212Colors.primary600, size: 15),
                      const SizedBox(width: 6),
                      Text(
                        _etaMinutes > 0
                            ? 'Arrivée dans $_etaMinutes min'
                            : '\u{1F389}  Votre moto est arrivée !',
                        style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Rider card ───────────────────────────────────────────────────
  Widget _buildRiderCard(GoRideBooking booking) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Go212Colors.primary600, Go212Colors.primary400]),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_rider.name,
                        style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFBBF24), size: 13),
                        const SizedBox(width: 3),
                        Text('${_rider.rating}',
                            style: const TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        const Text(' \u00b7 ',
                            style: TextStyle(color: Color(0xFFCBD5E1))),
                        Text('\u{1F6F5} ${_rider.motoPlate}',
                            style: const TextStyle(
                                color: Color(0xFF64748B), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8)),
                child: Text('${_rider.trips} courses',
                    style: TextStyle(
                        color: Go212Colors.primary700,
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child: _ContactBtn(
                      icon: Icons.call_rounded,
                      label: 'Appeler',
                      color: Go212Colors.primary600,
                      onTap: () => _openUrl('tel:${_rider.phone}'))),
              const SizedBox(width: 10),
              Expanded(
                  child: _ContactBtn(
                      icon: Icons.sms_rounded,
                      label: 'SMS',
                      color: const Color(0xFF3B82F6),
                      onTap: () => _openUrl('sms:${_rider.phone}'))),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Return card ──────────────────────────────────────────────────
  Widget _buildReturnCard() {
    return GestureDetector(
      onTap: () => setState(() => _showReturnPanel = true),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Go212Colors.primary600.withOpacity(0.04),
              Go212Colors.primary400.withOpacity(0.09),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: Go212Colors.primary600.withOpacity(0.2), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14)),
              child: Icon(Icons.assignment_return_rounded,
                  color: Go212Colors.primary600, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Planifier le retour',
                      style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 14,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Text(
                    'Retour prévu le ${_returnDate.day}/${_returnDate.month}/${_returnDate.year}',
                    style: TextStyle(
                        color: Go212Colors.primary600,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  const Text('Modifiez la date de retour de votre moto',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Go212Colors.primary500, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─── Return schedule bottom sheet overlay ─────────────────────────
class _ReturnScheduleSheet extends StatelessWidget {
  final DateTime date;
  final GoRideBooking booking;
  final VoidCallback onClose;
  final VoidCallback onPickDate;
  final VoidCallback onConfirm;

  const _ReturnScheduleSheet({
    required this.date,
    required this.booking,
    required this.onClose,
    required this.onPickDate,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.45),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.assignment_return_rounded,
                            color: Go212Colors.primary600, size: 22),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Retour de la moto',
                                style: TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800)),
                            Text('Planifiez la restitution du véhicule',
                                style: TextStyle(
                                    color: Color(0xFF64748B), fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  GestureDetector(
                    onTap: onPickDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              color: Go212Colors.primary600, size: 20),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date de retour',
                                  style: TextStyle(
                                      color: Color(0xFF64748B), fontSize: 11)),
                              Text('${date.day}/${date.month}/${date.year}',
                                  style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Go212Colors.primary50,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text('Modifier',
                                style: TextStyle(
                                    color: Go212Colors.primary600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            color: Color(0xFFEF4444), size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lieu de retour',
                                  style: TextStyle(
                                      color: Color(0xFF64748B), fontSize: 11)),
                              Text('Agence GO212 \u2014 611, Rue Goulmima',
                                  style: TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFED7AA)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: Color(0xFFF59E0B), size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                              'Tout retard sera facturé 50 DH/h supplémentaire.',
                              style: TextStyle(
                                  color: Color(0xFF92400E), fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Go212Colors.primary700,
                          Go212Colors.primary500
                        ]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Go212Colors.primary600.withOpacity(0.3),
                              blurRadius: 14,
                              offset: const Offset(0, 5)),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text('Confirmer le retour',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Enhanced map painter ────────────────────────────────────────────
class _LightMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = const Color(0xFFF0F4F0));

    // Subtle grid (terrain texture)
    final gridPaint = Paint()
      ..color = const Color(0xFFD4E4D4).withOpacity(0.4)
      ..strokeWidth = 0.5;
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Park areas (green zones)
    final parkPaint = Paint()..color = const Color(0xFFD5F5E3).withOpacity(0.6);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.02, size.height * 0.58,
                size.width * 0.18, size.height * 0.35),
            const Radius.circular(12)),
        parkPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.72, size.height * 0.02,
                size.width * 0.26, size.height * 0.22),
            const Radius.circular(12)),
        parkPaint);

    // Tree dots in parks
    final treePaint = Paint()..color = const Color(0xFF86EFAC).withOpacity(0.6);
    for (final pos in [
      Offset(size.width * 0.06, size.height * 0.65),
      Offset(size.width * 0.14, size.height * 0.72),
      Offset(size.width * 0.08, size.height * 0.82),
      Offset(size.width * 0.16, size.height * 0.85),
      Offset(size.width * 0.78, size.height * 0.08),
      Offset(size.width * 0.88, size.height * 0.14),
      Offset(size.width * 0.82, size.height * 0.18),
    ]) {
      canvas.drawCircle(pos, 5, treePaint);
    }

    // Main roads
    final mainRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    final sideRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Horizontal main
    canvas.drawLine(Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5), mainRoad);
    // Vertical main
    canvas.drawLine(Offset(size.width * 0.42, 0),
        Offset(size.width * 0.42, size.height), mainRoad);
    // Secondary roads
    canvas.drawLine(Offset(0, size.height * 0.25),
        Offset(size.width, size.height * 0.25), sideRoad);
    canvas.drawLine(Offset(0, size.height * 0.78),
        Offset(size.width, size.height * 0.78), sideRoad);
    canvas.drawLine(Offset(size.width * 0.7, 0),
        Offset(size.width * 0.7, size.height), sideRoad);
    canvas.drawLine(Offset(size.width * 0.22, 0),
        Offset(size.width * 0.22, size.height), sideRoad);

    // Road center dashes (main horizontal)
    final dashPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (double x = 0; x < size.width; x += 16) {
      canvas.drawLine(
          Offset(x, size.height * 0.5), Offset(x + 8, size.height * 0.5), dashPaint);
    }

    // Building blocks with slight shadow
    final buildingPaint = Paint()..color = const Color(0xFFD1DED3);
    final buildingShadow = Paint()..color = const Color(0xFFC2D5C5).withOpacity(0.5);
    final buildings = [
      Rect.fromLTWH(size.width * 0.24, size.height * 0.04, size.width * 0.15, size.height * 0.18),
      Rect.fromLTWH(size.width * 0.46, size.height * 0.04, size.width * 0.2, size.height * 0.18),
      Rect.fromLTWH(size.width * 0.24, size.height * 0.29, size.width * 0.15, size.height * 0.18),
      Rect.fromLTWH(size.width * 0.46, size.height * 0.29, size.width * 0.2, size.height * 0.18),
      Rect.fromLTWH(size.width * 0.74, size.height * 0.29, size.width * 0.22, size.height * 0.18),
      Rect.fromLTWH(size.width * 0.46, size.height * 0.55, size.width * 0.2, size.height * 0.2),
      Rect.fromLTWH(size.width * 0.74, size.height * 0.55, size.width * 0.22, size.height * 0.2),
    ];
    for (final r in buildings) {
      // shadow offset
      canvas.drawRRect(
          RRect.fromRectAndRadius(r.shift(const Offset(2, 2)), const Radius.circular(6)),
          buildingShadow);
      canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(6)), buildingPaint);
    }

    // Route line (path from rider to client)
    final routePath = Path()
      ..moveTo(size.width * 0.08, size.height * 0.75)
      ..cubicTo(size.width * 0.22, size.height * 0.50, size.width * 0.42,
          size.height * 0.50, size.width * 0.55, size.height * 0.25)
      ..cubicTo(size.width * 0.62, size.height * 0.15, size.width * 0.70,
          size.height * 0.12, size.width * 0.78, size.height * 0.18);

    // Route shadow
    canvas.drawPath(
        routePath,
        Paint()
          ..color = const Color(0xFF16A34A).withOpacity(0.15)
          ..strokeWidth = 12
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);

    // Route dashed line
    final routeDash = Paint()
      ..color = const Color(0xFF16A34A)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final metrics = routePath.computeMetrics();
    for (final metric in metrics) {
      double dist = 0;
      while (dist < metric.length) {
        final end = (dist + 10).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(dist, end), routeDash);
        dist += 18;
      }
    }
  }

  @override
  bool shouldRepaint(_LightMapPainter old) => false;
}

// ─── Contact button ───────────────────────────────────────────────
class _ContactBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ContactBtn(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ─── Rider info model ─────────────────────────────────────────────
class _RiderInfo {
  final String name, phone, whatsapp, motoPlate;
  final double rating;
  final int trips;
  const _RiderInfo(
      {required this.name,
      required this.phone,
      required this.whatsapp,
      required this.motoPlate,
      required this.rating,
      required this.trips});
}

// ─── Status chip for search overlay ───────────────────────────────
class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _StatusChip(
      {required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFF0FDF4)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? const Color(0xFF86EFAC)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: isActive
                  ? const Color(0xFF16A34A)
                  : const Color(0xFF94A3B8)),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? const Color(0xFF15803D)
                      : const Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}
