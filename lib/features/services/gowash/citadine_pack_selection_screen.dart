import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gowash_header.dart';
import '../../../core/theme/go212_colors.dart';
import 'package:go212/features/services/selection/brand_selection_screen.dart';

// ═══════════════════════════════════════════════════════════════
// DATA  — only the asset path is needed; the image carries all info
// ═══════════════════════════════════════════════════════════════

const _packAssets = [
  'assets/images/gowash/packs/citadine_essential.png',
  'assets/images/gowash/packs/citadine_extra.png',
  'assets/images/gowash/packs/citadine_premium.png',
];

// ═══════════════════════════════════════════════════════════════
// SCREEN
// ═══════════════════════════════════════════════════════════════

class CitadinePackSelectionScreen extends StatefulWidget {
  const CitadinePackSelectionScreen({super.key});

  @override
  State<CitadinePackSelectionScreen> createState() =>
      _CitadinePackSelectionScreenState();
}

class _CitadinePackSelectionScreenState
    extends State<CitadinePackSelectionScreen>
    with SingleTickerProviderStateMixin {
  int? _selected;
  late AnimationController _btnCtrl;
  late Animation<double> _btnScale;

  static const _green = Color(0xFF179B2E);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _btnScale = Tween(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.easeInOut));

    // Pre-warm all pack images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final asset in _packAssets) {
        precacheImage(AssetImage(asset), context);
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
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => BrandSelectionScreen(
          vehicleName: 'Citadine',
          vehicleType: 'Citadine',
          selectedPackIndex: _selected!,
        ),
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
      backgroundColor: Go212Colors.surfacePage,
      body: Column(
        children: [
          GoWashHeader(
            title: 'Choisissez votre formule',
            stepText: '1/4',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(child: _buildPackList()),
          _buildCTA(),
        ],
      ),
    );
  }

  // ─── Pack list — 3 large image cards ─────────────────────────
  Widget _buildPackList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: _packAssets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _PackImageCard(
        asset: _packAssets[i],
        selected: _selected == i,
        onTap: () => setState(() => _selected = i),
      ),
    );
  }

  // ─── Bottom CTA ──────────────────────────────────────────────
  Widget _buildCTA() {
    final enabled = _selected != null;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomPad + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
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
              height: 56,
              decoration: BoxDecoration(
                color: enabled ? _green : Go212Colors.neutral200,
                borderRadius: BorderRadius.circular(16),
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: _green.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    enabled ? 'Continuer' : 'Choisissez une formule',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: enabled ? Colors.white : Go212Colors.neutral400,
                    ),
                  ),
                  if (enabled) ...[
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 20),
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

class _PackImageCard extends StatefulWidget {
  final String asset;
  final bool selected;
  final VoidCallback onTap;

  const _PackImageCard({
    required this.asset,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_PackImageCard> createState() => _PackImageCardState();
}

class _PackImageCardState extends State<_PackImageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  static const _green = Color(0xFF179B2E); // GoWash Official Green

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.98)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.selected ? _green : Colors.transparent,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.selected ? _green.withOpacity(0.1) : Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    widget.asset,
                    fit: BoxFit.contain,
                  ),
                ),
                if (widget.selected)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: _green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
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
