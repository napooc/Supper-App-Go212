import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'animated_tracking_screen.dart';

class MascotEnRouteScreen extends StatefulWidget {
  final String vehicleType;
  final String brandName;

  const MascotEnRouteScreen({
    super.key,
    required this.vehicleType,
    required this.brandName,
  });

  @override
  State<MascotEnRouteScreen> createState() => _MascotEnRouteScreenState();
}

class _MascotEnRouteScreenState extends State<MascotEnRouteScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Correct asset path as identified in assets/animations/
    _controller = VideoPlayerController.asset('assets/animations/washoy_en_route.mp4')
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
        _controller.setLooping(false); // Play once as per requirements
        
        // Add listener to navigate when the video finishes
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration) {
            _navigateToTracking();
          }
        });
      });
  }

  void _navigateToTracking() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AnimatedTrackingScreen(
            vehicleType: widget.vehicleType,
            brandName: widget.brandName,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background as requested
      body: Stack(
        children: [
          // 1. FullScreen Immersive Video Player
          SizedBox.expand(
            child: _initialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Color(0xFF10B981)),
                  ),
          ),

          // 2. Bottom Message Overlay Zone
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                top: 20,
              ),
              decoration: BoxDecoration(
                // Dark green translucent bar matching Go212 Gold theme
                color: const Color(0xFF064E3B).withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: const Center(
                child: Text(
                  'Votre wash boy est en route !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Urbanist',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          // 3. Skip button — top-right, discrete premium pill
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: GestureDetector(
              onTap: _navigateToTracking,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.30),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Passer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.skip_next_rounded, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
