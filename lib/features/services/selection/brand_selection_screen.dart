import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../gowash/gowash_header.dart';
import 'order_scheduling_screen.dart';

class CarBrand {
  final String name;
  final String logoAsset;
  final bool isOther;
  const CarBrand({required this.name, required this.logoAsset, this.isOther = false});
}

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

class _BrandSelectionScreenState extends State<BrandSelectionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  List<CarBrand> _filtered = _allBrands;
  int? _selectedBrandIndex;
  late AnimationController _btnCtrl;
  late Animation<double> _btnScale;

  static const _green = Color(0xFF179B2E);
  static const _greenDark = Color(0xFF0F6B1E);
  static const _bgGrey = Color(0xFFF5F7FA);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _btnCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _btnScale = Tween(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _btnCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filtered = _allBrands
          .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _selectedBrandIndex = null;
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
          packName: widget.packName,
          basePrice: widget.basePrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final enabled = _selectedBrandIndex != null;
    final selectedBrand = enabled ? _filtered[_selectedBrandIndex!] : null;

    return Scaffold(
      backgroundColor: _bgGrey,
      body: Column(
        children: [
          // ── Header ──
          GoWashHeader(
            title: 'Votre marque',
            subtitle: 'Sélectionnez la marque de votre véhicule',
            stepText: '2/4',
            onBack: () => Navigator.pop(context),
          ),

          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 3))
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearchChanged,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Rechercher une marque...',
                  hintStyle: const TextStyle(color: Color(0xFFADB5BD), fontWeight: FontWeight.w500, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: _green, size: 20),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () { _searchCtrl.clear(); _onSearchChanged(''); },
                          child: const Icon(Icons.close_rounded, color: Color(0xFFADB5BD), size: 18),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // ── Brand count ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} marques disponibles',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF94A3B8)),
                ),
                const Spacer(),
                if (enabled)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '✓ ${selectedBrand!.name}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: _green),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ── Brand grid ──
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        const Text('Aucun résultat', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.fromLTRB(14, 4, 14, bottomPad + 96),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final brand = _filtered[index];
                      final isSelected = _selectedBrandIndex == index;
                      return _BrandCard(
                        brand: brand,
                        isSelected: isSelected,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedBrandIndex = index);
                        },
                      );
                    },
                  ),
          ),

          // ── CTA Button — always pinned above system nav bar ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -4)),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPad + 16),
            child: AnimatedBuilder(
              animation: _btnScale,
              builder: (_, __) => Transform.scale(
                scale: _btnScale.value,
                child: GestureDetector(
                  onTapDown: enabled ? (_) => _btnCtrl.forward() : null,
                  onTapUp: enabled ? (_) { _btnCtrl.reverse(); _onContinue(); } : null,
                  onTapCancel: () => _btnCtrl.reverse(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: enabled
                          ? const LinearGradient(
                              colors: [_greenDark, _green],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: enabled ? null : const Color(0xFFE9ECEF),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: enabled
                          ? [BoxShadow(color: _green.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 6))]
                          : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (enabled && selectedBrand != null && !selectedBrand.isOther) ...[
                          Container(
                            width: 28, height: 28,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                selectedBrand.logoAsset,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.directions_car_filled_rounded, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                        Text(
                          enabled
                              ? 'Continuer avec ${selectedBrand!.name}'
                              : 'Sélectionnez une marque',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: enabled ? Colors.white : const Color(0xFFADB5BD),
                          ),
                        ),
                        if (enabled) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Premium Brand Card ────────────────────────────────────────────
class _BrandCard extends StatefulWidget {
  final CarBrand brand;
  final bool isSelected;
  final VoidCallback onTap;
  const _BrandCard({required this.brand, required this.isSelected, required this.onTap});

  @override
  State<_BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<_BrandCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  static const _green = Color(0xFF179B2E);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.92).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final sel = widget.isSelected;
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: sel ? _green.withOpacity(0.04) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: sel ? _green : const Color(0xFFEDF0F5),
              width: sel ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: sel ? _green.withOpacity(0.15) : Colors.black.withOpacity(0.04),
                blurRadius: sel ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 14, 10, 4),
                      child: widget.brand.isOther
                          ? Center(
                              child: Icon(
                                Icons.add_circle_outline_rounded,
                                size: 36,
                                color: sel ? _green : const Color(0xFFCBD5E1),
                              ),
                            )
                          : Image.asset(
                              widget.brand.logoAsset,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.directions_car_filled_rounded,
                                size: 32,
                                color: sel ? _green : Colors.grey.shade300,
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                    child: Text(
                      widget.brand.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: sel ? FontWeight.w900 : FontWeight.w600,
                        fontSize: 9.5,
                        color: sel ? _green : const Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              // Selected check badge
              if (sel)
                Positioned(
                  top: 6, right: 6,
                  child: Container(
                    width: 18, height: 18,
                    decoration: const BoxDecoration(color: _green, shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
