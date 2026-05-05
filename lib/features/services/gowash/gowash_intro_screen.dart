import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'gowash_detail_screen.dart';
import 'vehicle_selection_screen.dart';

/// Full-screen intro video for GoWash (5 s max).
/// • Auto-plays assets/videos/gowash_intro.mp4
/// • No controls, black background, BoxFit.cover
/// • Navigates to GoWashDetailScreen when video ends OR after 5 s
/// • Falls back immediately to GoWashDetailScreen on any error
/// • Safe: controller is only disposed if it was ever assigned
class GoWashIntroScreen extends StatefulWidget {
  const GoWashIntroScreen({super.key});

  @override
  State<GoWashIntroScreen> createState() => _GoWashIntroScreenState();
}

class _GoWashIntroScreenState extends State<GoWashIntroScreen> {
  VideoPlayerController? _controller;   // nullable → safe dispose
  bool _navigated = false;              // guard: navigate only once
  Timer? _safetyTimer;

  // ─── Lifecycle ──────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initVideo();
  }

  @override
  void dispose() {
    _safetyTimer?.cancel();
    _controller?.removeListener(_onVideoProgress);
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ─── Video init ─────────────────────────────────────────────

  Future<void> _initVideo() async {
    // 5-second hard cap regardless of what the video does.
    _safetyTimer = Timer(const Duration(seconds: 5), _navigateToHome);

    final ctrl = VideoPlayerController.asset(
      'assets/images/videos/gowash_intro.mp4',
    );

    try {
      await ctrl.initialize();
    } catch (_) {
      ctrl.dispose(); // clean up the orphaned controller
      _navigateToHome();
      return;
    }

    // Widget might have been disposed while awaiting initialize().
    if (!mounted) {
      ctrl.dispose();
      return;
    }

    _controller = ctrl;
    _controller!.addListener(_onVideoProgress);

    setState(() {}); // trigger rebuild to show the video

    await _controller!.setVolume(0.0);
    await _controller!.play();
  }

  // ─── Progress listener ──────────────────────────────────────

  void _onVideoProgress() {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return;

    final pos = ctrl.value.position;
    final dur = ctrl.value.duration;

    if (dur > Duration.zero && pos >= dur) {
      _navigateToHome();
    }
  }

  // ─── Navigation ─────────────────────────────────────────────

  void _navigateToHome() {
    if (_navigated || !mounted) return;
    _navigated = true;

    _safetyTimer?.cancel();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const VehicleSelectionScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final ctrl = _controller;
    final ready = ctrl != null && ctrl.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ready
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: ctrl.value.size.width,
                  height: ctrl.value.size.height,
                  child: VideoPlayer(ctrl),
                ),
              ),
            )
          : const SizedBox.expand(), // black while loading, no flicker
    );
  }
}
