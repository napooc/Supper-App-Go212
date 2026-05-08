import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeCheckoutScreen extends StatefulWidget {
  final String receptionMode; // 'delivery' or 'pickup'
  
  const GoBikeCheckoutScreen({super.key, this.receptionMode = 'delivery'});

  @override
  State<GoBikeCheckoutScreen> createState() => _GoBikeCheckoutScreenState();
}

class _GoBikeCheckoutScreenState extends State<GoBikeCheckoutScreen> {
  String _paymentMethod = 'Sélectionnez un moyen de paiement';
  String? _selectedPaymentType; // 'cash' or 'card'
  bool _isPromoApplied = false;
  String _promoError = '';
  final TextEditingController _promoController = TextEditingController();

  final Color primaryGreen = const Color(0xFF009933);
  final Color darkGreen = const Color(0xFF065F46);
  final Color bgColor = const Color(0xFFF6F7F8);

  // Mock Prices matching reference image
  double subtotal = 47.90;
  double discount = 0.0;
  double delivery = 0.0; 
  double fees = 5.00;
  bool _isPromoExpanded = false;

  double get total => (subtotal - discount) + delivery + fees;

  void _showPaymentModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildPaymentBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ─── PREMIUM IMAGE HEADER ───
          _buildHeader(),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // Payment Section Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Moyen de paiement', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
                    ),
                  ),

                  // CARD 1: Payment Method
                  _buildInteractiveCard(
                    title: _selectedPaymentType == null 
                        ? 'Choisissez votre mode de paiement'
                        : (_selectedPaymentType == 'cash' ? 'Payer en espèces' : 'Carte bancaire'),
                    subtitle: _selectedPaymentType == null 
                        ? 'Sélectionnez comment vous souhaitez payer' 
                        : 'Sélectionné',
                    icon: _selectedPaymentType == 'cash' ? Icons.payments : (_selectedPaymentType == 'card' ? Icons.credit_card : Icons.payment),
                    onTap: _showPaymentModal,
                    isSelected: _selectedPaymentType != null,
                    subtitleColor: _selectedPaymentType != null ? primaryGreen : Colors.grey.shade500,
                  ),

                  const SizedBox(height: 12),

                  // CARD 2: Promo Code
                  _buildInteractiveCard(
                    title: 'Vous avez un code promo ?',
                    subtitle: '',
                    icon: Icons.local_offer_outlined,
                    onTap: () => setState(() => _isPromoExpanded = !_isPromoExpanded),
                    isSelected: false,
                    rightWidget: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                      child: Icon(_isPromoExpanded ? Icons.keyboard_arrow_up : Icons.add_circle_outline, color: primaryGreen, size: 20),
                    ),
                  ),

                  // Expandable Promo Section
                  if (_isPromoExpanded) _buildPromoExpansion(),

                  const SizedBox(height: 20),

                  // Order Summary
                  _buildOrderSummary(),

                  const SizedBox(height: 100), // Space for sticky button
                ],
              ),
            ),
          ),
          
          // ─── FINAL CTA BUTTON ───
          _buildFinalCTA(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        // Using hero_header.png as fallback if _2 fails, but user wants _2 if possible.
        // I'll try _2 first as requested, but I'll add an errorBuilder to fallback to hero_header.png
        Image.asset(
          'assets/images/hero_header_2.png',
          width: double.infinity,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/hero_header.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            );
          },
        ),
        // Functional back button overlay
        Positioned(
          top: 30,
          left: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveCard({required String title, required String subtitle, required IconData icon, required VoidCallback onTap, bool isSelected = false, Widget? rightWidget, Color? subtitleColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 6))],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: isSelected ? primaryGreen.withOpacity(0.1) : bgColor, borderRadius: BorderRadius.circular(16)),
                child: Icon(icon, color: primaryGreen, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
                    if (subtitle.isNotEmpty) Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: subtitleColor ?? Colors.grey.shade500, fontWeight: subtitleColor != null ? FontWeight.bold : FontWeight.normal)),
                  ],
                ),
              ),
              rightWidget ?? Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoExpansion() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ajouter un bon', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Saisissez le code du bon', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 16),
          TextField(
            controller: _promoController,
            decoration: InputDecoration(
              hintText: 'Entrez votre code',
              hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: bgColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          if (_promoError.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.shade100)),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_promoError, style: GoogleFonts.poppins(color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('Veuillez vérifier et ré-essayer', style: GoogleFonts.poppins(color: Colors.red.shade300, fontSize: 11)),
                      ],
                    ),
                  ),
                  Icon(Icons.close, color: Colors.red.shade200, size: 16),
                ],
              ),
            ),
          ],
          if (_isPromoApplied) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: primaryGreen.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryGreen.withOpacity(0.1))),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Code appliqué avec succès !', style: GoogleFonts.poppins(color: darkGreen, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('Vous économisez 10,90 MAD', style: GoogleFonts.poppins(color: primaryGreen, fontSize: 11)),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_promoController.text.toUpperCase() == 'GOBIKE10') {
                    _isPromoApplied = true;
                    _promoError = '';
                    discount = 10.90;
                  } else {
                    _isPromoApplied = false;
                    _promoError = 'Ce code promo n’existe pas';
                    discount = 0.0;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text('Appliquer', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Récapitulatif de la commande', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
              Image.asset('assets/images/hero_header.png', width: 50, height: 40, fit: BoxFit.contain),
            ],
          ),
          const SizedBox(height: 20),
          _buildSummaryRow('Produits', '${subtotal.toStringAsFixed(2)} MAD'),
          _buildSummaryRow('Promotions', '-${discount.toStringAsFixed(2)} MAD', isDiscount: true),
          _buildSummaryRow('Sous-total', '${(subtotal - discount).toStringAsFixed(2)} MAD', isBold: true),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1)),
          _buildSummaryRow('Livraison', '0,00 MAD', isGreen: true, labelSuffix: 'GRATUIT'),
          _buildSummaryRow('Frais de service', '${fees.toStringAsFixed(2)} MAD', showInfo: true),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total à payer', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('${total.toStringAsFixed(2)} MAD', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen)),
            ],
          ),
          const SizedBox(height: 20),
          // Savings Box
          _buildSavingsBox(),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false, bool isBold = false, bool isGreen = false, bool showInfo = false, String? labelSuffix}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 14, color: isBold ? Colors.black : Colors.grey.shade600, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
              if (showInfo) ...[const SizedBox(width: 4), const Icon(Icons.info_outline, size: 14, color: Colors.grey)],
              if (labelSuffix != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(labelSuffix, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: primaryGreen)),
                ),
              ],
            ],
          ),
          Text(value, style: GoogleFonts.poppins(fontSize: 14, color: isDiscount ? primaryGreen : (isBold ? Colors.black : Colors.black87), fontWeight: isBold || isDiscount ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildSavingsBox() {
    double saved = discount + (delivery == 0 ? 10.0 : 0.0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: primaryGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.savings, color: Color(0xFFDAA520), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Vous économisez ${saved.toStringAsFixed(2)} MAD sur cette commande',
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: darkGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [primaryGreen, darkGreen]),
          boxShadow: [BoxShadow(color: primaryGreen.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: ElevatedButton(
          onPressed: _selectedPaymentType != null ? () {
            Navigator.pushNamed(
              context, 
              '/service/gobike/success',
              arguments: widget.receptionMode,
            );
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.verified_user, color: Colors.white, size: 24),
              const Expanded(
                child: Center(
                  child: Text('Confirmer la réservation', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.arrow_forward, color: darkGreen, size: 20),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Choisissez votre moyen de paiement', 
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: const Icon(Icons.close, size: 20, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPaymentOption(
            icon: Icons.money, // Updated to money icon
            iconColor: Colors.green,
            title: 'Payer en espèces',
            subtitle: 'Payez en espèces à la livraison ou en agence',
            onTap: () {
              setState(() {
                _selectedPaymentType = 'cash';
                _paymentMethod = 'Payer en espèces';
              });
              Navigator.pop(context);
            },
            isSelected: _selectedPaymentType == 'cash',
          ),
          const SizedBox(height: 12),
          _buildPaymentOption(
            icon: Icons.credit_card_outlined,
            iconColor: Colors.grey.shade700,
            title: 'Ajouter une nouvelle carte',
            subtitle: 'Ajoutez une carte bancaire pour un paiement sécurisé',
            onTap: () async {
              Navigator.pop(context);
              await Navigator.pushNamed(context, '/service/gobike/add-card');
              setState(() {
                _selectedPaymentType = 'card';
                _paymentMethod = 'Carte bancaire';
              });
            },
            isSelected: _selectedPaymentType == 'card',
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text('Paiement 100% sécurisé', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({required IconData icon, required Color iconColor, required String title, required String subtitle, required VoidCallback onTap, bool isSelected = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            if (isSelected) 
              const Icon(Icons.check_circle, color: Colors.green, size: 24) 
            else 
              Container(
                width: 24, 
                height: 24, 
                decoration: BoxDecoration(
                  shape: BoxShape.circle, 
                  border: Border.all(color: Colors.grey.shade300, width: 2)
                ),
              ),
          ],
        ),
      ),
    );
  }
}
