import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeMapSelectionScreen extends StatefulWidget {
  const GoBikeMapSelectionScreen({super.key});

  @override
  State<GoBikeMapSelectionScreen> createState() => _GoBikeMapSelectionScreenState();
}

class _GoBikeMapSelectionScreenState extends State<GoBikeMapSelectionScreen> {
  final Color primaryGreen = const Color(0xFF009933);
  final Color darkGreen = const Color(0xFF065F46);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ─── MAP VIEW (SIMULATED) ───
          Positioned.fill(
            child: Image.asset(
              'assets/images/bikemaping.png', // Using existing bike map asset
              fit: BoxFit.cover,
            ),
          ),
          
          // Dark Overlay for map depth
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),

          // ─── TOP SEARCH BAR ───
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                _buildCircularButton(Icons.arrow_back, onTap: () => Navigator.pop(context)),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                        const SizedBox(width: 10),
                        Text('Rechercher une adresse...', style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── CENTER PIN ───
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(Icons.location_on, color: primaryGreen, size: 40),
                ),
                const SizedBox(height: 40), // Offset for pin tip
              ],
            ),
          ),

          // ─── BOTTOM ADDRESS CARD ───
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Current Location Button
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCircularButton(Icons.my_location, color: Colors.white, iconColor: primaryGreen),
                  ),
                ),
                
                // Address Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: primaryGreen.withOpacity(0.1), shape: BoxShape.circle),
                            child: Icon(Icons.location_on, color: primaryGreen, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Localisation sélectionnée', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                                Text('Boulvard Bourgogne, Casablanca', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, 'Boulvard Bourgogne, Casablanca');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text('Confirmer la localisation', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, {VoidCallback? onTap, Color color = Colors.white, Color iconColor = Colors.black87}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
