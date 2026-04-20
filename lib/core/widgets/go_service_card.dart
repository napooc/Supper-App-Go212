import 'package:flutter/material.dart';
import '../theme/go212_colors.dart';
import '../theme/go212_shadows.dart';

class GoServiceCard extends StatefulWidget {
  final IconData icon;
  final String name;
  final String price;
  final String? badge;
  final Color? iconBgColor;
  final VoidCallback? onTap;

  const GoServiceCard({
    super.key,
    required this.icon,
    required this.name,
    required this.price,
    this.badge,
    this.iconBgColor,
    this.onTap,
  });

  @override
  State<GoServiceCard> createState() => _GoServiceCardState();
}

class _GoServiceCardState extends State<GoServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Go212Colors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            boxShadow: Go212Shadows.elevation1,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.iconBgColor ?? Go212Colors.primary50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.icon,
                  color: Go212Colors.primary600,
                  size: 24,
                ),
              ),
              const Spacer(),
              Text(
                widget.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Go212Colors.neutral800,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.price,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Go212Colors.primary600,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (widget.badge != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Go212Colors.primary50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.badge!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Go212Colors.primary600,
                          fontWeight: FontWeight.w600,
                          fontSize: 9,
                        ),
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
