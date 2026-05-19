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

class GoRideKycScanScreen extends StatefulWidget {
  const GoRideKycScanScreen({super.key});

  @override
  State<GoRideKycScanScreen> createState() => _GoRideKycScanScreenState();
}

class _GoRideKycScanScreenState extends State<GoRideKycScanScreen> {
  int _tab = 0; // 0 = Recto, 1 = Verso
  Uint8List? _rectoBytes;
  Uint8List? _versoBytes;
  bool _isCapturing = false;
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'scan-rear-${DateTime.now().millisecondsSinceEpoch}';
    if (kIsWeb) registerCameraView(_viewId, false);
  }

  @override
  void dispose() {
    if (kIsWeb) disposeWebCamera(_viewId);
    super.dispose();
  }

  bool get _canContinue => _rectoBytes != null && _versoBytes != null;
  Uint8List? get _currentBytes => _tab == 0 ? _rectoBytes : _versoBytes;

  Future<void> _capture() async {
    setState(() {
      _isCapturing = true;
      if (_tab == 0)
        _rectoBytes = null;
      else
        _versoBytes = null;
    });

    try {
      Uint8List? bytes;
      if (kIsWeb) {
        bytes = await captureWebFrame(_viewId);
      } else {
        final img = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.rear,
          imageQuality: 85,
        );
        if (img != null) bytes = await img.readAsBytes();
      }

      if (mounted && bytes != null) {
        setState(() {
          if (_tab == 0) {
            _rectoBytes = bytes;
            if (_versoBytes == null) _tab = 1;
          } else {
            _versoBytes = bytes;
          }
        });
      }
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
            _buildTabs(),
            Expanded(child: _buildCameraArea()),
            _buildHint(),
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
                  child: Text('Scan de la CIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
                const GoRideMascotBadge(size: 34),
                const SizedBox(width: 10),
                const GoRideStepBadge(step: 2, total: 3),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: KycProgressBar(currentStep: 2, totalSteps: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: const Color(0xFFF8FAFC),
      child: Row(
        children: [
          _buildTab(0, 'Recto', Icons.flip_rounded, _rectoBytes != null),
          _buildTab(
              1, 'Verso', Icons.flip_camera_android_rounded, _versoBytes != null),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label, IconData icon, bool done) {
    final isActive = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? Go212Colors.primary600 : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (done)
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                      color: Color(0xFF22C55E), shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 11, color: Colors.white),
                )
              else
                Icon(icon,
                    size: 18,
                    color: isActive
                        ? Go212Colors.primary600
                        : Go212Colors.neutral300),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                    color: isActive
                        ? Go212Colors.neutral800
                        : Go212Colors.neutral400,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 14,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraArea() {
    final current = _currentBytes;

    if (current != null && !_isCapturing) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(current, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.25)),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Go212Colors.primary600,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Go212Colors.primary600.withOpacity(0.4),
                    blurRadius: 12,
                  )
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Photo capturée !',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (kIsWeb) {
      return HtmlElementView(viewType: _viewId);
    }

    // Mobile placeholder with animated scan corners
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Scan frame
            Container(
              width: 240,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Go212Colors.primary400.withOpacity(0.5),
                    width: 2),
              ),
              child: Stack(
                children: [
                  // Corner brackets
                  ..._corners(),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_rounded,
                            size: 40, color: Go212Colors.primary400),
                        const SizedBox(height: 8),
                        Text(
                          _tab == 0 ? 'Recto de la CIN' : 'Verso de la CIN',
                          style: TextStyle(
                              color: Go212Colors.neutral500,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Appuyez sur Capturer',
                style: TextStyle(color: Go212Colors.neutral400, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  List<Widget> _corners() {
    const size = 24.0;
    const thickness = 3.0;
    final color = Go212Colors.primary500;

    Widget corner(Alignment align) {
      final isLeft =
          align == Alignment.topLeft || align == Alignment.bottomLeft;
      final isTop =
          align == Alignment.topLeft || align == Alignment.topRight;
      return Positioned(
        left: isLeft ? 0 : null,
        right: isLeft ? null : 0,
        top: isTop ? 0 : null,
        bottom: isTop ? null : 0,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter:
                _CornerPainter(alignment: align, color: color, thickness: thickness),
          ),
        ),
      );
    }

    return [
      corner(Alignment.topLeft),
      corner(Alignment.topRight),
      corner(Alignment.bottomLeft),
      corner(Alignment.bottomRight),
    ];
  }

  Widget _buildHint() {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💡', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(
            _tab == 0
                ? 'Côté photo · Bien éclairée · Texte lisible'
                : 'Côté code-barres · Bien éclairée · Texte lisible',
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
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
          if (_canContinue)
            GoRideBtn(
              label: 'Continuer',
              onTap: () {
                GoRideKycData.instance.cinRectoBytes = _rectoBytes;
                GoRideKycData.instance.cinVersoBytes = _versoBytes;
                Navigator.pushNamed(context, '/goride/kyc/selfie');
              },
              icon: Icons.arrow_forward_rounded,
            )
          else
            GestureDetector(
              onTap: _isCapturing ? null : _capture,
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
                      const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        _currentBytes != null
                            ? 'Reprendre'
                            : 'Capturer ${_tab == 0 ? "Recto" : "Verso"}',
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

class _CornerPainter extends CustomPainter {
  final Alignment alignment;
  final Color color;
  final double thickness;

  const _CornerPainter(
      {required this.alignment, required this.color, this.thickness = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final len = size.width * 0.8;
    final isLeft =
        alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    final isTop =
        alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final x = isLeft ? 0.0 : size.width;
    final y = isTop ? 0.0 : size.height;
    final dx = isLeft ? len : -len;
    final dy = isTop ? len : -len;
    canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}
