import 'package:flutter/material.dart';
import 'order_scheduling_screen.dart';

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

// HARD SYNC: Brand names match exactly the filenames provided
final List<CarBrand> _allBrands = [
  CarBrand(name: 'audi', logoAsset: 'assets/images/gowash/brands/audi.png'),
  CarBrand(name: 'bmw', logoAsset: 'assets/images/gowash/brands/bmw.png'),
  CarBrand(name: 'dacia', logoAsset: 'assets/images/gowash/brands/dacia.png'),
  CarBrand(name: 'fiat', logoAsset: 'assets/images/gowash/brands/fiat.png'),
  CarBrand(name: 'ford', logoAsset: 'assets/images/gowash/brands/ford.png'),
  CarBrand(name: 'hyundai', logoAsset: 'assets/images/gowash/brands/hyundai.png'),
  CarBrand(name: 'kia', logoAsset: 'assets/images/gowash/brands/kia.png'),
  CarBrand(name: 'mercedes', logoAsset: 'assets/images/gowash/brands/mercedes.png'),
  CarBrand(name: 'peugeot', logoAsset: 'assets/images/gowash/brands/peugeot.png'),
  CarBrand(name: 'porsche', logoAsset: 'assets/images/gowash/brands/porsche.png'),
  CarBrand(name: 'toyota', logoAsset: 'assets/images/gowash/brands/toyota.png'),
  CarBrand(name: 'vw', logoAsset: 'assets/images/gowash/brands/vw.png'),
  CarBrand(name: 'Autre marque', logoAsset: '', isOther: true),
];

class BrandSelectionScreen extends StatefulWidget {
  final String vehicleName;
  final String vehicleType;
  final int selectedPackIndex;

  const BrandSelectionScreen({
    super.key,
    required this.vehicleName,
    required this.vehicleType,
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
  static const _bgGrey = Color(0xFFF5F5F5);

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
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSchedulingScreen(
          brandName: selectedBrand.name,
          brandLogo: selectedBrand.logoAsset,
          vehicleType: widget.vehicleType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Marque du véhicule',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Rechercher une marque...',
                  prefixIcon: Icon(Icons.search, color: _green),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty 
              ? const Center(child: Text('Aucun résultat'))
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final brand = _filtered[index];
                    final isSelected = _selectedBrandIndex == index;
                    
                    return GestureDetector(
                      onTap: () => setState(() => _selectedBrandIndex = index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected ? _green : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: _buildBrandLogo(brand, isSelected),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
                              child: Text(
                                brand.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, 
                                  fontSize: 12,
                                  color: isSelected ? _green : Colors.black87,
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
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _selectedBrandIndex != null ? _onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text(
                  'Continuer', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
      return Icon(
        Icons.help_outline_rounded, 
        size: 32, 
        color: isSelected ? _green : Colors.grey,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        brand.logoAsset,
        height: 50,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // SYNC FALLBACK: Display text name if image fails to load
          return Center(
            child: Text(
              brand.name.toUpperCase(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: isSelected ? _green : Colors.grey.shade400,
                letterSpacing: -0.5,
              ),
            ),
          );
        },
      ),
    );
  }
}
