import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeAgencySelectionScreen extends StatelessWidget {
  const GoBikeAgencySelectionScreen({super.key});

  final List<Map<String, String>> agencies = const [
    {
      'name': 'Agence Bourgogne',
      'location': 'Casablanca Bourgogne',
      'distance': '1.2 km',
      'image': 'assets/images/agence_gobike.png',
    },
    {
      'name': 'Agence Maarif',
      'location': 'Casablanca Maarif',
      'distance': '2.7 km',
      'image': 'assets/images/agence_gobike.png',
    },
    {
      'name': 'Agence Ain Diab',
      'location': 'Corniche Casablanca',
      'distance': '4.3 km',
      'image': 'assets/images/agence_gobike.png',
    },
    {
      'name': 'Agence Casa Port',
      'location': 'Près de Casa Port',
      'distance': '6.1 km',
      'image': 'assets/images/agence_gobike.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF009933);
    final Color bgColor = const Color(0xFFF6F7F8);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ─── HERO HEADER ───
          _buildHeroHeader(context, primaryGreen),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: agencies.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final agency = agencies[index];
                return _buildAgencyCard(context, agency, primaryGreen);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, Color primaryGreen) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Text('GoBike', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Choisissez votre agence',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.1),
            ),
            const SizedBox(height: 8),
            Text(
              'Sélectionnez l\'agence la plus proche de vous',
              style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgencyCard(BuildContext context, Map<String, String> agency, Color primaryGreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Agency Image
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                agency['image']!,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(agency['name']!, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(agency['location']!, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: primaryGreen, size: 14),
                      const SizedBox(width: 4),
                      Text(agency['distance']!, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: primaryGreen)),
                    ],
                  ),
                ],
              ),
            ),
            // Selection Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context, 
                  '/service/gobike/agency-detail',
                  arguments: agency,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen.withOpacity(0.1),
                foregroundColor: primaryGreen,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Sélectionner', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
