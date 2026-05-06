import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_btn.dart';
import '../widgets/goride_header.dart';

class GoRidePaymentScreen extends StatefulWidget {
  const GoRidePaymentScreen({super.key});

  @override
  State<GoRidePaymentScreen> createState() => _GoRidePaymentScreenState();
}

class _GoRidePaymentScreenState extends State<GoRidePaymentScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedMethod;
  bool _isProcessing = false;
  late AnimationController _anim;
  late Animation<double> _fade;

  final _methods = [
    _PayMethod(
      key: 'cmi',
      label: 'Carte bancaire (CMI)',
      subLabel: 'Visa, Mastercard, CIB',
      icon: Icons.credit_card_rounded,
      color: Color(0xFF1D4ED8),
      badge: 'Sécurisé',
    ),
    _PayMethod(
      key: 'orange',
      label: 'Orange Money',
      subLabel: 'Paiement mobile',
      icon: Icons.phone_android_rounded,
      color: Color(0xFFEA580C),
      badge: null,
    ),
    _PayMethod(
      key: 'wafa',
      label: 'Wafacash',
      subLabel: 'Espèces via Wafacash',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF059669),
      badge: null,
    ),
    _PayMethod(
      key: 'cash',
      label: 'Paiement à la livraison',
      subLabel: 'Cash uniquement',
      icon: Icons.money_rounded,
      color: Color(0xFF64748B),
      badge: 'Disponible',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _processPayment(
      BuildContext context, GoRideBooking booking) async {
    if (_selectedMethod == null) return;
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    final updated = booking.copyWith(paymentMethod: _selectedMethod);
    Navigator.pushReplacementNamed(context, '/goride/booking/confirm',
        arguments: updated);
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context, booking),
          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    const Text('Mode de paiement',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B))),
                    const SizedBox(height: 14),
                    ..._methods.map((m) => _buildMethodCard(m)),
                    const SizedBox(height: 16),
                    _buildSecureBadge(),
                    const SizedBox(height: 12),
                    if (_selectedMethod != null) _buildSelectedMethodDetail(),
                  ],
                ),
              ),
            ),
          ),
          _buildFooter(context, booking),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GoRideBooking booking) {
    return GoRideHeader(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GoRideBackBtn(onTap: () => Navigator.pop(context)),
                  const Spacer(),
                  const GoRideMascotBadge(size: 36),
                  const SizedBox(width: 10),
                  const GoRideStepBadge(step: 6, total: 6),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Paiement',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              // ignore: deprecated_member_use
              Text('Choisissez votre mode de paiement',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 13)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.payments_rounded,
                        color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Montant total',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w500)),
                        Text(booking.pricePerUnit,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard(_PayMethod method) {
    final isSelected = _selectedMethod == method.key;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method.key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color:
              isSelected ? method.color.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? method.color : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: method.color.withValues(alpha: 0.12),
                      blurRadius: 14,
                      offset: const Offset(0, 4))
                ]
              : [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2))
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isSelected
                    ? method.color.withValues(alpha: 0.12)
                    : method.color.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(method.icon, size: 22, color: method.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(method.label,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B))),
                      if (method.badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: method.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(method.badge!,
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: method.color)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(method.subLabel,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? method.color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? method.color : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      size: 13, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecureBadge() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Go212Colors.primary200),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_rounded, size: 18, color: Go212Colors.primary600),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Paiement 100% sécurisé · Certifié CMI Maroc · Chiffrement SSL',
              style: TextStyle(
                  fontSize: 11, color: Color(0xFF15803D), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMethodDetail() {
    final method = _methods.firstWhere((m) => m.key == _selectedMethod);
    if (_selectedMethod == 'cmi') {
      return _buildCmiForm(method);
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: method.color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: method.color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 18, color: method.color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _selectedMethod == 'cash'
                  ? 'Le paiement s\'effectue à la réception de la moto.'
                  : 'Vous recevrez les instructions de paiement après confirmation.',
              style: TextStyle(
                  fontSize: 12,
                  color: method.color.withValues(alpha: 0.9),
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCmiForm(_PayMethod method) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: method.color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: method.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Données carte',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B))),
          const SizedBox(height: 12),
          _CmiField(
              hint: '4539 •••• •••• ••••',
              label: 'Numéro de carte',
              icon: Icons.credit_card_rounded),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: _CmiField(
                    hint: 'MM/AA',
                    label: 'Expiration',
                    icon: Icons.event_rounded)),
            const SizedBox(width: 10),
            Expanded(
                child: _CmiField(
                    hint: '•••', label: 'CVV', icon: Icons.lock_rounded)),
          ]),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, GoRideBooking booking) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: GoRideBtn(
        label: _isProcessing ? '' : 'Payer maintenant',
        isLoading: _isProcessing,
        onTap: _selectedMethod != null && !_isProcessing
            ? () => _processPayment(context, booking)
            : null,
        icon: Icons.lock_rounded,
      ),
    );
  }
}

class _PayMethod {
  final String key, label, subLabel;
  final IconData icon;
  final Color color;
  final String? badge;
  const _PayMethod({
    required this.key,
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.color,
    this.badge,
  });
}

class _CmiField extends StatelessWidget {
  final String hint, label;
  final IconData icon;
  const _CmiField(
      {required this.hint, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B))),
        const SizedBox(height: 6),
        TextField(
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
            prefixIcon: Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
