import 'package:flutter/material.dart';

class ExpressiveBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onIndexChanged;

  const ExpressiveBottomNav({
    super.key,
    required this.index,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: onIndexChanged,
      height: 72,
      elevation: 0,
      backgroundColor: colors.surface,
      indicatorColor: colors.primary.withValues(alpha: 0.18),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Receipts',
        ),
        NavigationDestination(
          icon: Icon(Icons.pie_chart_outline),
          selectedIcon: Icon(Icons.pie_chart),
          label: 'Charts',
        ),
      ],
    );
  }
}
