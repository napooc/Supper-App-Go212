import 'package:flutter/material.dart';
import 'goride_header.dart';

class KycProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const KycProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final progress =
          totalSteps <= 1 ? 1.0 : (currentStep - 1) / (totalSteps - 1);
      final motoX = (progress * w).clamp(0.0, w);

      return SizedBox(
        height: 42,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Track fond
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Track rempli (progression)
            Positioned(
              top: 30,
              left: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                width: motoX,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Points d'étapes
            Positioned(
              top: 27,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalSteps, (i) {
                  final done = i < currentStep - 1;
                  final current = i == currentStep - 1;
                  return Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: done || current
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: done
                        ? const Icon(Icons.check_rounded,
                            size: 7, color: Color(0xFF15803D))
                        : null,
                  );
                }),
              ),
            ),
            // Moto icon qui glisse
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              top: 0,
              left: (motoX - 20).clamp(0.0, w - 40),
              child: Container(
                width: 40,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const GoRideMotoIcon(size: 22),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── fin du fichier ───
