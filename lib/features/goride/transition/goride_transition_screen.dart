// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class GoRideTransitionScreen extends StatefulWidget {
  const GoRideTransitionScreen({super.key});

  @override
  State<GoRideTransitionScreen> createState() => _GoRideTransitionScreenState();
}

class _GoRideTransitionScreenState extends State<GoRideTransitionScreen>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeOut;
  bool _initialized = false;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeOut = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn));

    _initVideo();
  }

  Future<void> _initVideo() async {
    _videoCtrl = VideoPlayerController.asset('assets/video/Transition.mp4');
    try {
      await _videoCtrl.initialize();
      if (mounted) {
        setState(() => _initialized = true);
        _videoCtrl.setVolume(0.0);
        _videoCtrl.play();
        _videoCtrl.addListener(_checkVideoEnd);
      }
    } catch (_) {
      if (mounted) {
        await Future.delayed(const Duration(seconds: 3));
        _goToBooking();
      }
    }
  }

  void _checkVideoEnd() {
    if (!mounted || _navigating) return;
    final pos = _videoCtrl.value.position;
    final dur = _videoCtrl.value.duration;
    if (dur > Duration.zero && pos >= dur - const Duration(milliseconds: 200)) {
      _goToBooking();
    }
  }

  void _goToBooking() {
    if (_navigating) return;
    _navigating = true;
    _fadeCtrl.forward().then((_) {
      if (mounted) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/goride/booking/persons',
          (route) => route.settings.name == '/main',
        );
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _videoCtrl.removeListener(_checkVideoEnd);
    _videoCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeOut,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video background ──────────────────────────────
            if (_initialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoCtrl.value.size.width == 0
                      ? 1
                      : _videoCtrl.value.size.width,
                  height: _videoCtrl.value.size.height == 0
                      ? 1
                      : _videoCtrl.value.size.height,
                  child: VideoPlayer(_videoCtrl),
                ),
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0D3D26), Color(0xFF16A34A)],
                  ),
                ),
              ),

            // ── Subtle dark overlay ───────────────────────────
            Container(color: Colors.black.withOpacity(0.10)),

            // ── Skip button ───────────────────────────────────
            Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: _goToBooking,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: const Text(
                    'Passer  →',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
