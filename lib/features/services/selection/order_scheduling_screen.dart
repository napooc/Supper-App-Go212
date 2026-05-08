import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../gowash/animated_tracking_screen.dart';
import '../gowash/gowash_header.dart';
import 'order_confirmation_screen.dart';

class OrderSchedulingScreen extends StatefulWidget {
  final String brandName;
  final String brandLogo;
  final String vehicleType;
  final String packName;
  final double basePrice;

  const OrderSchedulingScreen({
    super.key,
    required this.brandName,
    required this.brandLogo,
    required this.vehicleType,
    required this.packName,
    this.basePrice = 60.0,
  });

  @override
  State<OrderSchedulingScreen> createState() => _OrderSchedulingScreenState();
}

class _OrderSchedulingScreenState extends State<OrderSchedulingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  static const _green = Color(0xFF179B2E); // GoWash Official Green
  static const _bgGrey = Color(0xFFF8FAFB);
  static const _darkBlue = Color(0xFF1E293B);

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
      body: Column(
        children: [
          GoWashHeader(
            title: 'Quand ?',
            stepText: '3/4',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBookingSummary(),
                    _buildSectionTitleEmoji('📅', 'Date de début'),
                    _buildModernCard(
                      child: ListTile(
                        onTap: _pickDate,
                        leading: const Text('📅', style: TextStyle(fontSize: 22)),
                        title: Text(
                          _selectedDate == null 
                            ? 'Choisir une date' 
                            : DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(_selectedDate!),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _selectedDate == null ? Colors.grey.shade400 : _darkBlue,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    _buildSectionTitleEmoji('🕒', 'Heure de prise en charge'),
                    _buildModernCard(
                      child: ListTile(
                        onTap: _pickTime,
                        leading: const Text('🕒', style: TextStyle(fontSize: 22)),
                        title: Text(
                          _selectedTime == null ? 'Choisir une heure' : _selectedTime!.format(context),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _selectedTime == null ? Colors.grey.shade400 : _darkBlue,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    _buildConfirmButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Maps vehicleType string → real vehicle image asset path
  String _vehicleAsset(String vehicleType) {
    final t = vehicleType.toLowerCase();
    if (t.contains('moto'))                            return 'assets/images/gowash/moto.png';
    if (t.contains('grand') && t.contains('suv'))      return 'assets/images/gowash/grand_suv.png';
    if (t.contains('suv') || t.contains('4x4'))        return 'assets/images/gowash/suv_moyen.png';
    if (t.contains('berline'))                         return 'assets/images/gowash/berline.png';
    if (t.contains('citadine') || t.contains('city'))  return 'assets/images/gowash/citadine.png';
    return 'assets/images/gowash/citadine.png'; // default
  }

  Widget _buildBookingSummary() {
    final chips = <_SummaryChip>[
      if (widget.vehicleType.isNotEmpty)
        _SummaryChip(
          emoji: '🚗',                                      // fallback only
          label: widget.vehicleType,
          logoAsset: _vehicleAsset(widget.vehicleType),    // real vehicle image
        ),
      if (widget.brandName.isNotEmpty)
        _SummaryChip(
          emoji: '🏷️',                                      // fallback only
          label: widget.brandName.toUpperCase(),
          logoAsset: widget.brandLogo.isNotEmpty ? widget.brandLogo : null,
        ),
      if (widget.packName.isNotEmpty)
        _SummaryChip(emoji: '✨', label: widget.packName),
      _SummaryChip(
        emoji: '💰',
        label: '${widget.basePrice.toStringAsFixed(0)} MAD',
        isPrice: true,
      ),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: _green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Récapitulatif',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _green,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Chips row — wraps if needed
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips.map((c) => _buildChip(c)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(_SummaryChip chip) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: chip.logoAsset != null ? 8 : 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: chip.isPrice
            ? const Color(0xFF179B2E).withOpacity(0.08)
            : const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: chip.isPrice
              ? _green.withOpacity(0.3)
              : const Color(0xFFE8F0E8),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chip.logoAsset != null)
            // Real vehicle / brand image — sized slightly larger for clarity
            SizedBox(
              width: 28,
              height: 20,
              child: Image.asset(
                chip.logoAsset!,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Text(chip.emoji, style: const TextStyle(fontSize: 13)),
              ),
            )
          else
            Text(chip.emoji, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(
            chip.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: chip.isPrice ? FontWeight.w800 : FontWeight.w600,
              color: chip.isPrice ? _green : _darkBlue,
              letterSpacing: chip.isPrice ? 0.2 : 0,
            ),
          ),
        ],
      ),
    );
  }

  // Emoji-based section title (no green icon tint)
  Widget _buildSectionTitleEmoji(String emoji, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  // Legacy icon-based helper kept for compatibility
  Widget _buildSectionTitleIcon(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _green),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _darkBlue),
      ),
    );
  }


  Widget _buildModernCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildConfirmButton() {
    final ready = _selectedDate != null && _selectedTime != null;
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: ready ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderConfirmationScreen(
                vehicleType: widget.vehicleType,
                brandName: widget.brandName,
                packName: widget.packName,
                selectedDate: DateFormat('dd/MM/yyyy').format(_selectedDate!),
                selectedTime: _selectedTime!.format(context),
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
        child: const Text(
          'Confirmer la commande',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
    );
  }
}

// ─── Data model for booking summary chips ────────────────────────────────────
class _SummaryChip {
  final String emoji;        // Native emoji string — no color override
  final String label;
  final bool isPrice;
  final String? logoAsset;   // Optional image asset path (e.g. brand logo)
  const _SummaryChip({
    required this.emoji,
    required this.label,
    this.isPrice = false,
    this.logoAsset,
  });
}
