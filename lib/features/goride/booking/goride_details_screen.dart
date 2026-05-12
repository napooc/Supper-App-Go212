import 'package:flutter/material.dart';
import '../../../core/theme/go212_colors.dart';
import '../models/goride_booking_model.dart';
import '../widgets/goride_btn.dart';
import '../widgets/goride_header.dart';

class GoRideDetailsScreen extends StatefulWidget {
  const GoRideDetailsScreen({super.key});

  @override
  State<GoRideDetailsScreen> createState() => _GoRideDetailsScreenState();
}

class _GoRideDetailsScreenState extends State<GoRideDetailsScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _numMotos = 1;

  bool get _isValid => _selectedDate != null && _selectedTime != null;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.light(
              primary: Go212Colors.primary600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF1E293B),
            ),
            dialogBackgroundColor: Colors.white,
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
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.light(
              primary: Go212Colors.primary600,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _formatDate(DateTime d) {
    final months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return '${days[d.weekday - 1]} ${d.day} ${months[d.month - 1]} ${d.year}';
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ModalRoute.of(context)?.settings.arguments as GoRideBooking? ??
            const GoRideBooking();
    final isGroup = booking.persons > 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildSectionTitle('📅  Date de début'),
                  const SizedBox(height: 12),
                  _buildPickerCard(
                    icon: Icons.calendar_today_rounded,
                    value: _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : null,
                    placeholder: 'Choisir une date',
                    color: const Color(0xFF3B82F6),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('🕐  Heure de prise en charge'),
                  const SizedBox(height: 12),
                  _buildPickerCard(
                    icon: Icons.access_time_rounded,
                    value: _selectedTime != null
                        ? _formatTime(_selectedTime!)
                        : null,
                    placeholder: 'Choisir une heure',
                    color: const Color(0xFFF59E0B),
                    onTap: _pickTime,
                  ),
                  if (isGroup) ...[
                    const SizedBox(height: 20),
                    _buildSectionTitle('🏍️  Nombre de motos'),
                    const SizedBox(height: 12),
                    _buildMotosSelector(),
                  ],
                  const SizedBox(height: 20),
                  if (_selectedDate != null && _selectedTime != null)
                    _buildSummaryPreview(booking, isGroup),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _buildFooter(context, booking, isGroup),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GoRideHeader(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GoRideBackBtn(onTap: () => Navigator.pop(context)),
                  const Spacer(),
                  Image.asset('assets/images/goride.png',
                      height: 36, fit: BoxFit.contain),
                  const SizedBox(width: 10),
                  const GoRideStepBadge(step: 3, total: 6),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Quand ?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Date de début de votre GoRide',
                  style: TextStyle(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
    );
  }

  Widget _buildPickerCard({
    required IconData icon,
    required String? value,
    required String placeholder,
    required Color color,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: hasValue
              ? color.withOpacity(0.06)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hasValue
                ? color.withOpacity(0.5)
                : const Color(0xFFE2E8F0),
            width: hasValue ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: hasValue
                    ? color.withOpacity(0.12)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon,
                  size: 22, color: hasValue ? color : const Color(0xFF94A3B8)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                value ?? placeholder,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: hasValue ? FontWeight.w700 : FontWeight.w400,
                  color: hasValue
                      ? const Color(0xFF1E293B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
            Icon(
              hasValue ? Icons.edit_rounded : Icons.chevron_right_rounded,
              size: 20,
              color: hasValue ? color : const Color(0xFFCBD5E1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotosSelector() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color:
              _numMotos > 1 ? Go212Colors.primary200 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Go212Colors.primary100,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const GoRideMotoIcon(size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre de motos',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B))),
                Text('Pour votre groupe',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          Row(
            children: [
              _CounterBtn(
                icon: Icons.remove_rounded,
                onTap: _numMotos > 2 ? () => setState(() => _numMotos--) : null,
                color: Go212Colors.primary600,
              ),
              Container(
                width: 44,
                height: 44,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Go212Colors.primary100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$_numMotos',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Go212Colors.primary700),
                  ),
                ),
              ),
              _CounterBtn(
                icon: Icons.add_rounded,
                onTap:
                    _numMotos < 10 ? () => setState(() => _numMotos++) : null,
                color: Go212Colors.primary600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPreview(GoRideBooking booking, bool isGroup) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Go212Colors.primary200),
      ),
      child: Column(
        children: [
          _PreviewRow(Icons.calendar_today_rounded, 'Départ',
              _formatDate(_selectedDate!)),
          _PreviewRow(
              Icons.access_time_rounded, 'Heure', _formatTime(_selectedTime!)),
          if (isGroup)
            _PreviewRow(Icons.two_wheeler_rounded, 'Motos',
                '$_numMotos moto${_numMotos > 1 ? 's' : ''}'),
        ],
      ),
    );
  }

  Widget _buildFooter(
      BuildContext context, GoRideBooking booking, bool isGroup) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: GoRideBtn(
        label: _isValid ? 'Continuer' : 'Sélectionnez date et heure',
        onTap: _isValid
            ? () {
                final updated = booking.copyWith(
                  startDate: _selectedDate,
                  startTime: _selectedTime != null
                      ? _formatTime(_selectedTime!)
                      : null,
                  numMotos: isGroup ? _numMotos : 1,
                );
                Navigator.pushNamed(context, '/goride/booking/delivery',
                    arguments: updated);
              }
            : null,
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  const _CounterBtn({required this.icon, this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color:
              disabled ? const Color(0xFFF1F5F9) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: disabled
                  ? const Color(0xFFE2E8F0)
                  : color.withOpacity(0.3)),
        ),
        child: Icon(icon,
            size: 18, color: disabled ? const Color(0xFFCBD5E1) : color),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _PreviewRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF16A34A)),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B))),
        ],
      ),
    );
  }
}
