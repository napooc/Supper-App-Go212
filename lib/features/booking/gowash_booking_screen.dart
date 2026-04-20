import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/go212_colors.dart';
import '../../core/theme/go212_shadows.dart';

class GoWashBookingScreen extends StatefulWidget {
  const GoWashBookingScreen({super.key});

  @override
  State<GoWashBookingScreen> createState() => _GoWashBookingScreenState();
}

class _GoWashBookingScreenState extends State<GoWashBookingScreen> {
  int _currentStep = 0;
  int _selectedVehicle = -1;
  int _selectedFormula = -1;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _selectedTime = -1;

  final _vehicles = ['Citadine', 'Berline', 'SUV Moyen', 'Grand SUV', 'Moto'];
  final _vehicleIcons = [Iconsax.car, Iconsax.car, Iconsax.car, Iconsax.car, Iconsax.electricity];
  final _formulas = ['Essentiel', 'Extra', 'Premium'];
  final _formulaPrices = [
    [60, 60, 70, 80, 35],
    [110, 110, 120, 130, 0],
    [150, 150, 160, 170, 0],
  ];
  final _times = ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00', '17:00', '18:00'];

  int get _currentPrice {
    if (_selectedVehicle < 0 || _selectedFormula < 0) return 0;
    return _formulaPrices[_selectedFormula][_selectedVehicle];
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0: return _selectedVehicle >= 0;
      case 1: return _selectedFormula >= 0;
      case 2: return _selectedTime >= 0;
      case 3: return true;
      default: return false;
    }
  }

  void _next() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      Navigator.pushNamed(context, '/payment');
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Go212Colors.neutral50, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_rounded, size: 20),
          ),
          onPressed: _back,
        ),
        title: Text('Réservation', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              'Étape ${_currentStep + 1}/4',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Go212Colors.neutral500),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: (_currentStep + 1) / 4),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  backgroundColor: Go212Colors.neutral100,
                  valueColor: AlwaysStoppedAnimation(Go212Colors.primary600),
                  minHeight: 4,
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildStep(),
            ),
          ),
          // Bottom CTA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: Go212Shadows.bottomNav,
            ),
            child: Row(
              children: [
                if (_currentPrice > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Go212Colors.neutral500)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('$_currentPrice', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Go212Colors.primary600, height: 1)),
                          Text(' DH', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Go212Colors.primary600)),
                        ],
                      ),
                    ],
                  ),
                if (_currentPrice > 0) const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: AnimatedOpacity(
                      opacity: _canProceed ? 1.0 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: ElevatedButton(
                        onPressed: _canProceed ? _next : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Go212Colors.primary600,
                          disabledBackgroundColor: Go212Colors.neutral200,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentStep == 3 ? 'Confirmer · $_currentPrice DH' : 'Continuer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0: return _buildVehicleStep();
      case 1: return _buildFormulaStep();
      case 2: return _buildDateStep();
      case 3: return _buildSummaryStep();
      default: return const SizedBox();
    }
  }

  Widget _buildVehicleStep() {
    return ListView(
      key: const ValueKey('step0'),
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 16),
        Text('Quel est votre type\nde véhicule ?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral900)),
        const SizedBox(height: 24),
        ...List.generate(_vehicles.length, (i) {
          final selected = _selectedVehicle == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedVehicle = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected ? Go212Colors.primary50 : Go212Colors.neutral50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: selected ? Go212Colors.primary500 : Colors.transparent, width: 2),
                  boxShadow: selected ? Go212Shadows.glowSubtle : [],
                ),
                child: Row(
                  children: [
                    Icon(_vehicleIcons[i], size: 28, color: selected ? Go212Colors.primary600 : Go212Colors.neutral500),
                    const SizedBox(width: 14),
                    Text(_vehicles[i], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: selected ? Go212Colors.primary700 : Go212Colors.neutral700)),
                    const Spacer(),
                    if (selected) ...[
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(color: Go212Colors.primary600, shape: BoxShape.circle),
                        child: Icon(Icons.check_rounded, size: 16, color: Colors.white),
                      ),
                    ] else ...[
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(border: Border.all(color: Go212Colors.neutral300, width: 2), shape: BoxShape.circle),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFormulaStep() {
    final vIndex = _selectedVehicle;
    return ListView(
      key: const ValueKey('step1'),
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 16),
        Row(children: [
          Text(_vehicles[vIndex], style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Go212Colors.primary600, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          GestureDetector(onTap: () => setState(() => _currentStep = 0), child: Text('Changer', style: TextStyle(color: Go212Colors.neutral400, fontSize: 12, decoration: TextDecoration.underline))),
        ]),
        const SizedBox(height: 8),
        Text('Choisissez votre\nformule', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral900)),
        const SizedBox(height: 24),
        ...List.generate(3, (i) {
          if (vIndex >= 4 && i > 0) return const SizedBox(); // Moto only has Complet
          final selected = _selectedFormula == i;
          final price = _formulaPrices[i][vIndex];
          if (price == 0) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFormula = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: selected ? Go212Colors.primary50 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: selected ? Go212Colors.primary500 : Go212Colors.neutral200, width: selected ? 2 : 1),
                  boxShadow: selected ? Go212Shadows.glowSubtle : Go212Shadows.elevation1,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(_formulas[i], style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral800)),
                            if (i == 1) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Go212Colors.primary600, borderRadius: BorderRadius.circular(4)),
                                child: Text('★ Populaire', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ]),
                          const SizedBox(height: 4),
                          Text(
                            i == 0 ? 'Lavage de base complet' : i == 1 ? 'Lavage approfondi + traitement' : 'Tout inclus + protection',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Go212Colors.neutral500),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$price', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Go212Colors.primary600, height: 1)),
                        Text(' DH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Go212Colors.primary600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateStep() {
    return ListView(
      key: const ValueKey('step2'),
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 16),
        Text('Quand souhaitez-vous\nle lavage ?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral900)),
        const SizedBox(height: 24),
        // Date selection
        Text('Date', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index + 1));
              final dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
              final isSelected = date.day == _selectedDate.day;
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? Go212Colors.primary600 : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? Go212Colors.primary600 : Go212Colors.neutral200),
                    boxShadow: isSelected ? Go212Shadows.glowSubtle : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dayNames[date.weekday - 1], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isSelected ? Colors.white.withOpacity(0.8) : Go212Colors.neutral500)),
                      const SizedBox(height: 4),
                      Text('${date.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : Go212Colors.neutral800)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        // Time selection
        Text('Créneau', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(_times.length, (i) {
            final selected = _selectedTime == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedTime = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? Go212Colors.primary600 : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected ? Go212Colors.primary600 : Go212Colors.neutral200),
                ),
                child: Text(_times[i], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: selected ? Colors.white : Go212Colors.neutral700)),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        // Address
        Text('Adresse', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Go212Colors.neutral50, borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Icon(Iconsax.location, size: 20, color: Go212Colors.primary600),
              const SizedBox(width: 12),
              Expanded(child: Text('Choisir une adresse', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Go212Colors.neutral500))),
              Icon(Icons.chevron_right_rounded, size: 20, color: Go212Colors.neutral400),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStep() {
    final monthNames = ['jan', 'fév', 'mar', 'avr', 'mai', 'jun', 'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'];
    return ListView(
      key: const ValueKey('step3'),
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 16),
        Text('Récapitulatif', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral900)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Go212Colors.neutral50, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              _SummaryRow('Service', 'GoWash'),
              _SummaryRow('Véhicule', _selectedVehicle >= 0 ? _vehicles[_selectedVehicle] : '-'),
              _SummaryRow('Formule', _selectedFormula >= 0 ? _formulas[_selectedFormula] : '-'),
              _SummaryRow('Date', '${_selectedDate.day} ${monthNames[_selectedDate.month - 1]} ${_selectedDate.year}'),
              _SummaryRow('Heure', _selectedTime >= 0 ? _times[_selectedTime] : '-'),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: Go212Colors.neutral900)),
                  Text('$_currentPrice DH', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Go212Colors.primary600)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Promo code
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Go212Colors.neutral50, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Icon(Iconsax.discount_shape, size: 20, color: Go212Colors.neutral500),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Code promo',
                    hintStyle: TextStyle(color: Go212Colors.neutral400),
                    border: InputBorder.none,
                    filled: false,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Appliquer', style: TextStyle(color: Go212Colors.primary600, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _SummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Go212Colors.neutral500)),
          Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Go212Colors.neutral800)),
        ],
      ),
    );
  }
}
