import 'dart:async';
import 'package:flutter/material.dart';

enum TrackingStatus {
  waiting,
  enRoute,
  onSite,
  washing,
  ready,
  completed
}

class OrderTrackingScreen extends StatefulWidget {
  final String vehicleType; // e.g., 'citadine', 'berline', 'suv'
  final String brandName;

  const OrderTrackingScreen({
    super.key,
    required this.vehicleType,
    required this.brandName,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  TrackingStatus _status = TrackingStatus.waiting;
  double _progress = 1.0; // 1.0 = dirty, 0.0 = clean
  Timer? _timer;

  static const _green = Color(0xFF059669);
  static const _bgGrey = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    // Auto-advance from waiting to enRoute after 3 seconds for demo
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _status == TrackingStatus.waiting) {
        setState(() => _status = TrackingStatus.enRoute);
      }
    });
    // Auto-advance to onSite after another 5 seconds
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted && _status == TrackingStatus.enRoute) {
        setState(() => _status = TrackingStatus.onSite);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startWashing() {
    setState(() {
      _status = TrackingStatus.washing;
      _progress = 1.0;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress -= 0.005; // Roughly 20 seconds for demo wash
        if (_progress <= 0) {
          _progress = 0;
          _status = TrackingStatus.ready;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Suivi de commande',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Animation Section
          Expanded(
            flex: 3,
            child: _buildAnimationArea(),
          ),
          
          // Status Section
          Expanded(
            flex: 4,
            child: _buildStatusArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationArea() {
    final vType = widget.vehicleType.toLowerCase();
    final cleanPath = 'assets/images/gowash/tracking/${vType}_clean.png';
    final dirtyPath = 'assets/images/gowash/tracking/${vType}_dirty.png';

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Clean Image (Bottom)
          _buildVehicleImage(cleanPath, Colors.white),
          
          // Dirty Image (Top) with Opacity
          Opacity(
            opacity: _progress,
            child: _buildVehicleImage(dirtyPath, Colors.transparent),
          ),

          if (_status == TrackingStatus.washing)
            Positioned(
              bottom: 20,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: 1 - _progress,
                      backgroundColor: _green.withOpacity(0.1),
                      color: _green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Lavage en cours...', style: TextStyle(fontWeight: FontWeight.w600, color: _green)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVehicleImage(String path, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Image.asset(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car_filled_rounded, size: 100, color: _green.withOpacity(0.2)),
              Text('Image: ${path.split('/').last}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildTimeline(),
          const Spacer(),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.brandName.toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            Text(widget.vehicleType.toUpperCase(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: _green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: const Text('GoWash Pro', style: TextStyle(color: _green, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        _buildStep(TrackingStatus.waiting, 'Attente confirmation', 'Votre commande est en cours de validation'),
        _buildStep(TrackingStatus.enRoute, 'WashBoy en route', 'Le technicien se dirige vers votre position'),
        _buildStep(TrackingStatus.onSite, 'Sur place', 'Le technicien est arrivé à destination'),
        _buildStep(TrackingStatus.washing, 'Lavage en cours', 'Votre véhicule se refait une beauté'),
        _buildStep(TrackingStatus.ready, 'Voiture prête !', 'Vous pouvez récupérer vos clés'),
      ],
    );
  }

  Widget _buildStep(TrackingStatus stepStatus, String title, String subtitle) {
    bool isDone = _status.index > stepStatus.index;
    bool isActive = _status == stepStatus;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isDone ? _green : (isActive ? _green.withOpacity(0.2) : Colors.grey.shade200),
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: _green, width: 2) : null,
                ),
                child: isDone ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
              ),
              if (stepStatus != TrackingStatus.ready)
                Container(width: 2, height: 20, color: isDone ? _green : Colors.grey.shade200),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isActive || isDone ? Colors.black : Colors.grey)),
                if (isActive) Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (_status == TrackingStatus.onSite) {
      return _button("J'ai donné mes clés", _startWashing);
    } else if (_status == TrackingStatus.ready) {
      return _button("J'ai récupéré mes clés", () {
        // Navigate to EvaluationScreen (to be created)
      });
    }
    return const SizedBox.shrink();
  }

  Widget _button(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
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
