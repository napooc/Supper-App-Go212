import 'dart:async';
import 'package:flutter/material.dart';
import 'gowash_header.dart';
import '../../../core/theme/go212_colors.dart';

class CompletionScreen extends StatefulWidget {
  const CompletionScreen({super.key});

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-redirection after 5 seconds
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
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
            title: 'Terminé !',
            subtitle: 'Lavage complété avec succès',
            onBack: null,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Celebration badge — above the logo circle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Go212Colors.primary500.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: Go212Colors.primary500.withOpacity(0.2),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🎉', style: TextStyle(fontSize: 15)),
                          SizedBox(width: 6),
                          Text(
                            'Excellent travail !',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Go212Colors.primary500,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text('🎉', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Success Circle with official logo
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Go212Colors.primary500,
                        boxShadow: [
                          BoxShadow(
                            color: Go212Colors.primary500.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo_go_wash.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Success Icon Badge
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Go212Colors.primary500,
                      ),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 24),

                    // Main Messages
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Merci pour votre avis ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Go212Colors.neutral800,
                          ),
                        ),
                        // Native emoji — no color override
                        Text('🙏', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Votre retour nous aide à améliorer notre service.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Go212Colors.neutral500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: Go212Colors.primary500.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Go212Colors.primary500.withOpacity(0.2)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, color: Go212Colors.primary500, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Évaluation soumise',
                            style: TextStyle(
                              color: Go212Colors.primary500,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Redirection Text
                    const Text(
                      'Redirection vers l\'accueil dans quelques secondes...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Go212Colors.neutral400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
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
