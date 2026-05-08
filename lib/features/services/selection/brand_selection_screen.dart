import 'package:flutter/material.dart';
import '../gowash/gowash_header.dart';
import 'order_scheduling_screen.dart';
import 'vehicle_model_selection_screen.dart';

class CarBrand {
  final String name;
  final String logoAsset;
  final bool isOther;
  
  CarBrand({
    required this.name,
    required this.logoAsset,
    this.isOther = false,
  });
}

// All brands synced exactly to assets/images/gowash/brands/ filenames (case-sensitive)
final List<CarBrand> _allBrands = [
  CarBrand(name: 'Alfa Romeo',  logoAsset: 'assets/images/gowash/brands/alfa romeo.png'),
  CarBrand(name: 'Audi',        logoAsset: 'assets/images/gowash/brands/audi.png'),
  CarBrand(name: 'BMW',         logoAsset: 'assets/images/gowash/brands/bmw.png'),
  CarBrand(name: 'Chevrolet',   logoAsset: 'assets/images/gowash/brands/chevrolet.png'),
  CarBrand(name: 'Cupra',       logoAsset: 'assets/images/gowash/brands/cupra.png'),
  CarBrand(name: 'Dacia',       logoAsset: 'assets/images/gowash/brands/dacia.png'),
  CarBrand(name: 'Fiat',        logoAsset: 'assets/images/gowash/brands/fiat.png'),
  CarBrand(name: 'Ford',        logoAsset: 'assets/images/gowash/brands/ford.png'),
  CarBrand(name: 'Honda',       logoAsset: 'assets/images/gowash/brands/honda.png'),
  CarBrand(name: 'Hyundai',     logoAsset: 'assets/images/gowash/brands/hyundai.png'),
  CarBrand(name: 'Jaguar',      logoAsset: 'assets/images/gowash/brands/JAGUAR.png'),
  CarBrand(name: 'Jeep',        logoAsset: 'assets/images/gowash/brands/jeep.png'),
  CarBrand(name: 'Kia',         logoAsset: 'assets/images/gowash/brands/kia.png'),
  CarBrand(name: 'Land Rover',  logoAsset: 'assets/images/gowash/brands/land rover.png'),
  CarBrand(name: 'Lexus',       logoAsset: 'assets/images/gowash/brands/lexus.png'),
  CarBrand(name: 'Mazda',       logoAsset: 'assets/images/gowash/brands/mazda.png'),
  CarBrand(name: 'Mercedes',    logoAsset: 'assets/images/gowash/brands/Mercedes.png'),
  CarBrand(name: 'MG',          logoAsset: 'assets/images/gowash/brands/mg.png'),
  CarBrand(name: 'Mini',        logoAsset: 'assets/images/gowash/brands/mini.png'),
  CarBrand(name: 'Mitsubishi',  logoAsset: 'assets/images/gowash/brands/mitsubishi.png'),
  CarBrand(name: 'Nissan',      logoAsset: 'assets/images/gowash/brands/nissan.png'),
  CarBrand(name: 'Opel',        logoAsset: 'assets/images/gowash/brands/opel.png'),
  CarBrand(name: 'Peugeot',     logoAsset: 'assets/images/gowash/brands/peugeot.png'),
  CarBrand(name: 'Porsche',     logoAsset: 'assets/images/gowash/brands/porsche.png'),
  CarBrand(name: 'Renault',     logoAsset: 'assets/images/gowash/brands/renault.png'),
  CarBrand(name: 'Seat',        logoAsset: 'assets/images/gowash/brands/seat.png'),
  CarBrand(name: 'Skoda',       logoAsset: 'assets/images/gowash/brands/skoda.png'),
  CarBrand(name: 'Suzuki',      logoAsset: 'assets/images/gowash/brands/suzuki.png'),
  CarBrand(name: 'Tesla',       logoAsset: 'assets/images/gowash/brands/tesla.png'),
  CarBrand(name: 'Toyota',      logoAsset: 'assets/images/gowash/brands/toyota.png'),
  CarBrand(name: 'Volvo',       logoAsset: 'assets/images/gowash/brands/volvo.png'),
  CarBrand(name: 'Volkswagen',  logoAsset: 'assets/images/gowash/brands/vw.png'),
  CarBrand(name: 'Autre marque', logoAsset: '', isOther: true),
];

class BrandSelectionScreen extends StatefulWidget {
  final String vehicleName;
  final String vehicleType;
  final String packName;
  final int selectedPackIndex;
  final double basePrice;

  const BrandSelectionScreen({
    super.key,
    required this.vehicleName,
    required this.vehicleType,
    required this.packName,
    required this.selectedPackIndex,
    this.basePrice = 60.0,
  });

  @override
  State<BrandSelectionScreen> createState() => _BrandSelectionScreenState();
}

class _BrandSelectionScreenState extends State<BrandSelectionScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<CarBrand> _filtered = _allBrands;
  int? _selectedBrandIndex;

  static const _green = Color(0xFF179B2E); // GoWash Official Green
  static const _bgGrey = Color(0xFFF8FAFB);

  void _onSearchChanged(String query) {
    setState(() {
      _filtered = _allBrands
          .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onContinue() {
    if (_selectedBrandIndex == null) return;
    
    final selectedBrand = _filtered[_selectedBrandIndex!];
    
    // NAVIGATION BYPASS: Directly to Scheduling (Date/Time Picker)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSchedulingScreen(
          brandName: selectedBrand.name,
          brandLogo: selectedBrand.logoAsset,
          vehicleType: widget.vehicleType,
          packName: widget.packName,
          basePrice: widget.basePrice,
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
            title: 'Quel véhicule ?',
            stepText: '2/4',
            onBack: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearchChanged,
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: 'Rechercher une marque...',
                  prefixIcon: Icon(Icons.search_rounded, color: _green),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                  hintStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty 
              ? const Center(child: Text('Aucun résultat'))
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
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
                          color: isSelected
                              ? _green.withOpacity(0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? _green : const Color(0xFFEEF0F3),
                            width: isSelected ? 2.0 : 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? _green.withOpacity(0.18)
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: isSelected ? 16 : 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Card content: logo + name
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: _buildBrandLogo(brand, isSelected),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 12, left: 6, right: 6),
                                  child: Text(
                                    brand.name.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.w900
                                          : FontWeight.w600,
                                      fontSize: 10,
                                      color: isSelected
                                          ? _green
                                          : const Color(0xFF64748B),
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Selected checkmark badge — top-right corner
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: _green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _selectedBrandIndex != null ? _onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                  shadowColor: _green.withOpacity(0.4),
                ),
                child: const Text(
                  'Continuer', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandLogo(CarBrand brand, bool isSelected) {
    if (brand.isOther) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_circle_outline_rounded,
            size: 34,
            color: isSelected ? _green : const Color(0xFF94A3B8),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 6),
      child: Image.asset(
        brand.logoAsset,
        height: 60,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.directions_car_filled_rounded,
          size: 32,
          color: isSelected ? _green : Colors.grey.shade300,
        ),
      ),
    );
  }
}
