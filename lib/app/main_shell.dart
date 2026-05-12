import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../core/theme/go212_colors.dart';
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

  late final _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const OrdersScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, -4))
                ],
              ),
              child: SafeArea(
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      _NavItem(
                          icon: Iconsax.home_2,
                          activeIcon: Iconsax.home_2,
                          label: 'Accueil',
                          isActive: _currentIndex == 0,
                          onTap: () => setState(() => _currentIndex = 0)),
                      _NavItem(
                          icon: Iconsax.search_normal,
                          activeIcon: Iconsax.search_normal_1,
                          label: 'Explorer',
                          isActive: _currentIndex == 1,
                          onTap: () => setState(() => _currentIndex = 1)),
                      _NavItem(
                          icon: Iconsax.document_text,
                          activeIcon: Iconsax.document_text_1,
                          label: 'Ordres',
                          isActive: _currentIndex == 2,
                          onTap: () => setState(() => _currentIndex = 2)),
                      _NavItem(
                          icon: Iconsax.notification,
                          activeIcon: Iconsax.notification,
                          label: 'Notifs',
                          isActive: _currentIndex == 3,
                          badge: 2,
                          onTap: () => setState(() => _currentIndex = 3)),
                      _NavItem(
                          icon: Iconsax.user,
                          activeIcon: Iconsax.user,
                          label: 'Profil',
                          isActive: _currentIndex == 4,
                          onTap: () => setState(() => _currentIndex = 4)),
                    ],
                  ),
                ),
              ),
            ),
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

  const _NavItem(
      {required this.icon,
      required this.activeIcon,
      required this.label,
      required this.isActive,
      required this.onTap,
      this.badge});

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
                  child: Icon(isActive ? activeIcon : icon,
                      key: ValueKey(isActive),
                      size: 22,
                      color: isActive
                          ? Go212Colors.primary600
                          : Go212Colors.neutral400),
                ),
                if (badge != null)
                  Positioned(
                      right: -6,
                      top: -4,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: Go212Colors.error,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                        child: Center(
                            child: Text('$badge',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700))),
                      )),
              ],
            ),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? Go212Colors.primary600
                        : Go212Colors.neutral400),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
