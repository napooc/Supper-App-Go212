import 'package:flutter/material.dart';
import '../gowash/gowash_header.dart';
import 'order_scheduling_screen.dart';

class VehicleModelSelectionScreen extends StatefulWidget {
  final String vehicleName;
  final String brandName;
  final String brandLogo;
  final String vehicleType;
  final String packName;
  final int selectedPackIndex;
  final double basePrice;

  const VehicleModelSelectionScreen({
    super.key,
    required this.vehicleName,
    required this.brandName,
    required this.brandLogo,
    required this.vehicleType,
    required this.packName,
    required this.selectedPackIndex,
    this.basePrice = 60.0,
  });

  @override
  State<VehicleModelSelectionScreen> createState() => _VehicleModelSelectionScreenState();
}

class _VehicleModelSelectionScreenState extends State<VehicleModelSelectionScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  
  // Dummy models for now - in a real app these would come from a database or API based on brand
  final List<String> _allModels = [
    'Série 1', 'Série 3', 'Série 5', 'X1', 'X3', 'X5', // BMW
    'A1', 'A3', 'A4', 'A6', 'Q3', 'Q5', 'Q7', // Audi
    'Golf', 'Polo', 'Tiguan', 'Passat', 'Touareg', // VW
    'Clio', 'Megane', 'Captur', 'Kadjar', // Renault (if added)
    '208', '308', '2008', '3008', '5008', // Peugeot
    'Sandero', 'Duster', 'Logan', 'Lodgy', // Dacia
    'C-Class', 'E-Class', 'S-Class', 'GLC', 'GLE', // Mercedes
    'Autre modèle',
  ];

  List<String> _filtered = [];
  int? _selectedModelIndex;

  static const _green = Color(0xFF179B2E); // GoWash Official Green
  static const _bgGrey = Color(0xFFF8FAFB);

  @override
  void initState() {
    super.initState();
    _filtered = _allModels;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filtered = _allModels
          .where((m) => m.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onContinue() {
    if (_selectedModelIndex == null) return;
    
    final selectedModel = _filtered[_selectedModelIndex!];
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSchedulingScreen(
          brandName: '${widget.brandName} $selectedModel',
          brandLogo: widget.brandLogo,
          vehicleType: widget.vehicleType,
          packName: widget.packName,
          basePrice: widget.basePrice,
        ),
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
            title: 'Quel modèle ?',
            onBack: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: _onSearchChanged,
                style: const TextStyle(fontWeight: FontWeight.w600),
                decoration: const InputDecoration(
                  hintText: 'Rechercher un modèle...',
                  prefixIcon: Icon(Icons.search_rounded, color: _green),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                  hintStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filtered.isEmpty 
              ? const Center(child: Text('Aucun résultat'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final model = _filtered[index];
                    final isSelected = _selectedModelIndex == index;
                    
                    return GestureDetector(
                      onTap: () => setState(() => _selectedModelIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? _green : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected ? _green.withOpacity(0.1) : Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              model,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected ? _green : const Color(0xFF1E293B),
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              const Icon(Icons.check_circle_rounded, color: _green, size: 22),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _selectedModelIndex != null ? _onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: const Text(
                  'Continuer', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
