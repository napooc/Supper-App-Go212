import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static const _green = Color(0xFF059669);

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
      backgroundColor: const Color(0xFFF8FAFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildPackList()),
            _buildCTA(),
          ],
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back row
          Row(
            children: [
              _BackBtn(),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Changer de véhicule',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _green,
                  ),
                ),
              ),
              const Spacer(),
              _StepIndicator(current: 1, total: 4),
            ],
          ),
          const SizedBox(height: 22),
          // Vehicle chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF6EE7B7)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.directions_car_rounded, size: 13, color: _green),
                SizedBox(width: 6),
                Text(
                  'Citadine',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Choisissez votre formule',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Pack list — 3 large image cards ─────────────────────────
  Widget _buildPackList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      physics: const BouncingScrollPhysics(),
      itemCount: _packAssets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
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
                    enabled ? 'Continuer' : 'Choisissez une formule',
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
// PACK IMAGE CARD — image is the entire card content
// ═══════════════════════════════════════════════════════════════

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

  static const _green = Color(0xFF059669);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.97)
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
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.selected ? _green : const Color(0xFFE2E8F0),
              width: widget.selected ? 3 : 1.5,
            ),
            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: _green.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // ── Full-width pack image ──
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    widget.asset,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 130,
                        color: Colors.grey.shade100,
                        child: Center(
                          child: Text(
                            'IMAGE ERROR\n${widget.asset.split('/').last}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Selected checkmark badge ──
                if (widget.selected)
                  Positioned(
                    top: 10,
                    right: 10,
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
                        size: 16,
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
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _green,
          ),
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
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: const Icon(Icons.arrow_back_rounded,
            size: 20, color: Color(0xFF1E293B)),
      ),
    );
  }
}
