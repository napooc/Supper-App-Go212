import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key});

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  static const _green = Color(0xFF059669);
  static const _darkBlue = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/animations/lion_byebye.mp4')
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Full-Width Video with Natural Aspect Ratio
              _isInitialized
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : const SizedBox(
                      height: 300,
                      child: Center(child: CircularProgressIndicator(color: _green)),
                    ),

              const SizedBox(height: 50),

              // 2. Final Message
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Merci de votre confiance,\nà bientôt !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: _darkBlue,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 3. Action Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Retour à l\'accueil',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 50), // Balance bottom spacing
            ],
          ),
        ),
      ),
    );
  }
}
