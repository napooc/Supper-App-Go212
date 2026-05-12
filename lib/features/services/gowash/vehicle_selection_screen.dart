import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gowash_header.dart';
import '../../../core/theme/go212_colors.dart';
import 'gowash_pack_selection_screen.dart';
import 'moto_size_selection_screen.dart';

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

  static const _green = Go212Colors.primary500;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _btnCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _btnScale = Tween(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));
        
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
      case 0: destination = GoWashPackSelectionScreen(vehicleName: 'Citadine', packAssets: _citadinePacks); break;
      case 1: destination = GoWashPackSelectionScreen(vehicleName: 'Berline', packAssets: _berlinePacks); break;
      case 2: destination = GoWashPackSelectionScreen(vehicleName: 'SUV Moyen', packAssets: const [
          'assets/images/gowash/packs/suv_moyen_essential.png',
          'assets/images/gowash/packs/suv_moyen_extra.png',
          'assets/images/gowash/packs/suv_moyen_premium.png',
        ]); break;
      case 3: destination = GoWashPackSelectionScreen(vehicleName: 'Grand SUV', packAssets: const [
          'assets/images/gowash/packs/suv_grande_essentiel.png',
          'assets/images/gowash/packs/suv_grande_extra.png',
          'assets/images/gowash/packs/suv_grande_premium.png',
        ]); break;
      case 4: destination = const MotoSizeSelectionScreen(); break;
      default: return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Go212Colors.surfacePage,
      body: Column(
        children: [
          GoWashHeader(
            title: 'Type de véhicule',
            subtitle: 'Choisissez votre catégorie de véhicule',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: _buildGrid(),
          ),
          _buildCTA(),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _vehicles.length,
      itemBuilder: (context, i) {
        return _VehicleCard(
          vehicle: _vehicles[i],
          selected: _selected == i,
          onTap: () => setState(() => _selected = i),
        );
      },
    );
  }

  Widget _buildCTA() {
    final enabled = _selected != null;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPad + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, -4)),
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
              height: 56,
              decoration: BoxDecoration(
                color: enabled ? _green : Go212Colors.neutral200,
                borderRadius: BorderRadius.circular(16),
                boxShadow: enabled ? [BoxShadow(color: _green.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6))] : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    enabled ? 'Continuer · ${_vehicles[_selected!].label}' : 'Choisissez un véhicule',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: enabled ? Colors.white : Go212Colors.neutral400),
                  ),
                  if (enabled) ...[
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
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

class _VehicleCard extends StatefulWidget {
  final _Vehicle vehicle;
  final bool selected;
  final VoidCallback onTap;
  const _VehicleCard({required this.vehicle, required this.selected, required this.onTap});

  @override
  State<_VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<_VehicleCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  static const _green = Color(0xFF179B2E); // GoWash Official Green

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.94).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: sel ? _green : Colors.transparent, width: 3),
            boxShadow: [
              BoxShadow(
                color: sel ? _green.withOpacity(0.1) : Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Image.asset(widget.vehicle.asset, fit: BoxFit.contain)),
                const SizedBox(height: 12),
                Text(widget.vehicle.label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: sel ? _green : Go212Colors.neutral800)),
                Text(widget.vehicle.subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Go212Colors.neutral500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
