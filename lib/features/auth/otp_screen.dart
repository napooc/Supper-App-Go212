import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/go212_colors.dart';

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

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _nodes[0].requestFocus());
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

  void _onChanged(int i, String val) {
    if (val.isNotEmpty && i < 5) {
      _nodes[i + 1].requestFocus();
    }
    // Check if all filled
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 6) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Go212Colors.neutral50, borderRadius: BorderRadius.circular(12)),
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
            Text('Vérification', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Go212Colors.neutral900, height: 1.2)),
            const SizedBox(height: 8),
            RichText(text: TextSpan(children: [
              TextSpan(text: 'Code envoyé au ', style: TextStyle(fontSize: 14, color: Go212Colors.neutral500)),
              TextSpan(text: '+212 6XX XX XX XX', style: TextStyle(fontSize: 14, color: Go212Colors.neutral800, fontWeight: FontWeight.w600)),
            ])),
            const SizedBox(height: 40),
            // OTP fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                final filled = _controllers[i].text.isNotEmpty;
                return SizedBox(
                  width: 48, height: 58,
                  child: TextField(
                    controller: _controllers[i],
                    focusNode: _nodes[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (v) => _onChanged(i, v),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Go212Colors.neutral900),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: filled ? Go212Colors.primary50 : Go212Colors.neutral50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: filled ? Go212Colors.primary500 : Colors.transparent, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Go212Colors.primary500, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: filled ? Go212Colors.primary400 : Colors.transparent, width: 2),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),
            // Resend
            Center(
              child: _countdown > 0
                  ? Text('Renvoyer dans ${_countdown}s', style: TextStyle(fontSize: 13, color: Go212Colors.neutral400))
                  : GestureDetector(
                      onTap: _startTimer,
                      child: Text('Renvoyer le code', style: TextStyle(fontSize: 13, color: Go212Colors.primary600, fontWeight: FontWeight.w600)),
                    ),
            ),
            const Spacer(),
            // CTA
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Go212Colors.primary600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text('Vérifier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
