import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeDeliveryChoiceScreen extends StatefulWidget {
  const GoBikeDeliveryChoiceScreen({super.key});

  @override
  State<GoBikeDeliveryChoiceScreen> createState() => _GoBikeDeliveryChoiceScreenState();
}

class _GoBikeDeliveryChoiceScreenState extends State<GoBikeDeliveryChoiceScreen> {
  // Default to 'delivery' so the confirm button is active from the start
  String _expandedOption = 'delivery';
  bool _showMapPicker = false;
  String _selectedAddress = 'Boulvard Bourgogne, Casablanca';
  Map<String, dynamic>? _pricingArgs; // carry-through from duration/group screens
  
  final Color primaryGreen = const Color(0xFF009933);
  final Color darkGreen = const Color(0xFF065F46);
  final Color bgColor = const Color(0xFFF6F7F8);

  void _toggleOption(String option) {
    setState(() {
      // Always select the tapped option (never deselect — button must stay active)
      _expandedOption = option;
      _showMapPicker = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ─── HERO HEADER ───
          _buildHeroHeader(),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // Option 1: Livraison à domicile
                  _buildExpandableOption(
                    id: 'delivery',
                    title: 'Livraison à domicile',
                    description: 'Nous livrons votre vélo à l\'adresse de votre choix',
                    image: 'assets/images/hero_header.png',
                    badge: _buildBadge('⭐ Recommandé', Colors.white, const Color(0xFF14532D)),
                    subBadge: _buildBadge('🚚 À partir de 20 DH', primaryGreen, primaryGreen.withOpacity(0.08)),
                    expandChild: _buildDeliveryExpandable(),
                  ),

                  const SizedBox(height: 16),

                  // Option 2: Retrait en agence
                  _buildExpandableOption(
                    id: 'pickup',
                    title: 'Retrait en agence',
                    description: 'Récupérez votre vélo dans notre agence',
                    image: 'assets/images/agence_gobike.png',
                    badge: _buildBadge('🏷 Gratuit', primaryGreen, primaryGreen.withOpacity(0.08)),
                    expandChild: _buildPickupExpandable(),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // ─── CONFIRM BUTTON (STICKY) ───
          _buildStickyFooter(),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: topPad + 10, left: 20, right: 20, bottom: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF065F46), Color(0xFF009933), Color(0xFF16A34A)],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          _buildIconButton(Icons.arrow_back, onTap: () => Navigator.pop(context)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GoBike', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                Text('Réception', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          _buildIconButton(Icons.headset_mic_outlined),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: [
        const Icon(Icons.pedal_bike, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: List.generate(6, (index) {
              return Expanded(
                child: Container(
                  height: 6,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: index <= 4 ? const Color(0xFFA3E635) : const Color(0xFF065F46),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 12),
        Text('5 / 6', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildExpandableOption({
    required String id,
    required String title,
    required String description,
    required String image,
    required Widget badge,
    Widget? subBadge,
    required Widget expandChild,
  }) {
    bool isExpanded = _expandedOption == id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isExpanded ? primaryGreen : Colors.transparent, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleOption(id),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(image, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (id == 'delivery') badge,
                        const SizedBox(height: 4),
                        Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(description, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600, height: 1.2)),
                        const SizedBox(height: 8),
                        if (id == 'pickup') badge else if (subBadge != null) subBadge,
                      ],
                    ),
                  ),
                  // Checkmark when selected
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: isExpanded
                        ? Container(
                            key: const ValueKey(true),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Colors.white, size: 18),
                          )
                        : Container(
                            key: const ValueKey(false),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                            child: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                          ),
                  ),
                ],
              ),
            ),
          ),
          
          // Expandable Part
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: expandChild,
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryExpandable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 16),
        Text('Adresse de livraison', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
        Text('Entrez ou sélectionnez votre localisation', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 16),
        // Address Input (Now a TextField)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.location_on, color: primaryGreen, size: 20),
              hintText: 'Entrer votre adresse...',
              hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              border: InputBorder.none,
              suffixIcon: const Icon(Icons.my_location, color: Colors.grey, size: 18),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Map Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => setState(() => _showMapPicker = !_showMapPicker),
            icon: Icon(_showMapPicker ? Icons.close : Icons.map_outlined, color: primaryGreen, size: 18),
            label: Text(_showMapPicker ? 'Fermer la carte' : 'Choisir sur la carte', style: GoogleFonts.poppins(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey.shade200),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Interactive In-Page Map Picker
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _showMapPicker 
            ? _buildInPageMapPicker()
            : _buildMiniMapPreview(),
        ),
      ],
    );
  }

  Widget _buildMiniMapPreview() {
    return Container(
      key: const ValueKey('miniMap'),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/bikemaping.png'),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(Icons.gps_fixed, color: primaryGreen, size: 20),
        ),
      ),
    );
  }

  Widget _buildInPageMapPicker() {
    return Container(
      key: const ValueKey('fullMap'),
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Stack(
        children: [
          // Simulated Map Background
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/bikemaping.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Dark Gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.4)],
              ),
            ),
          ),
          // Center Pin
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(Icons.location_on, color: primaryGreen, size: 30),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          // Bottom Confirmation
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Localisation', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                        Text(_selectedAddress, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => setState(() => _showMapPicker = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Confirmer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupExpandable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        const SizedBox(height: 16),
        // Agency Header in dark card style
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: darkGreen,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text('Agence la plus proche', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(8)),
                    child: Text('Retrait gratuit', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Agence Bourgogne', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('123, Boulevard Bourgogne\nCasablanca', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Color(0xFFA3E635), size: 14),
                            const SizedBox(width: 4),
                            Text('Ouvert • Ferme à 20:00', style: GoogleFonts.poppins(color: const Color(0xFFA3E635), fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Building Image (agence_gobike.png)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/images/agence_gobike.png', width: 90, height: 90, fit: BoxFit.contain),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Mini stats
              Row(
                children: [
                  _buildPickupStat(Icons.near_me, '2.5 km', 'Distance'),
                  const SizedBox(width: 12),
                  _buildPickupStat(Icons.timer, '10 min', 'Estimation'),
                  const SizedBox(width: 12),
                  // Store icon button (Itinerary Style)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.near_me, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Button "Sélectionner cette agence" removed as requested
      ],
    );
  }

  Widget _buildPickupStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFA3E635), size: 14),
                const SizedBox(width: 6),
                Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: GoogleFonts.poppins(color: textColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildStickyFooter() {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, bottomPad + 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            // Singleton holds all pricing — just pass the delivery mode
            Navigator.pushNamed(
              context,
              '/service/gobike/checkout',
              arguments: {'deliveryMode': _expandedOption},
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: darkGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.check_circle_outline, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _expandedOption == 'delivery'
                      ? 'Livraison à domicile ✓'
                      : 'Retrait en agence ✓',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.chevron_right, color: darkGreen, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
