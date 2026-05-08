import 'dart:async';
import 'package:flutter/material.dart';
import 'evaluation_screen.dart';
import 'gowash_header.dart';
import 'soap_bubbles_overlay.dart';
import '../../../core/theme/go212_colors.dart';

enum WashStatus { confirmation, enRoute, surPlace, washing, ready }

class AnimatedTrackingScreen extends StatefulWidget {
  final String vehicleType;
  final String brandName;

  const AnimatedTrackingScreen({
    super.key,
    required this.vehicleType,
    required this.brandName,
  });

  @override
  State<AnimatedTrackingScreen> createState() => _AnimatedTrackingScreenState();
}

class _AnimatedTrackingScreenState extends State<AnimatedTrackingScreen> {
  WashStatus _status = WashStatus.confirmation;
  double _washProgress = 1.0; // 1.0 = dirty, 0.0 = clean
  Timer? _washTimer;

  static const _emeraldGreen = Go212Colors.primary500;
  static const _green = Go212Colors.primary500; // Consistent Branding

  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  @override
  void dispose() {
    _washTimer?.cancel();
    super.dispose();
  }

  void _startFlow() async {
    setState(() {
      _status = WashStatus.enRoute;
    });

    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;
    setState(() => _status = WashStatus.surPlace);
  }

  void _startWashing() {
    setState(() => _status = WashStatus.washing);
    _washTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _washProgress -= 0.01;
        if (_washProgress <= 0) {
          _washProgress = 0;
          _status = WashStatus.ready;
          timer.cancel();
          
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EvaluationScreen(
                    vehicleType: widget.vehicleType,
                    brandName: widget.brandName,
                  ),
                ),
              );
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String headerTitle = 'Suivi de commande';
    if (_status == WashStatus.enRoute) headerTitle = 'Votre WashBoy est en route !';
    if (_status == WashStatus.surPlace) headerTitle = 'WashBoy sur place';

    return Scaffold(
      backgroundColor: Go212Colors.surfacePage, // Sand White
      body: Column(
        children: [
          GoWashHeader(
            title: headerTitle,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Stack(
              children: [
                // Minimal soap bubbles overlay
                const SoapBubblesOverlay(),
                Center(
                  child: SingleChildScrollView(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _buildCurrentState(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentState() {
    switch (_status) {
      case WashStatus.confirmation:
        return _buildCenteredState(
          icon: Icons.check_circle_outline_rounded,
          title: 'Commande confirmée',
          subtitle: 'Nous préparons votre WashBoy...',
          color: _emeraldGreen,
        );
      case WashStatus.enRoute:
        return _buildMascotState(
          'assets/images/attente_washoy.png',
          'Votre WashBoy est en route !',
          'Estimation d\'arrivée : 10 minutes',
        );
      case WashStatus.surPlace:
        return _buildMascotState(
          'assets/images/washboy_sur_place.png',
          'WashBoy sur place',
          'Le technicien est prêt à commencer',
          action: _buildMainButton("J'ai donné mes clés", _startWashing),
        );
      case WashStatus.washing:
        return _buildWashingState();
      case WashStatus.ready:
        return _buildCenteredState(
          icon: Icons.stars_rounded,
          title: 'Voiture prête !',
          subtitle: 'Votre véhicule est maintenant comme neuf.',
          color: _emeraldGreen,
          action: _buildMainButton('Récupérer mes clés', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EvaluationScreen(
                  vehicleType: widget.vehicleType,
                  brandName: widget.brandName,
                ),
              ),
            );
          }),
        );
    }
  }

  Widget _buildCenteredState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    Widget? action,
  }) {
    return Container(
      key: ValueKey(title),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: color),
          const SizedBox(height: 24),
          Text(
            title, 
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Go212Colors.neutral800), 
            textAlign: TextAlign.center
          ),
          const SizedBox(height: 12),
          Text(
            subtitle, 
            style: const TextStyle(fontSize: 15, color: Go212Colors.neutral500, fontWeight: FontWeight.w500), 
            textAlign: TextAlign.center
          ),
          if (action != null) ...[
            const SizedBox(height: 40),
            action,
          ],
        ],
      ),
    );
  }

  Widget _buildMascotState(String assetPath, String title, String subtitle, {Widget? action}) {
    return Container(
      key: ValueKey(title),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Premium circular frame for mascot - fully filled with brand green
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Go212Colors.primary500, // Edge-to-edge brand green
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Go212Colors.primary500.withOpacity(0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover, // Fully fills the circle
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.w800, 
              color: Go212Colors.neutral800,
              fontFamily: 'Urbanist',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15, 
              color: Go212Colors.neutral500, 
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: 40),
            action,
          ],
        ],
      ),
    );
  }

  Widget _buildWashingState() {
    String vehicleAsset;
    switch (widget.vehicleType) {
      case 'Citadine': vehicleAsset = 'assets/images/gowash/citadine.png'; break;
      case 'Berline': vehicleAsset = 'assets/images/gowash/berline.png'; break;
      case 'SUV':
      case 'SUV moyen': vehicleAsset = 'assets/images/gowash/suv_moyen.png'; break;
      case 'Grand SUV': vehicleAsset = 'assets/images/gowash/grand_suv.png'; break;
      case 'Moto': vehicleAsset = 'assets/images/gowash/moto.png'; break;
      default: vehicleAsset = 'assets/images/gowash/citadine.png';
    }

    return Container(
      key: const ValueKey('washing'),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildVehicleImage(vehicleAsset),
          const SizedBox(height: 40),
          const Text(
            'Lavage en cours...',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _emeraldGreen),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: LinearProgressIndicator(
              value: 1 - _washProgress,
              backgroundColor: _emeraldGreen.withOpacity(0.1),
              color: _emeraldGreen,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleImage(String path) {
    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Image.asset(path, fit: BoxFit.contain),
    );
  }

  Widget _buildMainButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _emeraldGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ),
    );
  }
}
