import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'completion_screen.dart';

class EvaluationScreen extends StatefulWidget {
  final String vehicleType;
  final String brandName;

  const EvaluationScreen({
    super.key,
    required this.vehicleType,
    required this.brandName,
  });

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  double _rating = 0;

  static const _green = Color(0xFF059669);
  static const _red = Color(0xFFE11D48);

  void _showIncidentPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Incident enregistré', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Alerte envoyée. Un responsable Go212 vous contactera immédiatement.',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris', style: TextStyle(color: _red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Évaluation du service',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Vehicle Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFB),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_car_rounded, color: _green),
                  const SizedBox(width: 12),
                  Text(
                    '${widget.brandName.toUpperCase()} - ${widget.vehicleType}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            const Text(
              'Comment s\'est déroulé votre lavage ?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 32),
            
            // Star Rating
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() => _rating = rating);
              },
            ),
            
            const Spacer(),
            
            // Incident Link Button
            TextButton.icon(
              onPressed: _showIncidentPopup,
              icon: const Icon(Icons.report_problem_rounded, color: _red, size: 20),
              label: const Text(
                'Déclarer un incident / Vol',
                style: TextStyle(color: _red, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Validate Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _rating > 0 ? () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CompletionScreen()),
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Valider', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
