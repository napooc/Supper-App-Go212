import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'evaluation_screen.dart';

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
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoFuture;
  double _washProgress = 1.0; // 1.0 = dirty, 0.0 = clean
  Timer? _washTimer;

  static const _green = Color(0xFF059669);
  static const _bgGrey = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _washTimer?.cancel();
    super.dispose();
  }

  void _startFlow() async {
    // 1. Confirmation for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // 2. Transition to enRoute and start video
    setState(() {
      _status = WashStatus.enRoute;
      _videoController = VideoPlayerController.asset('assets/animations/washboy_en_route.mp4');
      _initializeVideoFuture = _videoController!.initialize().then((_) {
        _videoController!.setLooping(true);
        _videoController!.play();
      });
    });

    // 3. Auto-transition to surPlace after 8 seconds
    await Future.delayed(const Duration(seconds: 8));
    if (!mounted) return;
    setState(() => _status = WashStatus.surPlace);
  }

  void _startWashing() {
    setState(() => _status = WashStatus.washing);
    _washTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _washProgress -= 0.01; // ~10 seconds for demo
        if (_washProgress <= 0) {
          _washProgress = 0;
          _status = WashStatus.ready;
          timer.cancel();
          
          // Automatic navigation to Evaluation after 1.5 seconds
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Suivi de commande',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildCurrentState(),
          ),
        ),
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
          color: _green,
        );
      case WashStatus.enRoute:
        return _buildVideoState();
      case WashStatus.surPlace:
        return _buildSurPlaceState();
      case WashStatus.washing:
        return _buildWashingState();
      case WashStatus.ready:
        return _buildCenteredState(
          icon: Icons.stars_rounded,
          title: 'Voiture prête !',
          subtitle: 'Votre véhicule est maintenant comme neuf.',
          color: _green,
          action: _buildMainButton('Récupérer mes clés', () {
            Navigator.push(
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
          Icon(icon, size: 100, color: color),
          const SizedBox(height: 32),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
          if (action != null) ...[
            const SizedBox(height: 48),
            action,
          ],
        ],
      ),
    );
  }

  Widget _buildVideoState() {
    return FutureBuilder(
      key: const ValueKey('enRoute'),
      future: _initializeVideoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_videoController != null && _videoController!.value.isInitialized)
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              const SizedBox(height: 40),
              const Text(
                'Votre WashBoy est en route !',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
            ],
          );
        } else {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: _green),
                SizedBox(height: 16),
                Text('Chargement de l\'animation...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSurPlaceState() {
    return Container(
      key: const ValueKey('surPlace'),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: _bgGrey,
            child: Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          const Text('WashBoy sur place', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Le technicien est prêt à commencer', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 48),
          _buildMainButton("J'ai donné mes clés", _startWashing),
        ],
      ),
    );
  }

  Widget _buildWashingState() {
    String vehicleAsset;
    switch (widget.vehicleType) {
      case 'Citadine':
        vehicleAsset = 'assets/images/gowash/citadine.png';
        break;
      case 'Berline':
        vehicleAsset = 'assets/images/gowash/berline.png';
        break;
      case 'SUV':
      case 'SUV moyen':
        vehicleAsset = 'assets/images/gowash/suv_moyen.png';
        break;
      case 'Grand SUV':
        vehicleAsset = 'assets/images/gowash/grand_suv.png';
        break;
      case 'Moto':
        vehicleAsset = 'assets/images/gowash/moto.png';
        break;
      default:
        vehicleAsset = 'assets/images/gowash/citadine.png'; // Fallback
    }

    return Container(
      key: const ValueKey('washing'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dynamic Vehicle Image with Shimmer/Pulsing effect
          Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.7, end: 1.0),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.95 + (value * 0.05),
                      child: _buildVehicleImage(vehicleAsset),
                    ),
                  );
                },
              ),
              // Shimmer overlay indicator
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: _green,
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Lavage en cours...',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: _green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: LinearProgressIndicator(
              value: 1 - _washProgress,
              backgroundColor: _green.withOpacity(0.1),
              color: _green,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleImage(String path) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, size: 100, color: Colors.grey),
      ),
    );
  }

  Widget _buildMainButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
      ),
    );
  }
}
