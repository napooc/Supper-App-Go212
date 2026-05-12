// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../widgets/goride_header.dart';

class GoRideKycVerifyScreen extends StatefulWidget {
  const GoRideKycVerifyScreen({super.key});

  @override
  State<GoRideKycVerifyScreen> createState() => _GoRideKycVerifyScreenState();
}

class _GoRideKycVerifyScreenState extends State<GoRideKycVerifyScreen>
    with TickerProviderStateMixin {
  late AnimationController _spinCtrl;
  late AnimationController _progressCtrl;
  late Animation<double> _progressAnim;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  int _currentStep = 0;
  bool _allStepsDone = false;
  bool _approved = false;

  final List<_VerifyStep> _steps = [
    _VerifyStep(
      icon: Icons.badge_rounded,
      label: 'Lecture du CIN',
      subLabel: 'Extraction des données...',
      duration: 1800,
    ),
    _VerifyStep(
      icon: Icons.document_scanner_rounded,
      label: 'Vérification du document',
      subLabel: 'Contrôle d\'authenticité...',
      duration: 1600,
    ),
    _VerifyStep(
      icon: Icons.face_rounded,
      label: 'Reconnaissance faciale',
      subLabel: 'Comparaison biométrique...',
      duration: 2000,
    ),
    _VerifyStep(
      icon: Icons.verified_user_rounded,
      label: 'Validation finale',
      subLabel: 'Sécurisation du compte...',
      duration: 1400,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);

    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _progressAnim =
        CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOut);

    _runSteps();
  }

  Future<void> _runSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      if (!mounted) return;
      setState(() => _currentStep = i);
      _progressCtrl.reset();
      _progressCtrl.animateTo(1.0,
          duration: Duration(milliseconds: _steps[i].duration));
      await Future.delayed(Duration(milliseconds: _steps[i].duration + 200));
    }
    if (!mounted) return;
    // All steps done — now wait for system approval
    setState(() => _allStepsDone = true);

    // Simulate system approval delay (3 seconds)
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _approved = true);
      _spinCtrl.stop();
    }
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _progressCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  double get _overallProgress =>
      (_currentStep + (_progressAnim.value)) / _steps.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  _buildScanAnimation(),
                  const SizedBox(height: 14),
                  _buildCurrentStepLabel(),
                  const SizedBox(height: 28),
                  _buildStepsList(),
                  const SizedBox(height: 24),
                  _buildOverallProgress(),
                  const SizedBox(height: 14),
                  _buildMessage(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          // Show continue button only after approval
          if (_approved) _buildApprovedFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GoRideHeader(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(Icons.security_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _approved
                              ? 'Identité vérifiée'
                              : 'Vérification en cours',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          _approved
                              ? 'Votre compte est approuvé ✅'
                              : 'Analyse de votre identité...',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const GoRideMascotBadge(size: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanAnimation() {
    if (_approved) {
      // Show approved state
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (_, scale, __) => Transform.scale(
          scale: scale,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF15803D), Color(0xFF22C55E)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Go212Colors.primary600.withOpacity(0.35),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(Icons.check_rounded,
                color: Colors.white, size: 60),
          ),
        ),
      );
    }

    if (_allStepsDone) {
      // Waiting for approval state
      return AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, __) => Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFF7ED),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF59E0B)
                    .withOpacity(0.08 + _pulseAnim.value * 0.08),
                blurRadius: 20 + _pulseAnim.value * 10,
                spreadRadius: _pulseAnim.value * 6,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _spinCtrl,
                builder: (_, __) => Transform.rotate(
                  angle: _spinCtrl.value * 2 * math.pi,
                  child: CustomPaint(
                    size: const Size(120, 120),
                    painter: _SpinRingPainter(
                      color: const Color(0xFFF59E0B),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_top_rounded,
                    color: Colors.white, size: 28),
              ),
            ],
          ),
        ),
      );
    }

    // Normal verification state
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Go212Colors.primary50,
          boxShadow: [
            BoxShadow(
              color: Go212Colors.primary400
                  .withOpacity(0.08 + _pulseAnim.value * 0.08),
              blurRadius: 20 + _pulseAnim.value * 10,
              spreadRadius: _pulseAnim.value * 6,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _spinCtrl,
              builder: (_, __) => Transform.rotate(
                angle: _spinCtrl.value * 2 * math.pi,
                child: CustomPaint(
                  size: const Size(120, 120),
                  painter: _SpinRingPainter(
                    color: Go212Colors.primary400,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Go212Colors.primary600.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _steps[_currentStep].icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepLabel() {
    if (_approved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Go212Colors.primary200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_rounded,
                size: 16, color: Go212Colors.primary600),
            const SizedBox(width: 8),
            Text('Identité approuvée par le système',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Go212Colors.primary700)),
          ],
        ),
      );
    }

    if (_allStepsDone) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Container(
          key: const ValueKey('waiting'),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 8),
              const Text('En attente d\'approbation...',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB45309))),
            ],
          ),
        ),
      );
    }

    final step = _steps[_currentStep];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(_currentStep),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Go212Colors.primary50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Go212Colors.primary200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Go212Colors.primary600,
              ),
            ),
            const SizedBox(width: 8),
            Text(step.subLabel,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Go212Colors.primary700)),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsList() {
    return Column(
      children: List.generate(_steps.length, (i) {
        final step = _steps[i];
        final isCompleted = _allStepsDone || i < _currentStep;
        final isCurrent = !_allStepsDone && i == _currentStep;
        final isPending = !_allStepsDone && i > _currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFFF0FDF4)
                : isCurrent
                    ? Colors.white
                    : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCompleted
                  ? Go212Colors.primary200
                  : isCurrent
                      ? Go212Colors.primary300
                      : const Color(0xFFE2E8F0),
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                        color: Go212Colors.primary600.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]
                : null,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Go212Colors.primary100
                      : isCurrent
                          ? Go212Colors.primary50
                          : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isCompleted
                    ? Icon(Icons.check_rounded,
                        size: 20, color: Go212Colors.primary600)
                    : isCurrent
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Go212Colors.primary600,
                                ),
                              ),
                            ),
                          )
                        : Icon(step.icon,
                            size: 20,
                            color: isPending
                                ? const Color(0xFFCBD5E1)
                                : Go212Colors.primary600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isPending
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF1E293B),
                      ),
                    ),
                    if (isCurrent)
                      Text(
                        step.subLabel,
                        style: TextStyle(
                            fontSize: 11,
                            color: Go212Colors.primary600
                                .withOpacity(0.8)),
                      ),
                  ],
                ),
              ),
              if (isCompleted)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Go212Colors.primary100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('OK',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Go212Colors.primary700)),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOverallProgress() {
    return AnimatedBuilder(
      animation: _progressAnim,
      builder: (_, __) {
        final progress =
            _approved ? 1.0 : _overallProgress.clamp(0.0, 1.0);
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progression',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B))),
                Text('${(progress * 100).toInt()}%',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF15803D))),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor:
                    const AlwaysStoppedAnimation(Color(0xFF22C55E)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessage() {
    if (_approved) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded,
              size: 14, color: Go212Colors.primary600),
          const SizedBox(width: 6),
          Text(
            'Vérification terminée avec succès',
            style: TextStyle(
                fontSize: 12,
                color: Go212Colors.primary600,
                fontWeight: FontWeight.w600),
          ),
        ],
      );
    }
    if (_allStepsDone) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_bottom_rounded,
              size: 14, color: Color(0xFFF59E0B)),
          const SizedBox(width: 6),
          const Text(
            'Le système vérifie votre identité...',
            style: TextStyle(
                fontSize: 12,
                color: Color(0xFFB45309),
                fontWeight: FontWeight.w500),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shield_rounded, size: 14, color: Go212Colors.neutral400),
        const SizedBox(width: 6),
        Text(
          'Vérification sécurisée via GO212',
          style: TextStyle(
              fontSize: 12,
              color: Go212Colors.neutral400,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildApprovedFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4))
        ],
      ),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushReplacementNamed(context, '/goride/kyc/success'),
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
                color: Go212Colors.primary600.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Continuer',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerifyStep {
  final IconData icon;
  final String label;
  final String subLabel;
  final int duration;

  const _VerifyStep({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.duration,
  });
}

// Spinning arc ring
class _SpinRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _SpinRingPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 0.8,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * 0.6,
      false,
      paint..color = color.withOpacity(0.4),
    );
  }

  @override
  bool shouldRepaint(_SpinRingPainter old) => old.color != color;
}
