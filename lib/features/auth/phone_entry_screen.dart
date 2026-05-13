import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/go212_colors.dart';
import '../../core/services/auth_service.dart';

class PhoneEntryScreen extends StatefulWidget {
  final bool isSignUp;
  const PhoneEntryScreen({super.key, required this.isSignUp});

  @override
  State<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends State<PhoneEntryScreen> {
  final _controller = TextEditingController();
  bool _valid    = false;
  bool _loading  = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final raw = _controller.text.replaceAll(RegExp(r'\D'), '');
      setState(() {
        _valid = raw.length >= 9;
        _error = null; // clear error on type
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Normalize: prepend +212 for the API ───────────────────────
  String get _normalizedPhone {
    final digits = _controller.text.replaceAll(RegExp(r'\D'), '');
    // If user typed "0612345678" strip the leading 0 and add +212
    if (digits.startsWith('0')) return '+212${digits.substring(1)}';
    return '+212$digits';
  }

  Future<void> _continue() async {
    if (!_valid || _loading) return;

    setState(() { _loading = true; _error = null; });

    final result = await AuthService.instance.sendOtp(_normalizedPhone);

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.success) {
      // Navigate to OTP screen, passing the phone number
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: {
          'phone':   _normalizedPhone,
          'dev_otp': result.devOtp, // null in production, shows in DEV
        },
      );
    } else {
      setState(() => _error = result.message ?? 'Erreur inconnue');
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
              widget.isSignUp ? 'Créer un\ncompte' : 'Se\nconnecter',
              style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.w800,
                color: Go212Colors.neutral900, height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Entrez votre numéro de téléphone',
              style: TextStyle(fontSize: 14, color: Go212Colors.neutral500),
            ),
            const SizedBox(height: 32),

            // ── Phone input ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Go212Colors.neutral50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _error != null
                      ? Colors.red.shade400
                      : _valid
                          ? Go212Colors.primary500
                          : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  // Morocco flag + code
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇲🇦', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text('+212', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Go212Colors.neutral400),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600,
                        color: Go212Colors.neutral900, letterSpacing: 1,
                      ),
                      decoration: InputDecoration(
                        hintText: '6 XX XX XX XX',
                        hintStyle: TextStyle(color: Go212Colors.neutral300, fontWeight: FontWeight.w400, letterSpacing: 1),
                        border: InputBorder.none,
                        filled: false,
                      ),
                    ),
                  ),
                  if (_valid && !_loading) ...[
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(color: Go212Colors.primary600, shape: BoxShape.circle),
                      child: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
                    ),
                  ],
                  if (_loading) ...[
                    SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Go212Colors.primary600),
                    ),
                  ],
                ],
              ),
            ),

            // ── Error message ────────────────────────────────────
            if (_error != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.error_outline_rounded, size: 16, color: Colors.red.shade600),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(_error!, style: TextStyle(color: Colors.red.shade600, fontSize: 13)),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // ── CTA ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity, height: 56,
              child: AnimatedOpacity(
                opacity: _valid && !_loading ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: _valid && !_loading ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Go212Colors.primary600,
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
                      : const Text('Continuer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),

            const Spacer(),
            if (widget.isSignUp) ...[
              Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Déjà un compte ? ", style: TextStyle(color: Go212Colors.neutral500, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: Text('Se connecter', style: TextStyle(color: Go212Colors.primary600, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ])),
            ] else ...[
              Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Pas encore de compte ? ", style: TextStyle(color: Go212Colors.neutral500, fontSize: 13)),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                  child: Text('Créer un compte', style: TextStyle(color: Go212Colors.primary600, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ])),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
