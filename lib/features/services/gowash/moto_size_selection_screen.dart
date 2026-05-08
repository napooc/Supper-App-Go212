import 'package:flutter/material.dart';
import 'gowash_pack_selection_screen.dart';
import 'gowash_header.dart';

class MotoSizeSelectionScreen extends StatefulWidget {
  const MotoSizeSelectionScreen({super.key});

  @override
  State<MotoSizeSelectionScreen> createState() => _MotoSizeSelectionScreenState();
}

class _MotoSizeSelectionScreenState extends State<MotoSizeSelectionScreen> {
  String? _selectedSize;

  static const _primaryGreen = Color(0xFF179B2E);
  static const _bgGrey = Color(0xFFF8FAFB);

  void _onContinue() {
    if (_selectedSize == null) return;

    final packAsset = _selectedSize == 'Petite Moto'
        ? 'assets/images/gowash/packs/petite_moto.png'
        : 'assets/images/gowash/packs/grande_moto.png';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoWashPackSelectionScreen(
          vehicleName: 'Moto ($_selectedSize)',
          packAssets: [packAsset],
          stepNumber: 2, // Moto: size=1/4, pack=2/4, schedule=3/4, confirm=4/4
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      body: Column(
        children: [
          GoWashHeader(
            title: 'Choix de la taille',
            subtitle: 'Sélectionnez la catégorie de votre moto',
            stepText: '1/4',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSizeCard('Petite Moto', 'Moins de 500cc'),
                    const SizedBox(height: 20),
                    _buildSizeCard('Grande Moto', 'Plus de 500cc'),
                    const SizedBox(height: 40),
                    _buildContinueButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeCard(String title, String subtitle) {
    final isSelected = _selectedSize == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedSize = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryGreen : const Color(0xFFE2E8F0),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? _primaryGreen.withOpacity(0.12)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _bgGrey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset('assets/images/moto.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? _primaryGreen : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: _primaryGreen, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final enabled = _selectedSize != null;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: enabled ? _onContinue : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          'Continuer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
    );
  }
}
