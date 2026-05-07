import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/go212_colors.dart';
import '../core/theme/go212_shadows.dart';
import '../features/home/home_screen.dart';
import '../features/explore/explore_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    ExploreScreen(),
    OrdersScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final int? badge;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.isActive, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(isActive ? activeIcon : icon, key: ValueKey(isActive), size: 22, color: isActive ? Go212Colors.primary600 : Go212Colors.neutral400),
                ),
                if (badge != null)
                  Positioned(right: -6, top: -4, child: Container(
                    width: 14, height: 14,
                    decoration: BoxDecoration(color: Go212Colors.error, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                    child: Center(child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700))),
                  )),
              ],
            ),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500, color: isActive ? Go212Colors.primary600 : Go212Colors.neutral400), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
