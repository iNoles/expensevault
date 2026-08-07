import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../expenses/expenses_providers.dart';
import 'pie_chart_widget.dart';

class CategoryChartScreen extends HookConsumerWidget {
  const CategoryChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    // Instant values — no loading states
    final breakdown = ref.watch(categoryBreakdownProvider(now));

    return Scaffold(
      appBar: AppBar(title: const Text('Category Breakdown')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 12),

            Text(
              'Spending by Category',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 24),

            // Pie chart
            PieChartWidget(
              data: breakdown,
              colorScheme: Theme.of(context).colorScheme,
            ),

            const SizedBox(height: 32),

            Text(
              'Categories',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 16),

            // Category legend
            ...breakdown.entries.map(
              (entry) => _CategoryLegendItem(
                categoryId: entry.key,
                amount: entry.value,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryLegendItem extends StatelessWidget {
  final String categoryId;
  final double amount;
  final Color color;

  const _CategoryLegendItem({
    required this.categoryId,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.85),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              categoryId,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
