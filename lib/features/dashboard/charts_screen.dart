import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../expenses/expenses_providers.dart';
import 'line_chart_widget.dart';
import 'pie_chart_widget.dart';

class ChartsScreen extends HookConsumerWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    // Instant values — no loading states
    final categoryBreakdown = ref.watch(categoryBreakdownProvider(now));
    final dailyTotals = ref.watch(dailyTotalsProvider(now));

    return Scaffold(
      appBar: AppBar(title: const Text('Charts')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 12),

            Text(
              'Spending Breakdown',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 24),

            // Pie chart for categories
            PieChartWidget(
              data: categoryBreakdown,
              colorScheme: Theme.of(context).colorScheme,
            ),

            const SizedBox(height: 32),

            Text(
              'Daily Totals',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 24),

            // Line chart for daily totals
            LineChartWidget(
              data: dailyTotals,
              colorScheme: Theme.of(context).colorScheme,
            ),

            const SizedBox(height: 32),

            Text('Overview', style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 16),

            Text(
              'Your spending charts update automatically as you add receipts '
              'and expenses. All data is stored locally and works offline.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
