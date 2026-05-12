import 'package:flutter/material.dart';

class GoRideBtn extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final Color? color;

  const GoRideBtn({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.color,
  });

  @override
  State<GoRideBtn> createState() => _GoRideBtnState();
}

class _GoRideBtnState extends State<GoRideBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _s = Tween(begin: 1.0, end: 0.97)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onTap == null && !widget.isLoading;
    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _c.forward(),
      onTapUp: isDisabled
          ? null
          : (_) {
              _c.reverse();
              widget.onTap?.call();
            },
      onTapCancel: () => _c.reverse(),
      child: AnimatedBuilder(
        animation: _s,
        builder: (_, child) => Transform.scale(scale: _s.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? null
                : LinearGradient(
                    colors: widget.color != null
                        ? [widget.color!, widget.color!]
                        : const [Color(0xFF15803D), Color(0xFF22C55E)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            color: isDisabled ? const Color(0xFFE2E8F0) : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF16A34A).withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              else ...[
                if (widget.icon != null) ...[
                  Icon(widget.icon,
                      color:
                          isDisabled ? const Color(0xFF94A3B8) : Colors.white,
                      size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    color: isDisabled ? const Color(0xFF94A3B8) : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
