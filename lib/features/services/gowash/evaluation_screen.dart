import 'package:flutter/material.dart';
import 'gowash_header.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'completion_screen.dart';
import 'incident_selection_screen.dart';
import '../../../core/theme/go212_colors.dart';

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
  final Set<String> _selectedTags = {};
  final TextEditingController _commentController = TextEditingController();

  // Unified GoWash branding colors
  static const _green = Go212Colors.primary500;

  final List<Map<String, dynamic>> _tags = [
    {'label': 'Ponctualité',              'emoji': '⏱️'},
    {'label': 'Qualité Lavage',           'emoji': '✨'},
    {'label': 'Service client',           'emoji': '😊'},
    {'label': 'Bon rapport qualité/prix', 'emoji': '💰'},
    {'label': 'Sécurité',                 'emoji': '🛡️'},
  ];

  String _getRatingText(double rating) {
    if (rating >= 5) return 'Excellent ! 🥳';
    if (rating >= 4) return 'Très bien ! 😊';
    if (rating >= 3) return 'Bien ! 🙂';
    if (rating >= 2) return 'Moyen ! 😐';
    if (rating >= 1) return 'Décevant ! 🙁';
    return '';
  }

  void _onTagToggled(String label) {
    setState(() {
      if (_selectedTags.contains(label)) {
        _selectedTags.remove(label);
      } else {
        _selectedTags.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Go212Colors.surfacePage,
      body: Column(
        children: [
          const GoWashHeader(
            title: 'Votre avis compte',
            subtitle: 'Partagez votre expérience GoWash',
            onBack: null,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // CARD 1: Stars
                  _buildCard(
                    child: Column(
                      children: [
                        const Text(
                          'Comment s\'était passée votre expérience GO212 ?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Go212Colors.neutral800),
                        ),
                        const SizedBox(height: 24),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 45,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB800),
                          ),
                          onRatingUpdate: (rating) {
                            setState(() => _rating = rating);
                          },
                        ),
                        if (_rating > 0) ...[
                          const SizedBox(height: 16),
                          Text(
                            _getRatingText(_rating),
                            style: const TextStyle(color: _green, fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // CARD 2: Tags
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ce que vous avez aimé',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Go212Colors.neutral800),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Sélectionnez tout ce qui s\'applique',
                          style: TextStyle(fontSize: 12, color: Go212Colors.neutral500, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _tags.map((tag) {
                            final isSelected = _selectedTags.contains(tag['label']);
                            return GestureDetector(
                              onTap: () => _onTagToggled(tag['label']),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? _green : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: isSelected ? _green : Go212Colors.neutral300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Native emoji — no color override, renders in OS native colors
                                    Text(
                                      tag['emoji'],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      tag['label'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                        color: isSelected ? Colors.white : Go212Colors.neutral600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // CARD 3: Comment
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Commentaire',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Go212Colors.neutral800),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _commentController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Laissez un commentaire...',
                            hintStyle: TextStyle(color: Go212Colors.neutral400, fontSize: 14, fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Go212Colors.neutral100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BUTTON STACK
                  Column(
                    children: [
                      // 1. VALIDER BUTTON
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
                            disabledBackgroundColor: Go212Colors.neutral300,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Valider',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 2. PASSER BUTTON
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Passer',
                          style: TextStyle(
                            color: Go212Colors.neutral500,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 3. INCIDENT BUTTON
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const IncidentSelectionScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Déclarer un incident',
                          style: TextStyle(
                            color: Go212Colors.error,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
