import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gowash_detail_screen.dart';

// ═══════════════════════════════════════════════════════════════
// CAR BRAND SELECTION SCREEN — Step 2 of 4
// Displays a searchable grid of car brands for the user to pick.
// ═══════════════════════════════════════════════════════════════

// ─── Brand data model ─────────────────────────────────────────
class CarBrand {
  final String name;
  final String logoAsset; // asset path for the brand logo

  const CarBrand({required this.name, required this.logoAsset});
}

// ─── Brand catalog (easy to extend) ──────────────────────────
const List<CarBrand> _allBrands = [
  CarBrand(name: 'Toyota',        logoAsset: 'assets/images/gowash/brands/toyota.png'),
  CarBrand(name: 'Dacia',         logoAsset: 'assets/images/gowash/brands/dacia.png'),
  CarBrand(name: 'Renault',       logoAsset: 'assets/images/gowash/brands/renault.png'),
  CarBrand(name: 'Peugeot',       logoAsset: 'assets/images/gowash/brands/peugeot.png'),
  CarBrand(name: 'Volkswagen',    logoAsset: 'assets/images/gowash/brands/volkswagen.png'),
  CarBrand(name: 'Hyundai',       logoAsset: 'assets/images/gowash/brands/hyundai.png'),
  CarBrand(name: 'Mercedes-Benz', logoAsset: 'assets/images/gowash/brands/mercedes.png'),
  CarBrand(name: 'BMW',           logoAsset: 'assets/images/gowash/brands/bmw.png'),
  CarBrand(name: 'Audi',          logoAsset: 'assets/images/gowash/brands/audi.png'),
  CarBrand(name: 'Citroën',       logoAsset: 'assets/images/gowash/brands/citroen.png'),
  CarBrand(name: 'Fiat',          logoAsset: 'assets/images/gowash/brands/fiat.png'),
  CarBrand(name: 'Kia',           logoAsset: 'assets/images/gowash/brands/kia.png'),
  CarBrand(name: 'Ford',          logoAsset: 'assets/images/gowash/brands/ford.png'),
  CarBrand(name: 'Opel',          logoAsset: 'assets/images/gowash/brands/opel.png'),
  CarBrand(name: 'Nissan',        logoAsset: 'assets/images/gowash/brands/nissan.png'),
  CarBrand(name: 'Škoda',         logoAsset: 'assets/images/gowash/brands/skoda.png'),
  CarBrand(name: 'SEAT',          logoAsset: 'assets/images/gowash/brands/seat.png'),
  CarBrand(name: 'Honda',         logoAsset: 'assets/images/gowash/brands/honda.png'),
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

class _BrandSelectionScreenState extends State<BrandSelectionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  List<CarBrand> _filtered = List.of(_allBrands);
  int? _selectedIndex;

  late AnimationController _btnCtrl;
  late Animation<double> _btnScale;

  static const _green = Color(0xFF059669);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _btnScale = Tween(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));

    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  // ─── Search filter ──────────────────────────────────────────
  void _onSearch() {
    final query = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _selectedIndex = null; // reset selection on new search
      _filtered = query.isEmpty
          ? List.of(_allBrands)
          : _allBrands
              .where((b) => b.name.toLowerCase().contains(query))
              .toList();
    });
  }

  // ─── Continue to next screen ────────────────────────────────
  void _onContinue() {
    if (_selectedIndex == null) return;
    final brand = _filtered[_selectedIndex!];

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const GoWashDetailScreen(),
        transitionsBuilder: (_, a, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
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
            Expanded(child: _buildBrandGrid()),
            _buildCTA(),
          ],
        ),
      ),
    );
  }

  // ─── Header ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + step indicator
          Row(
            children: [
              _BackBtn(),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Changer de formule',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _green,
                  ),
                ),
              ),
              const Spacer(),
              const _StepIndicator(current: 2, total: 4),
            ],
          ),
          const SizedBox(height: 18),
          // Vehicle + Pack badge row
          Row(
            children: [
              _InfoBadge(
                icon: Icons.directions_car_rounded,
                label: widget.vehicleName,
              ),
              const SizedBox(width: 8),
              _InfoBadge(
                icon: Icons.auto_awesome_rounded,
                label: 'Pack ${widget.selectedPackIndex + 1}',
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Quelle est la marque\nde votre véhicule ?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              height: 1.25,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sélectionnez la marque pour continuer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── Search bar ─────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
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
                prefixIcon: Icon(Icons.search_rounded,
                    size: 22, color: _green.withOpacity(0.7)),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded,
                              size: 16, color: Colors.grey),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          if (_searchCtrl.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Résultats pour "${_searchCtrl.text}"',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_filtered.length} marques',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _green,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ─── Brand grid ─────────────────────────────────────────────
  Widget _buildBrandGrid() {
    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Aucune marque trouvée',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Essayez un autre terme',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: _filtered.length,
      itemBuilder: (_, i) => _BrandCard(
        brand: _filtered[i],
        selected: _selectedIndex == i,
        onTap: () => setState(() => _selectedIndex = i),
      ),
    );
  }

  // ─── Bottom CTA ─────────────────────────────────────────────
  Widget _buildCTA() {
    final enabled = _selectedIndex != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _btnScale,
        builder: (_, __) => Transform.scale(
          scale: _btnScale.value,
          child: GestureDetector(
            onTapDown: enabled ? (_) => _btnCtrl.forward() : null,
            onTapUp: enabled
                ? (_) {
                    _btnCtrl.reverse();
                    _onContinue();
                  }
                : null,
            onTapCancel: () => _btnCtrl.reverse(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 54,
              decoration: BoxDecoration(
                gradient: enabled
                    ? const LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF047857)])
                    : LinearGradient(colors: [
                        Colors.grey.shade300,
                        Colors.grey.shade300,
                      ]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: _green.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    enabled
                        ? 'Continuer · ${_filtered[_selectedIndex!].name}'
                        : 'Choisissez une marque',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: enabled ? Colors.white : Colors.grey.shade500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (enabled) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BRAND CARD — modular, reusable widget
// ═══════════════════════════════════════════════════════════════

class _BrandCard extends StatefulWidget {
  final CarBrand brand;
  final bool selected;
  final VoidCallback onTap;

  const _BrandCard({
    required this.brand,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<_BrandCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  static const _green = Color(0xFF059669);
  static const _green50 = Color(0xFFECFDF5);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.94)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sel = widget.selected;
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: sel ? _green50 : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: sel ? _green : const Color(0xFFE2E8F0).withOpacity(0.6),
              width: sel ? 2.2 : 1.2,
            ),
            boxShadow: sel
                ? [
                    BoxShadow(
                      color: _green.withOpacity(0.14),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    )
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Selection Background Glow
                if (sel)
                  Positioned(
                    top: -20, right: -20,
                    child: Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: _green.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                
                // Main content: logo + name
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Brand logo
                      Expanded(
                        child: Center(
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            scale: sel ? 1.1 : 1.0,
                            child: Image.asset(
                              widget.brand.logoAsset,
                              width: 54,
                              height: 54,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, _) => Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: sel ? _green.withOpacity(0.1) : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.directions_car_filled_rounded,
                                  size: 28,
                                  color: sel ? _green : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Brand name
                      Text(
                        widget.brand.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: sel ? FontWeight.w800 : FontWeight.w600,
                          color: sel ? _green : const Color(0xFF1E293B),
                          letterSpacing: sel ? 0.1 : 0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Selected checkmark - more modern floating look
                if (sel)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (_, val, __) => Transform.scale(
                        scale: val,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: _green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                            ]
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// INFO BADGE (vehicle / pack context)
// ═══════════════════════════════════════════════════════════════

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoBadge({required this.icon, required this.label});

  static const _green = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6EE7B7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: _green),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _green,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP INDICATOR
// ═══════════════════════════════════════════════════════════════

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _StepIndicator({required this.current, required this.total});

  static const _green = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Étape ${current + 1}/$total',
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: _green),
        ),
        const SizedBox(width: 10),
        Row(
          children: List.generate(total, (i) {
            final active = i == current;
            final done = i < current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 5),
              width: active ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: (active || done) ? _green : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BACK BUTTON
// ═══════════════════════════════════════════════════════════════

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: const Icon(Icons.arrow_back_rounded,
            size: 20, color: Color(0xFF1E293B)),
      ),
    );
  }
}
