import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeAgencyDetailScreen extends StatelessWidget {
  const GoBikeAgencyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final agency = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final Color primaryGreen = const Color(0xFF009933);
    final Color bgColor = const Color(0xFFF6F7F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ─── HERO HEADER ───
          _buildHeroHeader(context, agency['name']!, primaryGreen),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Overlapping Card
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(agency['name']!, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(agency['location']!, style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade500)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: primaryGreen, size: 18),
                              const SizedBox(width: 8),
                              Text(agency['distance']!, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          
                          // INFO LIST
                          _buildInfoItem(
                            icon: Icons.access_time,
                            title: 'Horaires d\'ouverture',
                            value: 'Lun - Dim : 8h00 - 20h00',
                          ),
                          const SizedBox(height: 16),
                          _buildInfoItem(
                            icon: Icons.phone,
                            title: 'Téléphone',
                            value: '+212 522 12 34 56',
                          ),
                          const SizedBox(height: 16),
                          _buildInfoItem(
                            icon: Icons.map,
                            title: 'Adresse',
                            value: '123, Rue de Bourgogne,\nCasablanca 20100',
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // ITINERARY BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.near_me, size: 20),
                              label: Text('Itinéraire', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF065F46), // Dark green as per ref
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, String name, Color primaryGreen) {
    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryGreen,
      ),
      child: Stack(
        children: [
          // Background Agence Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/agence_gobike.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryGreen.withOpacity(0.4),
                    primaryGreen.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                // Large Building Icon/Image Placeholder as seen in ref
                Center(
                  child: Image.asset(
                    'assets/images/agence_gobike.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF009933).withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFF009933), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
              Text(value, style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF1E293B), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      ],
    );
  }
}
