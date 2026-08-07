import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../expressive_topbar.dart';
import '../expenses/expenses_providers.dart';
import '../receipts/receipts_providers.dart';
import 'stat_card.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final previousMonth = DateTime(now.year, now.month - 1);

    // Offline-first values
    final receipts = ref.watch(allReceiptsProvider).value ?? [];
    final expenses = ref.watch(allExpensesProvider).value ?? [];

    final monthlyTotal = ref.watch(monthlyTotalProvider(now));
    final lastMonthTotal = ref.watch(monthlyTotalProvider(previousMonth));

    final breakdown = ref.watch(categoryBreakdownProvider(now));

    // Top Category
    final topCategory = breakdown.isEmpty
        ? 'None'
        : breakdown.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Average per day
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final avgPerDay = monthlyTotal / daysInMonth;

    // Month-over-month comparison
    final diff = monthlyTotal - lastMonthTotal;
    final diffLabel = '${diff >= 0 ? '+' : ''}\$${diff.toStringAsFixed(2)}';

    final stats = [
      {
        'label': 'Spent',
        'value': '\$${monthlyTotal.toStringAsFixed(2)}',
        'color': Theme.of(context).colorScheme.primary,
      },
      {
        'label': 'Receipts',
        'value': receipts.length.toString(),
        'color': Theme.of(context).colorScheme.secondary,
      },
      {
        'label': 'Expenses',
        'value': expenses.length.toString(),
        'color': Theme.of(context).colorScheme.tertiary,
      },
      {
        'label': 'Top Category',
        'value': topCategory,
        'color': Theme.of(context).colorScheme.primaryContainer,
      },
      {
        'label': 'Avg / Day',
        'value': '\$${avgPerDay.toStringAsFixed(2)}',
        'color': Theme.of(context).colorScheme.secondaryContainer,
      },
      {
        'label': 'MoM Change',
        'value': diffLabel,
        'color': diff >= 0
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      },
    ];

    return Scaffold(
      appBar: const ExpressiveTopBar(title: 'Dashboard'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 12),

            Text(
              'This Month',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 24),

            // Adaptive grid
            LayoutBuilder(
              builder: (context, constraints) {
                int columns = 2;

                if (constraints.maxWidth > 600) columns = 3;
                if (constraints.maxWidth > 900) columns = 4;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stats.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) {
                    final stat = stats[index];
                    return StatCard(
                      label: stat['label'] as String,
                      value: stat['value'] as String,
                      color: stat['color'] as Color,
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),

            Text('Overview', style: Theme.of(context).textTheme.headlineSmall),

            const SizedBox(height: 16),

            Text(
              'Your spending activity for the month is shown above. '
              'Category charts and daily totals are available in the charts section.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
