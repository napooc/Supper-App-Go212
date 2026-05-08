import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeReviewScreen extends StatefulWidget {
  const GoBikeReviewScreen({super.key});

  @override
  State<GoBikeReviewScreen> createState() => _GoBikeReviewScreenState();
}

class _GoBikeReviewScreenState extends State<GoBikeReviewScreen> {
  int _rating = 0;
  final Set<String> _selectedCategories = {};
  bool _isSubmitted = false;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Bon rapport qualité/prix', 'icon': Icons.monetization_on_outlined},
    {'label': 'Qualité des bikes', 'icon': Icons.pedal_bike},
    {'label': 'Sécurité', 'icon': Icons.security},
    {'label': 'Ponctualité', 'icon': Icons.access_time},
    {'label': 'Service client', 'icon': Icons.headset_mic_outlined},
    {'label': 'Professionnalisme de l\'équipe', 'icon': Icons.badge_outlined},
    {'label': 'Facilité du processus', 'icon': Icons.check_circle_outline},
  ];

  final Color primaryGreen = const Color(0xFF009933);
  final Color darkGreen = const Color(0xFF065F46);

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) return _buildSuccessView();

    return Scaffold(
      backgroundColor: const Color(0xFF062016),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: Text('Avis', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Animated Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: primaryGreen.withOpacity(0.4), blurRadius: 15)],
                        ),
                        child: const Icon(Icons.star_rounded, color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Comment s’est passée\nvotre expérience Go212 ?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Votre avis nous aide à nous améliorer\net à vous offrir le meilleur service.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5), fontSize: 13),
                  ),
                  const SizedBox(height: 40),
                  
                  // Star Rating
                  Text('Notez votre expérience', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => _rating = index + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            _rating > index ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: _rating > index ? const Color(0xFFA3E635) : Colors.white24,
                            size: 40,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),

                  // Categories Selection
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Qu\'est-ce que vous avez aimé ?', style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('(Sélectionnez tout ce qui s\'applique)', style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12)),
                  ),
                  const SizedBox(height: 20),
                  
                  ..._categories.map((cat) => _buildCategoryRow(cat)),

                  const SizedBox(height: 32),

                  // Comment Field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Laissez un commentaire (optionnel)', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    maxLines: 4,
                    style: GoogleFonts.poppins(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Partagez votre expérience avec Go212...',
                      hintStyle: GoogleFonts.poppins(color: Colors.white24, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  _buildSubmitButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(Map<String, dynamic> cat) {
    bool isSelected = _selectedCategories.contains(cat['label']);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategories.remove(cat['label']);
          } else {
            _selectedCategories.add(cat['label']);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen.withOpacity(0.1) : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryGreen : Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(cat['icon'], color: isSelected ? const Color(0xFFA3E635) : Colors.white38, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(cat['label'], style: GoogleFonts.poppins(color: isSelected ? Colors.white : Colors.white60, fontSize: 13)),
            ),
            Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank, color: isSelected ? const Color(0xFFA3E635) : Colors.white12, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(colors: [primaryGreen, darkGreen]),
        boxShadow: [BoxShadow(color: primaryGreen.withOpacity(0.3), blurRadius: 15)],
      ),
      child: ElevatedButton(
        onPressed: () => setState(() => _isSubmitted = true),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Envoyer mon avis', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(width: 12),
            const Icon(Icons.send_rounded, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: const Color(0xFF062016),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: const Color(0xFFA3E635).withOpacity(0.15), shape: BoxShape.circle),
                child: const Center(child: Icon(Icons.check_circle, color: Color(0xFFA3E635), size: 60)),
              ),
              const SizedBox(height: 32),
              Text('Merci pour votre avis !', style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                'Votre retour est précieux et nous aide\nà améliorer l’expérience Go212.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.05),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.home_outlined),
                      const SizedBox(width: 12),
                      Text('Retour à l’accueil', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
