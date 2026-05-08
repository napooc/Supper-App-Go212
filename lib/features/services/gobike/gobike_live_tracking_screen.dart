import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeLiveTrackingScreen extends StatelessWidget {
  const GoBikeLiveTrackingScreen({super.key});

  final Color primaryGreen = const Color(0xFF009933);
  final Color darkGreen = const Color(0xFF065F46);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF062016), // Dark premium green background
      body: Column(
        children: [
          // ─── TOP STATUS BAR & HEADER ───
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  Text('Suivi en direct', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // ─── PROGRESS STEPS ───
          _buildProgressSteps(),

          const SizedBox(height: 10),

          // ─── ESTIMATION CARD ───
          _buildEstimationCard(),

          const SizedBox(height: 20),

          // ─── LIVE MAP SECTION ───
          Expanded(
            child: _buildMapSection(),
          ),

          // ─── DRIVER CARD ───
          _buildDriverCard(context),
        ],
      ),
    );
  }

  Widget _buildProgressSteps() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStep('Recherche', Icons.search, true),
          _buildStepDivider(true),
          _buildStep('Préparation', Icons.inventory_2_outlined, true),
          _buildStepDivider(true),
          _buildStep('En route', Icons.pedal_bike, true, isActive: true),
          _buildStepDivider(false),
          _buildStep('Livré', Icons.shopping_bag_outlined, false),
        ],
      ),
    );
  }

  Widget _buildStep(String label, IconData icon, bool isCompleted, {bool isActive = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? primaryGreen : (isCompleted ? primaryGreen.withOpacity(0.2) : Colors.white.withOpacity(0.05)),
            shape: BoxShape.circle,
            border: isActive ? Border.all(color: Colors.white.withOpacity(0.3), width: 4) : null,
          ),
          child: Icon(icon, color: isCompleted || isActive ? Colors.white : Colors.white24, size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(color: isCompleted || isActive ? Colors.white : Colors.white24, fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildStepDivider(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 25),
        color: isCompleted ? primaryGreen : Colors.white.withOpacity(0.1),
      ),
    );
  }

  Widget _buildEstimationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: primaryGreen.withOpacity(0.15), shape: BoxShape.circle),
            child: const Icon(Icons.access_time, color: Color(0xFFA3E635), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimation de livraison', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                Text('25 – 30 min', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Votre livraison est en route !', style: GoogleFonts.poppins(color: const Color(0xFFA3E635), fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: AssetImage('assets/images/bikemaping.png'),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Stack(
        children: [
          // Simulated Track line
          Center(
            child: Icon(Icons.location_on, color: primaryGreen, size: 40),
          ),
          // Driver position
          Positioned(
            left: 100,
            top: 150,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: const Icon(Icons.pedal_bike, color: Colors.white, size: 24),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(8)),
                  child: Text('Driver', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Driver Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/lion.jpeg'), // Using lion as driver placeholder
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mohamed K.', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('4.8', style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text('245 courses', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: primaryGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text('⭐ TopDriver', style: GoogleFonts.poppins(color: const Color(0xFFA3E635), fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              // Call / SMS Buttons
              Row(
                children: [
                  _buildDriverAction(Icons.call, () {}),
                  const SizedBox(width: 10),
                  _buildDriverAction(Icons.chat_bubble, () {}),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // View Profile Button
          GestureDetector(
            onTap: () {
              // Navigate to review at the end for demo
              Navigator.pushNamed(context, '/service/gobike/review');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.white54, size: 18),
                  const SizedBox(width: 12),
                  Text('Voir le profil du driver', style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Colors.white24, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(16)),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
