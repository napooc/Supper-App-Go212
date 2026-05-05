import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/go212_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.rocket_launch_rounded,
      iconBg: Go212Colors.primary600,
      title: 'La Super App\n100% Marocaine',
      subtitle: 'Transport, services à domicile, shopping —\ntout ce dont vous avez besoin, dans une seule app.',
      decorationIcon: Icons.bolt_rounded,
    ),
    _OnboardingData(
      icon: Icons.grid_view_rounded,
      iconBg: Go212Colors.primary500,
      title: '9 services,\nun seul compte',
      subtitle: 'GoRide, GoWash, GoClean, GoFix, GoBike,\nGoPrint, GoEvent, GoShop et GoSwap.',
      decorationIcon: Icons.star_rounded,
    ),
    _OnboardingData(
      icon: Icons.verified_user_rounded,
      iconBg: Go212Colors.primary700,
      title: 'Simple, sûr\net rapide',
      subtitle: 'Paiement sécurisé, suivi en temps réel,\nsupport disponible 7j/7.',
      decorationIcon: Icons.shield_rounded,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  void _onSkip() {
    Navigator.pushReplacementNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Go212Colors.surfacePage,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 16),
                child: TextButton(
                  onPressed: _onSkip,
                  child: Text(
                    'Passer',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Go212Colors.neutral400,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) => _buildPage(_pages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Go212Colors.primary600,
                  dotColor: Go212Colors.neutral200,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 6,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Go212Colors.primary600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage < _pages.length - 1 ? 'Suivant' : 'Commencer',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _currentPage < _pages.length - 1 ? Icons.arrow_forward_rounded : Icons.check_rounded,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(width: 220, height: 220, decoration: BoxDecoration(shape: BoxShape.circle, color: Go212Colors.primary50)),
              Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, color: Go212Colors.primary100)),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [BoxShadow(color: data.iconBg.withOpacity(0.35), blurRadius: 30, offset: const Offset(0, 12))],
                ),
                child: Icon(data.icon, size: 52, color: Colors.white),
              ),
              Positioned(
                top: 20,
                right: 40,
                child: _FloatingBadge(icon: data.decorationIcon),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Go212Colors.neutral900,
                  height: 1.3,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Go212Colors.neutral500,
                  height: 1.6,
                ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatefulWidget {
  final IconData icon;
  const _FloatingBadge({required this.icon});

  @override
  State<_FloatingBadge> createState() => _FloatingBadgeState();
}

class _FloatingBadgeState extends State<_FloatingBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
    _float = Tween<double>(begin: -5, end: 5).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _float,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _float.value),
          child: child,
        );
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Go212Colors.primary500.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Icon(widget.icon, color: Go212Colors.primary500, size: 22),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final IconData decorationIcon;

  const _OnboardingData({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.decorationIcon,
  });
}
