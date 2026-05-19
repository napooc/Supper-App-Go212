import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/go212_colors.dart';
import '../models/goride_kyc_data.dart';
import '../widgets/kyc_progress_bar.dart';
import '../widgets/goride_btn.dart';
import '../widgets/goride_header.dart';
import '../widgets/kyc_camera_stub.dart'
    if (dart.library.html) '../widgets/kyc_camera_web.dart';

class GoRideKycSelfieScreen extends StatefulWidget {
  const GoRideKycSelfieScreen({super.key});

  @override
  State<GoRideKycSelfieScreen> createState() => _GoRideKycSelfieScreenState();
}

class _GoRideKycSelfieScreenState extends State<GoRideKycSelfieScreen>
    with SingleTickerProviderStateMixin {
  Uint8List? _selfieBytes;
  bool _isCapturing = false;
  late final String _viewId;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _viewId = 'selfie-front-${DateTime.now().millisecondsSinceEpoch}';
    if (kIsWeb) registerCameraView(_viewId, true);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    if (kIsWeb) disposeWebCamera(_viewId);
    super.dispose();
  }

  Future<void> _captureSelfie() async {
    setState(() {
      _isCapturing = true;
      _selfieBytes = null;
    });
    try {
      Uint8List? bytes;
      if (kIsWeb) {
        bytes = await captureWebFrame(_viewId);
      } else {
        final img = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: 85,
        );
        if (img != null) bytes = await img.readAsBytes();
      }
      if (mounted && bytes != null) setState(() => _selfieBytes = bytes);
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildCameraArea()),
            _buildTips(),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GoRideHeader(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 44, 20, 12),
            child: Row(
              children: [
                GoRideBackBtn(onTap: () => Navigator.pop(context)),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text('Selfie de vérification',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
                const GoRideMascotBadge(size: 34),
                const SizedBox(width: 10),
                const GoRideStepBadge(step: 3, total: 3),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: KycProgressBar(currentStep: 3, totalSteps: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraArea() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera feed or captured selfie
        if (_selfieBytes != null && !_isCapturing)
          Image.memory(_selfieBytes!, fit: BoxFit.cover)
        else if (kIsWeb)
          HtmlElementView(viewType: _viewId)
        else
          Container(
            color: const Color(0xFFF1F5F9),
            child: const Center(
              child: Icon(Icons.camera_front_rounded,
                  size: 80, color: Color(0xFF94A3B8)),
            ),
          ),

        // Pulsing circular guide
        Center(
          child: AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) {
              final hasSelfie = _selfieBytes != null && !_isCapturing;
              return Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: hasSelfie
                        ? Go212Colors.primary400
                        : Colors.white.withOpacity(0.5 + _pulseAnim.value * 0.3),
                    width: 3,
                  ),
                  boxShadow: hasSelfie
                      ? null
                      : [
                          BoxShadow(
                            color: Go212Colors.primary400.withOpacity(_pulseAnim.value * 0.15),
                            blurRadius: 20 + _pulseAnim.value * 10,
                            spreadRadius: _pulseAnim.value * 4,
                          ),
                        ],
                ),
              );
            },
          ),
        ),

        // Captured badge
        if (_selfieBytes != null && !_isCapturing)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: Go212Colors.primary600,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Go212Colors.primary600.withOpacity(0.45),
                      blurRadius: 14,
                    )
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Selfie capturé !',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTips() {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TipItem(icon: Icons.wb_sunny_rounded, label: 'Bonne lumière'),
          _TipItem(icon: Icons.face_rounded, label: 'Visage centré'),
          _TipItem(icon: Icons.remove_red_eye_rounded, label: 'Sans lunettes'),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selfieBytes != null && !_isCapturing)
            GoRideBtn(
              label: 'Valider et continuer',
              onTap: () {
                GoRideKycData.instance.selfieBytes = _selfieBytes;
                Navigator.pushNamed(context, '/goride/kyc/verify');
              },
              icon: Icons.arrow_forward_rounded,
            )
          else
            GestureDetector(
              onTap: _isCapturing ? null : _captureSelfie,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _isCapturing
                      ? const Color(0xFF334155)
                      : Go212Colors.primary600,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _isCapturing
                      ? null
                      : [
                          BoxShadow(
                            color:
                                Go212Colors.primary600.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          )
                        ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isCapturing)
                      const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                    else ...[
                      const Icon(Icons.camera_front_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        _selfieBytes != null
                            ? 'Reprendre le selfie'
                            : 'Prendre le selfie',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TipItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Go212Colors.primary600),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
