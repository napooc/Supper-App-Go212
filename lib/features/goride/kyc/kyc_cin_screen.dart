// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/go212_colors.dart';
import '../widgets/kyc_progress_bar.dart';
import '../widgets/goride_btn.dart';
import '../widgets/goride_header.dart';

class GoRideKycCinScreen extends StatefulWidget {
  const GoRideKycCinScreen({super.key});
  @override
  State<GoRideKycCinScreen> createState() => _GoRideKycCinScreenState();
}

class _GoRideKycCinScreenState extends State<GoRideKycCinScreen>
    with SingleTickerProviderStateMixin {
  final _cinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _anim;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _cinController.dispose();
    super.dispose();
  }

  bool get _isValid => _cinController.text.trim().length >= 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 22),
                        _IllustrationCard(),
                        const SizedBox(height: 24),
                        _SectionLabel(text: 'Numéro CIN'),
                        const SizedBox(height: 10),
                        _GoField(
                          controller: _cinController,
                          hint: 'Ex: AB123456',
                          icon: Icons.credit_card_rounded,
                          suffixIcon: _isValid
                              ? const Icon(Icons.check_circle_rounded,
                                  color: Color(0xFF22C55E), size: 22)
                              : null,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]')),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          textCapitalization: TextCapitalization.characters,
                          validator: (v) => (v?.trim().length ?? 0) < 6
                              ? 'Numéro CIN invalide (min. 6 caractères)'
                              : null,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            '${_cinController.text.trim().length} / 10 caractères',
                            style: TextStyle(
                              fontSize: 11,
                              color: _isValid
                                  ? Go212Colors.primary600
                                  : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  GoRideBackBtn(onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Vérification d\'identité',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
                      Text('GoRide KYC — Étape 1 / 3',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.65),
                              fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  const GoRideMascotBadge(size: 52),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: KycProgressBar(currentStep: 1, totalSteps: 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
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
      child: GoRideBtn(
        label: 'Continuer',
        onTap: _isValid
            ? () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.pushNamed(context, '/goride/kyc/scan');
                }
              }
            : null,
      ),
    );
  }
}

class _IllustrationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D3D26), Color(0xFF1E6B46)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF0D3D26).withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          // Mascot avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Image.asset('assets/images/mascot.png',
                    fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.verified_user_rounded,
                        color: Color(0xFF4ADE80), size: 16),
                    const SizedBox(width: 6),
                    const Flexible(
                      child: Text('Vérification rapide',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xFF4ADE80),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Saisissez votre CIN',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                    'Votre numéro de Carte Nationale pour valider votre compte GoRide',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11.5,
                        height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF334155)),
    );
  }
}

class _GoField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const _GoField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.suffixIcon,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0F172A),
          letterSpacing: 1.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: Color(0xFFCBD5E1),
            fontWeight: FontWeight.w400,
            fontSize: 14,
            letterSpacing: 0),
        prefixIcon: Icon(icon, size: 20, color: Go212Colors.primary700),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF16A34A), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class _SecureNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Go212Colors.primary100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.lock_rounded,
                size: 16, color: Color(0xFF16A34A)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Vos données sont chiffrées et sécurisées.\nConformité RGPD & lois marocaines.',
              style: TextStyle(
                  fontSize: 11.5, color: Color(0xFF166534), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡 Pourquoi la CIN ?',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B))),
          const SizedBox(height: 10),
          _TipRow(
            icon: Icons.shield_rounded,
            text: 'Sécuriser votre compte GoRide',
            color: Go212Colors.primary600,
          ),
          const SizedBox(height: 8),
          _TipRow(
            icon: Icons.two_wheeler_rounded,
            text: 'Louer un scooter en toute confiance',
            color: const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 8),
          _TipRow(
            icon: Icons.speed_rounded,
            text: 'Vérification en moins de 30 secondes',
            color: const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _TipRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF475569),
                  fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
