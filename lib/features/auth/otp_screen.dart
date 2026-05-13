import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/go212_colors.dart';
import '../../core/services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  int _countdown = 30;
  Timer? _timer;
  bool _loading   = false;
  bool _verified  = false;
  String? _error;

  // Route arguments
  late String _phone;
  String? _devOtp; // null in production

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    _phone  = args?['phone']   as String? ?? '';
    _devOtp = args?['dev_otp'] as String?;

    // In dev mode: auto-fill the OTP so testers don't need an SMS
    if (_devOtp != null && _devOtp!.length == 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _autoFill(_devOtp!));
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _countdown = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final n in _nodes) n.dispose();
    super.dispose();
  }

  // ── Auto-fill OTP (dev mode) ──────────────────────────────────
  void _autoFill(String otp) {
    for (int i = 0; i < otp.length && i < 6; i++) {
      _controllers[i].text = otp[i];
    }
    setState(() {});
  }

  String get _enteredCode => _controllers.map((c) => c.text).join();

  void _onChanged(int i, String val) {
    if (val.length > 1) {
      // Handle paste — distribute digits across boxes
      final digits = val.replaceAll(RegExp(r'\D'), '');
      for (int j = 0; j < digits.length && (i + j) < 6; j++) {
        _controllers[i + j].text = digits[j];
      }
      final nextIndex = (i + digits.length).clamp(0, 5);
      _nodes[nextIndex].requestFocus();
    } else {
      if (val.isNotEmpty && i < 5) {
        _nodes[i + 1].requestFocus();
      }
    }
    setState(() => _error = null);

    // Auto-submit when all 6 digits entered
    if (_enteredCode.length == 6) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && !_verified) _verify();
      });
    }
  }

  void _onKeyPress(int i, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[i].text.isEmpty &&
        i > 0) {
      _nodes[i - 1].requestFocus();
    }
  }

  // ── Call the real verify API ──────────────────────────────────
  Future<void> _verify() async {
    final code = _enteredCode;
    if (code.length < 4 || _loading || _verified) return;

    setState(() { _loading = true; _error = null; });

    final result = await AuthService.instance.verifyOtp(_phone, code);

    if (!mounted) return;

    if (result.success) {
      setState(() { _verified = true; _loading = false; });
      HapticFeedback.heavyImpact();

      // Small delay to show the green state, then navigate
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
      }
    } else {
      setState(() {
        _loading = false;
        _error = result.message ?? 'Code incorrect';
        // Clear the OTP boxes on error
        for (final c in _controllers) c.clear();
      });
      _nodes[0].requestFocus();
      HapticFeedback.vibrate();
    }
  }

  // ── Resend OTP ────────────────────────────────────────────────
  Future<void> _resend() async {
    setState(() { _error = null; _loading = true; });
    final result = await AuthService.instance.sendOtp(_phone);
    if (!mounted) return;
    setState(() { _loading = false; });

    if (result.success) {
      _startTimer();
      if (result.devOtp != null) _autoFill(result.devOtp!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nouveau code envoyé ✓'),
          backgroundColor: Go212Colors.primary600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      setState(() => _error = result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allFilled = _enteredCode.length == 6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Go212Colors.neutral50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_rounded, size: 20, color: Go212Colors.neutral700),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Vérification',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Go212Colors.neutral900, height: 1.2),
            ),
            const SizedBox(height: 8),
            RichText(text: TextSpan(children: [
              TextSpan(text: 'Code envoyé au ', style: TextStyle(fontSize: 14, color: Go212Colors.neutral500)),
              TextSpan(text: _phone.isEmpty ? '+212 6XX XX XX XX' : _phone, style: TextStyle(fontSize: 14, color: Go212Colors.neutral800, fontWeight: FontWeight.w600)),
            ])),

            // ── DEV banner ───────────────────────────────────────
            if (_devOtp != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(children: [
                  Icon(Icons.developer_mode, size: 16, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Text('DEV — Code: $_devOtp (auto-rempli)', style: TextStyle(fontSize: 12, color: Colors.amber.shade800, fontWeight: FontWeight.w600)),
                ]),
              ),
            ],

            const SizedBox(height: 40),

            // ── OTP boxes ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                final filled = _controllers[i].text.isNotEmpty;
                final hasError = _error != null;
                return SizedBox(
                  width: 48, height: 58,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (e) => _onKeyPress(i, e),
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _nodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      enabled: !_loading && !_verified,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => _onChanged(i, v),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _verified
                            ? Colors.green.shade600
                            : hasError
                                ? Colors.red.shade600
                                : Go212Colors.neutral900,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: _verified
                            ? Colors.green.shade50
                            : hasError && filled
                                ? Colors.red.shade50
                                : filled
                                    ? Go212Colors.primary50
                                    : Go212Colors.neutral50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _verified
                                ? Colors.green
                                : hasError
                                    ? Colors.red.shade400
                                    : filled
                                        ? Go212Colors.primary500
                                        : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: hasError ? Colors.red.shade400 : Go212Colors.primary500,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: _verified
                                ? Colors.green
                                : hasError && filled
                                    ? Colors.red.shade400
                                    : filled
                                        ? Go212Colors.primary400
                                        : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // ── Error ────────────────────────────────────────────
            if (_error != null) ...[
              Row(children: [
                Icon(Icons.error_outline_rounded, size: 16, color: Colors.red.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(_error!, style: TextStyle(color: Colors.red.shade600, fontSize: 13)),
                ),
              ]),
              const SizedBox(height: 8),
            ],

            const SizedBox(height: 12),

            // ── Resend ───────────────────────────────────────────
            Center(
              child: _loading
                  ? SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Go212Colors.primary600),
                    )
                  : _countdown > 0
                      ? Text('Renvoyer dans ${_countdown}s', style: TextStyle(fontSize: 13, color: Go212Colors.neutral400))
                      : GestureDetector(
                          onTap: _resend,
                          child: Text('Renvoyer le code', style: TextStyle(fontSize: 13, color: Go212Colors.primary600, fontWeight: FontWeight.w600)),
                        ),
            ),

            const Spacer(),

            // ── Verify button ─────────────────────────────────────
            SizedBox(
              width: double.infinity, height: 56,
              child: AnimatedOpacity(
                opacity: allFilled && !_loading ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: allFilled && !_loading && !_verified ? _verify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _verified ? Colors.green.shade600 : Go212Colors.primary600,
                    disabledBackgroundColor: Go212Colors.neutral200,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                        )
                      : _verified
                          ? const Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.check_rounded, size: 20),
                              SizedBox(width: 8),
                              Text('Connecté !', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ])
                          : const Text('Vérifier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
