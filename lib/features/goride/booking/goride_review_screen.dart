// ignore_for_file: deprecated_member_use
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../../../core/services/goride_service.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_header.dart';

class GoRideReviewScreen extends StatefulWidget {
  const GoRideReviewScreen({super.key});
  @override
  State<GoRideReviewScreen> createState() => _GoRideReviewScreenState();
}

class _GoRideReviewScreenState extends State<GoRideReviewScreen>
    with SingleTickerProviderStateMixin {
  int _stars = 0;
  int _hoveredStar = 0;
  final Set<String> _tags = {};
  final TextEditingController _commentCtrl = TextEditingController();
  late AnimationController _submitAnim;
  bool _submitted = false;

  static const _allTags = [
    ('🕐', 'Ponctualité'),
    ('🏍️', 'Qualité moto'),
    ('😊', 'Service client'),
    ('💰', 'Bon rapport qualité/prix'),
    ('🛡️', 'Sécurité'),
    ('📍', 'Facilité de retrait'),
  ];

  @override
  void initState() {
    super.initState();
    _submitAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _submitAnim.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  String get _starLabel {
    switch (_stars) {
      case 1:
        return 'Très décevant';
      case 2:
        return 'Peut mieux faire';
      case 3:
        return 'Correct';
      case 4:
        return 'Très bien';
      case 5:
        return 'Excellent ! 🎉';
      default:
        return 'Notez votre expérience';
    }
  }

  Color get _starColor {
    if (_stars <= 2) return const Color(0xFFEF4444);
    if (_stars == 3) return const Color(0xFFF59E0B);
    return Go212Colors.primary600;
  }

  void _submit() async {
    if (_stars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Veuillez attribuer une note avant de valider.'),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }

    // ── Envoi de l'avis au backend GoRide ──────────────────────
    try {
      final booking =
          ModalRoute.of(context)?.settings.arguments as GoRideBooking?;
      final selectedTags = _tags.toList();

      final result = await GoRideService.instance.submitReview(
        reservationId: booking?.reservationId,
        note: _stars,
        tags: selectedTags,
        commentaire: _commentCtrl.text.trim().isEmpty
            ? null
            : _commentCtrl.text.trim(),
      );

      if (kDebugMode) debugPrint('⭐ Review result: $result');
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Review error (non-blocking): $e');
    }

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, '/goride/thankyou', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _submitted ? _buildThanks() : _buildForm(),
          ),
        ],
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return GoRideHeader(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/main', (r) => false),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Votre avis compte',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800)),
                    Text('Aidez-nous à nous améliorer',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('⭐', style: TextStyle(fontSize: 22)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Form ──────────────────────────────────────────────────────────
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stars ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                const Text('Comment s\'était passée\nvotre expérience GO212 ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                        height: 1.4)),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    final filled =
                        i < (_hoveredStar > 0 ? _hoveredStar : _stars);
                    return GestureDetector(
                      onTap: () => setState(() {
                        _stars = i + 1;
                        _hoveredStar = 0;
                      }),
                      child: MouseRegion(
                        onEnter: (_) => setState(() => _hoveredStar = i + 1),
                        onExit: (_) => setState(() => _hoveredStar = 0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, anim) =>
                                ScaleTransition(scale: anim, child: child),
                            child: Icon(
                              filled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              key: ValueKey('$i-$filled'),
                              size: filled ? 44 : 38,
                              color: filled
                                  ? const Color(0xFFFBBF24)
                                  : const Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(_starLabel,
                      key: ValueKey(_starLabel),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _stars > 0
                              ? _starColor
                              : const Color(0xFF94A3B8))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // ── Tags ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ce que vous avez aimé',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                const Text('Sélectionnez tout ce qui s\'applique',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allTags.map((tag) {
                    final selected = _tags.contains(tag.$2);
                    return GestureDetector(
                      onTap: () => setState(() {
                        selected ? _tags.remove(tag.$2) : _tags.add(tag.$2);
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? Go212Colors.primary600.withOpacity(0.1)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: selected
                                ? Go212Colors.primary600
                                : const Color(0xFFE2E8F0),
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(tag.$1, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(tag.$2,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Go212Colors.primary700
                                      : const Color(0xFF475569),
                                )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // ── Comment ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Commentaire',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A))),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Optionnel',
                          style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _commentCtrl,
                  maxLines: 4,
                  maxLength: 300,
                  decoration: InputDecoration(
                    hintText: 'Partagez votre expérience avec GO212…',
                    hintStyle:
                        const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          BorderSide(color: Go212Colors.primary400, width: 1.5),
                    ),
                    counterStyle:
                        const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Submit ──────────────────────────────────────────────
          GestureDetector(
            onTap: _submit,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 17),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Go212Colors.primary700, Go212Colors.primary500]),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Go212Colors.primary600.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('Envoyer mon avis',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/main', (r) => false),
            child: const Center(
              child: Text('Passer',
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Thanks ────────────────────────────────────────────────────────
  Widget _buildThanks() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: CurvedAnimation(
                  parent: _submitAnim, curve: Curves.elasticOut),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Go212Colors.primary600, Go212Colors.primary400]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Go212Colors.primary600.withOpacity(0.35),
                        blurRadius: 24,
                        spreadRadius: 4),
                  ],
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Image.asset(
                      'assets/images/mascot.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text('Merci pour votre avis ! 🙏',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A))),
            const SizedBox(height: 10),
            Text('Votre retour nous aide à\naméliorer GO212 chaque jour.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: const Color(0xFF64748B), height: 1.5)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stars_rounded,
                      color: Go212Colors.primary600, size: 18),
                  const SizedBox(width: 8),
                  Text('Vous avez donné $_stars étoile${_stars > 1 ? 's' : ''}',
                      style: TextStyle(
                          color: Go212Colors.primary700,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text('Redirection vers l\'accueil…',
                style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
          ],
        ),
      ),
    );
  }
}
