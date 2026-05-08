import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeAddCardScreen extends StatefulWidget {
  const GoBikeAddCardScreen({super.key});

  @override
  State<GoBikeAddCardScreen> createState() => _GoBikeAddCardScreenState();
}

class _GoBikeAddCardScreenState extends State<GoBikeAddCardScreen> {
  final Color primaryGreen = const Color(0xFF009933);
  final Color darkGreen = const Color(0xFF065F46);
  final Color bgColor = const Color(0xFFF6F7F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── PREMIUM HERO HEADER WITH IMAGE ───
            Stack(
              children: [
                Image.asset(
                  'assets/images/hero_carte.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                // Functional back button overlay (Invisible but captures taps over the image's arrow)
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
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
            const SizedBox(height: 8),

            // ─── FORM FIELDS ───
            _buildInputField('Numéro de carte', '0000 0000 0000 0000', icon: Icons.credit_card),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildInputField('MM / YY', '12/28')),
                const SizedBox(width: 16),
                Expanded(child: _buildInputField('CVC', '123', icon: Icons.help_outline)),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField('Nom du titulaire', 'Ahmed Benali'),
            const SizedBox(height: 16),
            _buildInputField('Surnom de la carte (facultatif)', 'Ma carte principale'),
            
            const SizedBox(height: 40),

            // ─── TERMINER BUTTON ───
            SizedBox(
              width: double.infinity,
              height: 58,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(colors: [primaryGreen, darkGreen]),
                  boxShadow: [BoxShadow(color: primaryGreen.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Terminer', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
);
  }


  Widget _buildInputField(String label, String hint, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
              suffixIcon: icon != null ? Icon(icon, color: Colors.grey.shade300, size: 20) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade100)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: primaryGreen, width: 1.5)),
            ),
          ),
        ),
      ],
    );
  }
}
