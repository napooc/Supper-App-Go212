import 'package:flutter/material.dart';
import 'gowash_header.dart';

class IncidentSelectionScreen extends StatefulWidget {
  const IncidentSelectionScreen({super.key});

  @override
  State<IncidentSelectionScreen> createState() => _IncidentSelectionScreenState();
}

class _IncidentSelectionScreenState extends State<IncidentSelectionScreen> {
  int? _selectedIndex;
  
  static const _green = Color(0xFF179B2E); // GoWash Official Green
  static const _greenLight = Color(0xFF58D68D);
  static const _bgGrey = Color(0xFFF8FAFB);

  final List<Map<String, dynamic>> _incidents = [
    {'label': 'Vol d\'objet(s) dans le véhicule', 'icon': Icons.privacy_tip_rounded, 'color': Colors.orange},
    {'label': 'WashBoy maltraite le véhicule/client', 'icon': Icons.warning_rounded, 'color': Colors.red},
    {'label': 'Service inachevé/bâclé', 'icon': Icons.cleaning_services_rounded, 'color': Colors.blue},
    {'label': 'Dommage sur la carrosserie', 'icon': Icons.car_crash_rounded, 'color': Colors.red.shade900},
    {'label': 'Retard important', 'icon': Icons.history_rounded, 'color': Colors.amber},
    {'label': 'Autre', 'icon': Icons.add_circle_outline_rounded, 'color': Colors.grey},
  ];

  void _submitIncident() {
    if (_selectedIndex == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Rapport envoyé', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text(
          'L\'équipe Go212 a reçu votre signalement. Un responsable vous contactera d\'ici 5 minutes.',
          style: TextStyle(color: Colors.black87, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Compris', style: TextStyle(color: _green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      body: Column(
        children: [
          GoWashHeader(
            title: 'Signaler un incident',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_incidents.length, (index) {
                    final item = _incidents[index];
                    final isSelected = _selectedIndex == index;
                    
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? _green : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected ? _green.withOpacity(0.1) : Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? _green.withOpacity(0.1) : _bgGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item['icon'],
                                color: isSelected ? _green : item['color'],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item['label'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected ? _green : const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle_rounded, color: _green, size: 22),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _selectedIndex != null ? _submitIncident : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Envoyer le rapport à l\'équipe Go212',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
