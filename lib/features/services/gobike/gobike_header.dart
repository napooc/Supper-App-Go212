import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared GoBike header — dynamically sizes top padding from MediaQuery.
/// Fixes white-text-on-white-bg issue caused by hardcoded top:52 being
/// smaller than the status bar on tall-notch devices.
class GoBikeHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? stepText;
  final VoidCallback? onBack;
  final Widget? trailing;

  static const _gradientColors = [
    Color(0xFF065F46),
    Color(0xFF008333),
    Color(0xFF16A34A),
  ];

  const GoBikeHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.stepText,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: topPad + 10,
        left: 20,
        right: 20,
        bottom: 18,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
              ),
            ),

          if (onBack != null) const SizedBox(width: 14),

          // Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: GoogleFonts.nunito(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Trailing: step badge or custom widget
          if (stepText != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Text(
                stepText!,
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
            )
          else if (trailing != null)
            trailing!,
        ],
      ),
    );
  }
}

/// Reusable sticky CTA button for GoBike booking screens.
/// Uses MediaQuery.padding.bottom to always stay above system nav bar.
class GoBikeCTA extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onPressed;
  final IconData icon;

  static const _green = Color(0xFF009933);
  static const _greenDark = Color(0xFF065F46);

  const GoBikeCTA({
    super.key,
    required this.label,
    required this.enabled,
    this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4)),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 14),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: enabled
                ? const LinearGradient(
                    colors: [_green, _greenDark],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFFE2E8F0), Color(0xFFE2E8F0)]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: enabled
                ? [
                    BoxShadow(
                        color: _green.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 6))
                  ]
                : [],
          ),
          child: ElevatedButton.icon(
            onPressed: enabled ? onPressed : null,
            icon: const SizedBox.shrink(),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: enabled ? Colors.white : const Color(0xFFADB5BD),
                  ),
                ),
                if (enabled) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: Colors.white, size: 18),
                ]
              ],
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }
}
