import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../gowash/animated_tracking_screen.dart';

class OrderSchedulingScreen extends StatefulWidget {
  final String brandName;
  final String brandLogo;
  final String vehicleType;

  const OrderSchedulingScreen({
    super.key,
    required this.brandName,
    required this.brandLogo,
    required this.vehicleType,
  });

  @override
  State<OrderSchedulingScreen> createState() => _OrderSchedulingScreenState();
}

class _OrderSchedulingScreenState extends State<OrderSchedulingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  static const _green = Color(0xFF059669);
  static const _bgGrey = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: _green),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: _green),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Programmer le lavage',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Card
                  _buildSummaryCard(),
                  const SizedBox(height: 30),
                  
                  const Text(
                    'Quand voulez-vous le lavage ?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 16),
                  
                  // Date Picker Field
                  _buildPickerField(
                    label: 'Date du rendez-vous',
                    value: _selectedDate == null 
                      ? 'Choisir une date' 
                      : DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(_selectedDate!),
                    icon: Icons.calendar_today_rounded,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 16),
                  
                  // Time Picker Field
                  _buildPickerField(
                    label: 'Heure souhaitée',
                    value: _selectedTime == null ? 'Sélectionner l\'heure' : _selectedTime!.format(context),
                    icon: Icons.access_time_rounded,
                    onTap: _pickTime,
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Actions
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _bgGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.brandLogo.isNotEmpty 
                ? Image.asset(widget.brandLogo, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, color: Colors.grey))
                : const Icon(Icons.directions_car, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Marque :', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
              Text(widget.brandName.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPickerField({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: _green),
                const SizedBox(width: 12),
                Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _selectedDate != null || _selectedTime != null ? Colors.black87 : Colors.grey.shade400)),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    final ready = _selectedDate != null && _selectedTime != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: ready ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimatedTrackingScreen(
                      vehicleType: widget.vehicleType,
                      brandName: widget.brandName,
                    ),
                  ),
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Passer la commande', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Modifier', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
