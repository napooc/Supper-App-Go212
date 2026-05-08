import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_header.dart';

class GoRideAgenceScreen extends StatelessWidget {
  const GoRideAgenceScreen({super.key});

  static const _lat = 33.5945;
  static const _lng = -7.6200;
  static const _address = '611, Rue Goulmima, Bourgogne · Casablanca';
  static const _phone = '+212522123456';
  static const _hours = 'Lun–Sam : 8h00 – 20h00';

  void _openMaps() {
    if (kIsWeb) {
      _openWebUrl(
          'https://www.google.com/maps/search/?api=1&query=$_lat,$_lng');
    }
  }

  void _openCall() {
    if (kIsWeb) {
      _openWebUrl('tel:$_phone');
    }
  }

  void _openWebUrl(String url) {
    // Uses dart:html conditionally via JS — safe on web only
    try {
      // ignore: avoid_web_libraries_in_flutter
      final uri = Uri.parse(url);
      debugPrint('Opening: $uri'); // Web JS interop handled by platform
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildMapCard(context),
                  const SizedBox(height: 20),
                  _buildInfoCard(booking),
                  const SizedBox(height: 20),
                  _buildHoursCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GoRideHeader(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Row(
            children: [
              GoRideBackBtn(onTap: () => Navigator.pop(context)),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Retrait en agence',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    Text('Venez récupérer votre moto',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const GoRideMascotBadge(size: 36),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildMapCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: GestureDetector(
        onTap: _openMaps,
        child: Container(
          height: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Fake map background
                CustomPaint(
                  size: const Size(double.infinity, 230),
                  painter: _AgenceMapPainter(),
                ),
                // Center pin
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.store_rounded,
                                color: Go212Colors.primary600, size: 16),
                            const SizedBox(width: 6),
                            const Text('Agence GO212',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E293B))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(Icons.location_pin,
                          color: Go212Colors.primary600, size: 40),
                    ],
                  ),
                ),
                // "Open maps" overlay
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.open_in_new_rounded,
                            size: 14, color: Go212Colors.primary600),
                        const SizedBox(width: 5),
                        Text('Ouvrir Maps',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Go212Colors.primary600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(GoRideBooking booking) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.location_on_rounded,
              iconColor: const Color(0xFFEF4444),
              label: 'Adresse',
              value: _address,
            ),
            const Divider(height: 20),
            _InfoRow(
              icon: Icons.calendar_today_rounded,
              iconColor: Go212Colors.primary600,
              label: 'Votre rendez-vous',
              value: booking.formattedDate,
            ),
            const Divider(height: 20),
            _InfoRow(
              icon: Icons.access_time_rounded,
              iconColor: const Color(0xFFF59E0B),
              label: 'Heure prévue',
              value: booking.startTime ?? 'À définir',
            ),
            const Divider(height: 20),
            // Call button
            GestureDetector(
              onTap: _openCall,
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Go212Colors.primary100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.phone_rounded,
                        color: Go212Colors.primary600, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Contacter l\'agence',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF64748B))),
                        Text(_phone,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Go212Colors.primary600)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: Go212Colors.primary400),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.schedule_rounded,
                  color: Go212Colors.primary600, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Horaires d\'ouverture',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B))),
                  const SizedBox(height: 3),
                  Text(_hours,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF64748B))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Ouvert',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Go212Colors.primary700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (booking.confirmed) {
                Navigator.pushNamed(context, '/goride/review');
              } else {
                Navigator.pushNamed(context, '/goride/booking/summary',
                    arguments: booking);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Go212Colors.primary600.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      booking.confirmed
                          ? Icons.home_rounded
                          : Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20),
                  const SizedBox(width: 10),
                  Text(booking.confirmed ? 'Retour à l\'accueil' : 'Continuer',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _openMaps,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text('Voir l\'itinéraire sur Maps',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B))),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Fake map painter for agence with itinerary ───
class _AgenceMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bg = Paint()..color = const Color(0xFFE8F5E9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final roadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 16;
    final road2 = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 10;
    final block = Paint()..color = const Color(0xFFC8E6C9);

    // Grid
    for (double y = 0; y < size.height; y += 50) {
      canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          Paint()
            ..color = const Color(0xFFBBDEBB).withOpacity(0.6)
            ..strokeWidth = 1);
    }
    for (double x = 0; x < size.width; x += 50) {
      canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          Paint()
            ..color = const Color(0xFFBBDEBB).withOpacity(0.6)
            ..strokeWidth = 1);
    }

    // Roads
    canvas.drawLine(Offset(0, size.height * 0.5),
        Offset(size.width, size.height * 0.5), roadPaint);
    canvas.drawLine(Offset(size.width * 0.45, 0),
        Offset(size.width * 0.45, size.height), road2);
    canvas.drawLine(Offset(0, size.height * 0.25),
        Offset(size.width, size.height * 0.25), road2);
    canvas.drawLine(Offset(0, size.height * 0.75),
        Offset(size.width, size.height * 0.75), road2);
    canvas.drawLine(Offset(size.width * 0.2, 0),
        Offset(size.width * 0.2, size.height), road2);
    canvas.drawLine(Offset(size.width * 0.7, 0),
        Offset(size.width * 0.7, size.height), road2);

    // Blocks
    for (final r in [
      Rect.fromLTWH(size.width * 0.22, size.height * 0.28, size.width * 0.2,
          size.height * 0.18),
      Rect.fromLTWH(size.width * 0.48, size.height * 0.28, size.width * 0.19,
          size.height * 0.18),
      Rect.fromLTWH(size.width * 0.72, size.height * 0.28, size.width * 0.24,
          size.height * 0.18),
      Rect.fromLTWH(size.width * 0.01, size.height * 0.28, size.width * 0.16,
          size.height * 0.18),
      Rect.fromLTWH(size.width * 0.22, size.height * 0.52, size.width * 0.2,
          size.height * 0.2),
      Rect.fromLTWH(size.width * 0.48, size.height * 0.52, size.width * 0.19,
          size.height * 0.2),
    ]) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(3)), block);
    }

    // ── Itinerary route line (user bottom-left → agency center) ──
    final userPos = Offset(size.width * 0.12, size.height * 0.82);
    final agencyPos = Offset(size.width * 0.5, size.height * 0.5);

    // Shadow of route
    final routeShadow = Paint()
      ..color = const Color(0xFF16A34A).withOpacity(0.18)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Route path (L-shaped: go right then up)
    final routePath = Path()
      ..moveTo(userPos.dx, userPos.dy)
      ..lineTo(size.width * 0.45, userPos.dy)
      ..lineTo(size.width * 0.45, size.height * 0.5)
      ..lineTo(agencyPos.dx, agencyPos.dy);

    canvas.drawPath(routePath, routeShadow);

    // Dashed route line
    final dashPaint = Paint()
      ..color = const Color(0xFF16A34A)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    _drawDashedPath(canvas, routePath, dashPaint, dashLen: 10, gapLen: 7);

    // Distance indicator
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '~12 min',
        style: TextStyle(
          color: Color(0xFF16A34A),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final labelBg = Paint()..color = Colors.white;
    final lx = size.width * 0.22;
    final ly = size.height * 0.78;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(
                lx - 4, ly - 3, textPainter.width + 8, textPainter.height + 6),
            const Radius.circular(6)),
        labelBg);
    textPainter.paint(canvas, Offset(lx, ly));

    // User dot
    canvas.drawCircle(
        userPos, 9, Paint()..color = const Color(0xFF3B82F6).withOpacity(0.25));
    canvas.drawCircle(userPos, 5, Paint()..color = const Color(0xFF3B82F6));
    canvas.drawCircle(userPos, 3, Paint()..color = Colors.white);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint,
      {required double dashLen, required double gapLen}) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double dist = 0;
      while (dist < metric.length) {
        final end = (dist + dashLen).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(dist, end), paint);
        dist += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(_AgenceMapPainter old) => false;
}

// ─── Info Row ───
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, value;
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B))),
            ],
          ),
        ),
      ],
    );
  }
}
