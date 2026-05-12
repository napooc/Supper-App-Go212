import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'gobike_pricing_data.dart';

class GoBikeCustomizeScreen extends StatefulWidget {
  const GoBikeCustomizeScreen({super.key});

  @override
  State<GoBikeCustomizeScreen> createState() => _GoBikeCustomizeScreenState();
}

class _GoBikeCustomizeScreenState extends State<GoBikeCustomizeScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  double _timeSliderValue = 10.0;
  
  // Mock data for dynamic updates
  int _numBikes = 1;
  int _durationHours = 2;
  final int _pricePerHour = 30;

  final Color primaryGreen = const Color(0xFF009933);
  final Color bgColor = const Color(0xFFF6F7F8);
  bool _isGroupe = false;

  // Quick select lists
  final List<DateTime> _quickDates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  final List<String> _quickTimes = ['08:00', '09:00', '10:00', '11:00', '14:00', '16:00'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeSliderValue = picked.hour.toDouble() + (picked.minute / 60);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Single source of truth — no arg parsing, no re-computation
    final pricing = GoBikePricingData.current;
    _numBikes = pricing.bikeCount;
    _isGroupe = pricing.isGroupe;
    final stepLabel = _isGroupe ? '4 / 7' : '3 / 6';

    return _buildScaffold(
      context,
      stepLabel,
      pricing.durationIndex,
      pricing.quantity,
      pricing.durationTitle,
      pricing.rentalTotal,
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    String stepLabel,
    int durationIndex,
    int quantity,
    String durationTitle,
    int realTotal,
  ) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ─── HERO HEADER (COMPACT) ───
          _buildHeroHeader(stepLabel: stepLabel),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  // ─── DATE SECTION ───
                  _buildCompactCard(
                    title: '1. Date de réservation',
                    icon: Icons.calendar_month,
                    iconColor: Colors.red,
                    onTap: () => _selectDate(context),
                    buttonText: 'Choisir une date',
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildNavArrow(Icons.chevron_left),
                          const SizedBox(width: 8),
                          ..._quickDates.map((date) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildDayItem(date),
                          )),
                          _buildNavArrow(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ─── TIME SECTION ───
                  _buildCompactCard(
                    title: '2. Heure de prise en charge',
                    icon: Icons.access_time,
                    iconColor: primaryGreen,
                    onTap: () => _selectTime(context),
                    buttonText: 'Choisir une heure',
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildNavArrow(Icons.chevron_left),
                              const SizedBox(width: 8),
                              ..._quickTimes.map((timeStr) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildTimeChip(timeStr),
                              )),
                              _buildNavArrow(Icons.chevron_right),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimeSlider(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── RECAP SECTION ───
                  _buildMiniRecap(quantity: quantity, durationTitle: durationTitle, realTotal: realTotal),

                  const SizedBox(height: 16),

                  // ─── FINAL BUTTON ───
                  _buildFinalButton(
                    durationIndex: durationIndex,
                    quantity: quantity,
                    durationTitle: durationTitle,
                    realTotal: realTotal,
                    bikeCount: _numBikes,
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader({String stepLabel = '3 / 6'}) {
    return Container(
      padding: const EdgeInsets.only(top: 52, left: 20, right: 20, bottom: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF065F46), Color(0xFF009933), Color(0xFF16A34A)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          _buildTopIcon(Icons.arrow_back, onTap: () => Navigator.pop(context)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isGroupe ? 'GoBike · Groupe' : 'GoBike',
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text('Personnalisez', style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Text(stepLabel, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIcon(IconData? icon, {String? label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: icon != null 
            ? Icon(icon, color: Colors.white, size: 20)
            : Text(label!, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCompactCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String buttonText,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B))),
              ),
              const Spacer(),
              Icon(Icons.check_circle, color: primaryGreen, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, color: primaryGreen, size: 18),
                  const SizedBox(width: 10),
                  Text(buttonText, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildDayItem(DateTime date) {
    bool isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;
    String dayName = DateFormat('E', 'fr_FR').format(date);
    String dayNum = date.day.toString();
    String monthName = DateFormat('MMM', 'fr_FR').format(date);

    return InkWell(
      onTap: () => setState(() => _selectedDate = date),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 58,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Text(dayName.substring(0, 1).toUpperCase() + dayName.substring(1), style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 10, fontWeight: FontWeight.w600)),
            Text(dayNum, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(monthName.substring(0, 1).toUpperCase() + monthName.substring(1), style: TextStyle(color: isSelected ? Colors.white60 : Colors.grey, fontSize: 9)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String timeStr) {
    bool isSelected = timeStr == '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: () {
        final parts = timeStr.split(':');
        setState(() {
          _selectedTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
          _timeSliderValue = _selectedTime.hour.toDouble() + (_selectedTime.minute / 60);
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade100),
        ),
        child: Text(
          timeStr,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTimeSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('00:00', style: TextStyle(fontSize: 10, color: Colors.grey)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: primaryGreen, borderRadius: BorderRadius.circular(8)),
              child: Text(
                '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const Text('23:59', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: primaryGreen,
            inactiveTrackColor: Colors.grey.shade100,
            thumbColor: primaryGreen,
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: _timeSliderValue,
            min: 0,
            max: 23.99,
            onChanged: (value) {
              setState(() {
                _timeSliderValue = value;
                int hour = value.toInt();
                int minute = ((value - hour) * 60).toInt();
                _selectedTime = TimeOfDay(hour: hour, minute: minute);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMiniRecap({
    required int quantity,
    required String durationTitle,
    required int realTotal,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: primaryGreen.withOpacity(0.06), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/images/hero_header.png', width: 42, height: 42, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Récapitulatif', style: GoogleFonts.poppins(color: primaryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.group_outlined, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('$_numBikes vélo${_numBikes > 1 ? "s" : ""}', style: const TextStyle(fontSize: 11, color: Colors.black87)),
                    const SizedBox(width: 6),
                    const Text('•', style: TextStyle(color: Colors.grey, fontSize: 10)),
                    const SizedBox(width: 6),
                    const Icon(Icons.access_time, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        durationTitle.isNotEmpty ? durationTitle : '$quantity unités',
                        style: const TextStyle(fontSize: 11, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Total', style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text('$realTotal DH', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: primaryGreen)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinalButton({
    required int durationIndex,
    required int quantity,
    required String durationTitle,
    required int realTotal,
    required int bikeCount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: () {
            // Pass ALL pricing args to the loading screen so they reach the checkout
            Navigator.pushNamed(
              context,
              '/service/gobike/loading',
              arguments: {
                'durationIndex': durationIndex,
                'quantity':      quantity,
                'totalPrice':    realTotal,
                'durationTitle': durationTitle,
                'bikeCount':     bikeCount,
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Continuer • $realTotal DH', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Icon(Icons.arrow_forward, color: primaryGreen, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavArrow(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, size: 16, color: Colors.grey),
    );
  }
}
