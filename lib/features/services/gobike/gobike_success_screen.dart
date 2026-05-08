import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoBikeSuccessScreen extends StatefulWidget {
  final String receptionMode; // 'delivery' or 'pickup'
  
  const GoBikeSuccessScreen({super.key, required this.receptionMode});

  @override
  State<GoBikeSuccessScreen> createState() => _GoBikeSuccessScreenState();
}

class _GoBikeSuccessScreenState extends State<GoBikeSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  
  final Color primaryGreen = const Color(0xFF009933);
  final Color darkGreen = const Color(0xFF065F46);
  final Color bgColor = const Color(0xFFF6F7F8);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDelivery = widget.receptionMode == 'delivery';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Curved Green Header
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryGreen, darkGreen],
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header Title
                Text(
                  'Félicitations !',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // Success Card
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Animated Check Icon
                              ScaleTransition(
                                scale: _scale,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: primaryGreen.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: primaryGreen,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(color: primaryGreen.withOpacity(0.4), blurRadius: 15, spreadRadius: 2),
                                        ],
                                      ),
                                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                              Text(
                                'Réservation confirmée',
                                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isDelivery 
                                  ? 'Votre vélo est en route ! Un livreur GoBike a été assigné à votre commande.'
                                  : 'Votre vélo est prêt ! Vous pouvez passer le récupérer à l\'agence sélectionnée.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
                              ),
                              const SizedBox(height: 32),
                              
                              // Divider
                              Container(height: 1, color: Colors.grey.shade100),
                              const SizedBox(height: 24),

                              // Order Number
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('N° DE COMMANDE : ', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                  Text('#GB-7742', style: GoogleFonts.poppins(fontSize: 14, color: primaryGreen, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Lion Mascot Placeholder (using hero_header.png as mascot)
                        Image.asset(
                          'assets/images/hero_header.png',
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),

                // DYNAMIC CTA BUTTON
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildDynamicCTA(isDelivery),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCTA(bool isDelivery) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(colors: [primaryGreen, darkGreen]),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (isDelivery) {
            Navigator.pushNamed(context, '/service/gobike/tracking-connection');
          } else {
            Navigator.pushNamed(context, '/service/gobike/review');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isDelivery ? Icons.location_on : Icons.star_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              isDelivery ? 'Suivre ma commande' : 'Donner votre avis',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
