import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/theme/go212_colors.dart';
import '../../core/theme/go212_shadows.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Go212Colors.surfacePage,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Mes Commandes',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Go212Colors.neutral900,
                    ),
              ),
            ),
            const SizedBox(height: 20),
            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Go212Colors.neutral100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: Go212Shadows.elevation1,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Go212Colors.neutral800,
                  unselectedLabelColor: Go212Colors.neutral500,
                  labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
                  tabs: const [
                    Tab(text: 'En cours'),
                    Tab(text: 'Passées'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveOrders(context),
                  _buildPastOrders(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrders(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        _OrderCard(
          serviceName: 'GoWash',
          serviceType: 'Extra · Berline',
          date: '20 avr · 14h00',
          price: '110 DH',
          icon: Iconsax.colorfilter,
          status: 'En cours',
          statusColor: Go212Colors.primary600,
          progress: 0.4,
        ),
      ],
    );
  }

  Widget _buildPastOrders(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        _OrderCard(
          serviceName: 'GoRide',
          serviceType: '2 heures',
          date: '18 avr · 10h-12h',
          price: '60 DH',
          icon: Iconsax.flash_1,
          status: 'Terminée',
          statusColor: Go212Colors.success,
          showReorder: true,
        ),
        const SizedBox(height: 12),
        _OrderCard(
          serviceName: 'GoClean',
          serviceType: 'T2 · Standard',
          date: '15 avr · 09h00',
          price: '200 DH',
          icon: Iconsax.brush_1,
          status: 'Terminée',
          statusColor: Go212Colors.success,
          showReorder: true,
        ),
        const SizedBox(height: 12),
        _OrderCard(
          serviceName: 'GoWash',
          serviceType: 'Premium · SUV',
          date: '12 avr · 16h00',
          price: '160 DH',
          icon: Iconsax.colorfilter,
          status: 'Terminée',
          statusColor: Go212Colors.success,
          showReorder: true,
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String serviceName;
  final String serviceType;
  final String date;
  final String price;
  final IconData icon;
  final String status;
  final Color statusColor;
  final double? progress;
  final bool showReorder;

  const _OrderCard({
    required this.serviceName,
    required this.serviceType,
    required this.date,
    required this.price,
    required this.icon,
    required this.status,
    required this.statusColor,
    this.progress,
    this.showReorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: Go212Shadows.elevation1,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Go212Colors.primary50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 22, color: Go212Colors.primary600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          serviceName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Go212Colors.neutral800,
                              ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '· $serviceType',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Go212Colors.neutral500,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Go212Colors.neutral400,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Go212Colors.neutral800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress!,
                backgroundColor: Go212Colors.neutral100,
                valueColor: AlwaysStoppedAnimation(Go212Colors.primary500),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Voir détails',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Go212Colors.primary600,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14, color: Go212Colors.primary600),
              ],
            ),
          ],
          if (showReorder) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.repeat, size: 16, color: Go212Colors.primary600),
                      const SizedBox(width: 6),
                      Text(
                        'Re-commander',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Go212Colors.primary600,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.star_1, size: 14, color: Go212Colors.warning),
                    const SizedBox(width: 4),
                    Text(
                      '4.8',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Go212Colors.neutral700,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
