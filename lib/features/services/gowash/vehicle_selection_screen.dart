import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gowash_detail_screen.dart';
import 'citadine_pack_selection_screen.dart';
import 'gowash_pack_selection_screen.dart';

// ═══════════════════════════════════════════════════════════════
// DATA
// ═══════════════════════════════════════════════════════════════

class _Vehicle {
  final String label;
  final String asset;
  final String subtitle;
  const _Vehicle(this.label, this.asset, this.subtitle);
}

const _vehicles = [
  _Vehicle('Citadine',  'assets/images/gowash/citadine.png',  'Petite ville'),
  _Vehicle('Berline',   'assets/images/gowash/berline.png',   'Confort & Style'),
  _Vehicle('SUV Moyen', 'assets/images/gowash/suv_moyen.png', 'Espace & Puissance'),
  _Vehicle('Grand SUV', 'assets/images/gowash/grand_suv.png', 'Famille XL'),
  _Vehicle('Moto',      'assets/images/gowash/moto.png',      'Deux roues'),
];

// ═══════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════

class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen>
    with SingleTickerProviderStateMixin {
  int? _selected;
  late AnimationController _btnCtrl;
  late Animation<double> _btnScale;

  static const _green   = Color(0xFF059669);
  static const _green50 = Color(0xFFECFDF5);
  static const _green100= Color(0xFFD1FAE5);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _btnCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _btnScale = Tween(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));
    // Pre-warm all vehicle images so they're ready before the grid renders.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final v in _vehicles) {
        precacheImage(AssetImage(v.asset), context);
      }
    });
  }

  @override
  void dispose() {
    _btnCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_selected == null) return;

    // Pack assets per vehicle (index matches _vehicles list)
    const _citadinePacks = [
      'assets/images/gowash/packs/citadine_essential.png',
      'assets/images/gowash/packs/citadine_extra.png',
      'assets/images/gowash/packs/citadine_premium.png',
    ];
    const _berlinePacks = [
      'assets/images/gowash/packs/berline_essential.png',
      'assets/images/gowash/packs/berline_extra.png',
      'assets/images/gowash/packs/berline_premium.png',
    ];

    Widget destination;
    switch (_selected) {
      case 0: // Citadine
        destination = GoWashPackSelectionScreen(
          vehicleName: 'Citadine',
          packAssets: _citadinePacks,
        );
        break;
      case 1: // Berline
        destination = GoWashPackSelectionScreen(
          vehicleName: 'Berline',
          packAssets: _berlinePacks,
        );
        break;
      case 2: // SUV Moyen
        destination = GoWashPackSelectionScreen(
          vehicleName: 'SUV Moyen',
          packAssets: const [
            'assets/images/gowash/packs/suv_moyen_essential.png',
            'assets/images/gowash/packs/suv_moyen_extra.png',
            'assets/images/gowash/packs/suv_moyen_premium.png',
          ],
        );
        break;
      case 3: // Grand SUV
        destination = GoWashPackSelectionScreen(
          vehicleName: 'Grand SUV',
          packAssets: const [
            'assets/images/gowash/packs/suv_grande_essentiel.png',
            'assets/images/gowash/packs/suv_grande_extra.png',
            'assets/images/gowash/packs/suv_grande_premium.png',
          ],
        );
        break;
      case 4: // Moto — size selection (Petite / Grande)
        destination = GoWashPackSelectionScreen(
          vehicleName: 'Moto',
          packAssets: const [
            'assets/images/gowash/packs/petite_moto.png',
            'assets/images/gowash/packs/grande_moto.png',
          ],
        );
        break;
      default:
        destination = const GoWashDetailScreen();
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => destination,
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
            Expanded(child: _buildGrid()),
            _buildCTA(),
          ],
        ),
      ),
    );
  }

  // ─── Header: back + progress + title ───────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + step indicator row
          Row(
            children: [
              _BackBtn(),
              const Spacer(),
              _StepIndicator(current: 0, total: 4),
            ],
          ),
          const SizedBox(height: 24),
          // Title
          const Text(
            'Quel est votre type\nde véhicule ?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              height: 1.25,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sélectionnez le véhicule à laver',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ─── Vehicle grid ───────────────────────────────────────────────
  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.88,
      ),
      itemCount: _vehicles.length,
      itemBuilder: (context, i) {
        // Moto (last item, index 4) spans full width as a single centered card
        if (i == 4) {
          return _buildMotoRow();
        }
        return _VehicleCard(
          vehicle: _vehicles[i],
          selected: _selected == i,
          onTap: () => setState(() => _selected = i),
        );
      },
    );
  }

  // Moto is the 5th vehicle — displayed as a centered wide card
  Widget _buildMotoRow() {
    // GridView calls itemBuilder for index 4 in a 2-column layout,
    // so this cell naturally sits in column 0. We return a widget that
    // fills both columns via negative left/right margin trick.
    return _VehicleCard(
      vehicle: _vehicles[4],
      selected: _selected == 4,
      onTap: () => setState(() => _selected = 4),
      wide: true,
    );
  }

  // ─── Bottom CTA ─────────────────────────────────────────────────
  Widget _buildCTA() {
    final enabled = _selected != null;
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
            onTapUp: enabled ? (_) { _btnCtrl.reverse(); _onContinue(); } : null,
            onTapCancel: () => _btnCtrl.reverse(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 54,
              decoration: BoxDecoration(
                gradient: enabled
                    ? const LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF047857)])
                    : LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade300]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: enabled
                    ? [BoxShadow(color: _green.withOpacity(0.35),
                        blurRadius: 16, offset: const Offset(0, 6))]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    enabled
                        ? 'Continuer · ${_vehicles[_selected!].label}'
                        : 'Choisissez un véhicule',
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
// VEHICLE CARD
// ═══════════════════════════════════════════════════════════════

class _VehicleCard extends StatefulWidget {
  final _Vehicle vehicle;
  final bool selected;
  final VoidCallback onTap;
  final bool wide;
  const _VehicleCard({
    required this.vehicle,
    required this.selected,
    required this.onTap,
    this.wide = false,
  });

  @override
  State<_VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<_VehicleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  static const _green   = Color(0xFF059669);
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
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final sel = widget.selected;
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: sel ? _green50 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: sel ? _green : const Color(0xFFE2E8F0),
              width: sel ? 2.5 : 1.5,
            ),
            boxShadow: sel
                ? [BoxShadow(color: _green.withOpacity(0.18),
                    blurRadius: 20, offset: const Offset(0, 6))]
                : [BoxShadow(color: Colors.black.withOpacity(0.05),
                    blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Selection badge
                Align(
                  alignment: Alignment.topRight,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: sel
                        ? Container(
                            key: const ValueKey('check'),
                            width: 22, height: 22,
                            decoration: const BoxDecoration(
                              color: _green, shape: BoxShape.circle),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 13),
                          )
                        : const SizedBox(width: 22, height: 22,
                            key: ValueKey('empty')),
                  ),
                ),
                const SizedBox(height: 4),
                // Vehicle image — always Image.asset, no icon fallback
                Expanded(
                  child: Image.asset(
                    widget.vehicle.asset,
                    width: 90,
                    height: 90,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'IMAGE ERROR',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              widget.vehicle.asset.split('/').last,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // Label
                Text(
                  widget.vehicle.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: sel ? _green : const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.vehicle.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: sel ? const Color(0xFF059669) : Colors.grey.shade500,
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
// STEP INDICATOR
// ═══════════════════════════════════════════════════════════════

class _StepIndicator extends StatelessWidget {
  final int current; // 0-indexed
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
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _green,
          ),
        ),
        const SizedBox(width: 10),
        Row(
          children: List.generate(total, (i) {
            final active = i == current;
            final done   = i < current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 5),
              width:  active ? 24 : 8,
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
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: const Icon(Icons.arrow_back_rounded,
            size: 20, color: Color(0xFF1E293B)),
      ),
    );
  }
}
