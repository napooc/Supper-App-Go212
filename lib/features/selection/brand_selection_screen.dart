import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// ═══════════════════════════════════════════════════════════════
// DATA MODEL
// ═══════════════════════════════════════════════════════════════

class CarBrand {
  final String name;
  final String logoAsset;
  const CarBrand({required this.name, required this.logoAsset});
}

const List<CarBrand> _allBrands = [
  CarBrand(name: 'Toyota', logoAsset: 'assets/images/gowash/brands/toyota.png'),
  CarBrand(name: 'Dacia', logoAsset: 'assets/images/gowash/brands/dacia.png'),
  CarBrand(name: 'Renault', logoAsset: 'assets/images/gowash/brands/renault.png'),
  CarBrand(name: 'Peugeot', logoAsset: 'assets/images/gowash/brands/peugeot.png'),
  CarBrand(name: 'Volkswagen', logoAsset: 'assets/images/gowash/brands/vw.png'),
  CarBrand(name: 'Mercedes', logoAsset: 'assets/images/gowash/brands/mercedes.png'),
  CarBrand(name: 'BMW', logoAsset: 'assets/images/gowash/brands/bmw.png'),
  CarBrand(name: 'Audi', logoAsset: 'assets/images/gowash/brands/audi.png'),
  CarBrand(name: 'Hyundai', logoAsset: 'assets/images/gowash/brands/hyundai.png'),
  CarBrand(name: 'Kia', logoAsset: 'assets/images/gowash/brands/kia.png'),
  CarBrand(name: 'Fiat', logoAsset: 'assets/images/gowash/brands/fiat.png'),
  CarBrand(name: 'Ford', logoAsset: 'assets/images/gowash/brands/ford.png'),
  CarBrand(name: 'Honda', logoAsset: 'assets/images/gowash/brands/honda.png'),
  CarBrand(name: 'Nissan', logoAsset: 'assets/images/gowash/brands/nissan.png'),
  CarBrand(name: 'Citroën', logoAsset: 'assets/images/gowash/brands/citroen.png'),
  CarBrand(name: 'Jeep', logoAsset: 'assets/images/gowash/brands/jeep.png'),
  CarBrand(name: 'Range Rover', logoAsset: 'assets/images/gowash/brands/land_rover.png'),
  CarBrand(name: 'Porsche', logoAsset: 'assets/images/gowash/brands/porsche.png'),
];

// ═══════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════

class BrandSelectionScreen extends StatefulWidget {
  final String vehicleName;
  final int selectedPackIndex;

  const BrandSelectionScreen({
    super.key,
    required this.vehicleName,
    required this.selectedPackIndex,
  });

  @override
  State<BrandSelectionScreen> createState() => _BrandSelectionScreenState();
}

class _BrandSelectionScreenState extends State<BrandSelectionScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<CarBrand> _filtered = _allBrands;
  int? _selectedBrandIndex;

  static const _green = Color(0xFF059669);
  static const _green50 = Color(0xFFECFDF5);

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _allBrands
          .where((b) => b.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _onContinue() {
    if (_selectedBrandIndex == null) return;
    // In a real app, we would navigate to the detail screen here
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildBrandGrid()),
            _buildCTA(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _BackBtn(),
              const Spacer(),
              _StepIndicator(current: 2, total: 4),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'Quelle est la marque\nde votre véhicule ?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sélectionnez votre marque pour un service sur mesure.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0).withOpacity(0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          controller: _searchCtrl,
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: 'Rechercher une marque…',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400,
            ),
            prefixIcon: const Icon(Iconsax.search_normal, size: 20, color: _green),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandGrid() {
    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.search_status, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Aucune marque trouvée',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final brand = _filtered[index];
        final isSelected = _selectedBrandIndex == index;

        return GestureDetector(
          onTap: () => setState(() => _selectedBrandIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? _green50 : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? _green : const Color(0xFFE2E8F0),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? _green.withOpacity(0.1)
                      : Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.directions_car_filled_rounded,
                      size: 32,
                      color: isSelected ? _green : Colors.grey.shade300,
                    ),
                  ),
                ),
                Text(
                  brand.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? _green : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCTA() {
    final enabled = _selectedBrandIndex != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -4))
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: enabled ? _onContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _green,
            disabledBackgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: Text(
            enabled ? 'Continuer' : 'Sélectionnez une marque',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: const Icon(Icons.arrow_back_rounded, size: 20),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final active = i == current;
        final done = i < current;
        return Container(
          margin: const EdgeInsets.only(left: 4),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: (active || done) ? const Color(0xFF059669) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
