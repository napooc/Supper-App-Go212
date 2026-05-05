import 'package:flutter/material.dart';

class VehicleModelSelectionScreen extends StatelessWidget {
  final String vehicleName;
  final String brandName;
  final int selectedPackIndex;

  const VehicleModelSelectionScreen({
    super.key,
    required this.vehicleName,
    required this.brandName,
    required this.selectedPackIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Modèle du véhicule',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.model_training_rounded, size: 80, color: Color(0xFF059669)),
            const SizedBox(height: 24),
            Text(
              'Sélection du modèle pour $brandName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bientôt disponible',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
