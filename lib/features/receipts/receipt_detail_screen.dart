import 'dart:io';
import 'package:expensevault/expressive_topbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../expenses/add_expenses_screen.dart';
import '../expenses/expenses_providers.dart';
import 'receipts_providers.dart';

class ReceiptDetailScreen extends HookConsumerWidget {
  final String receiptId;

  const ReceiptDetailScreen({super.key, required this.receiptId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptAsync = ref.watch(receiptByIdProvider(receiptId));
    final expensesAsync = ref.watch(expensesForReceiptProvider(receiptId));

    return Scaffold(
      appBar: const ExpressiveTopBar(title: 'Receipt Details'),
      body: receiptAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (receipt) {
          if (receipt == null) {
            return const Center(child: Text('Receipt not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(File(receipt.imagePath)),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        receipt.ocrText ?? 'No OCR text available',
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Expenses',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      expensesAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Text('Error: $err'),
                        data: (expenses) {
                          if (expenses.isEmpty) {
                            return const Text('No expenses added yet');
                          }

                          return Column(
                            children: expenses.map((e) {
                              return Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.categoryId,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(e.date.toString()),
                                        ],
                                      ),
                                      Text(
                                        '\$${e.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddExpenseScreen(receiptId: receiptId),
                      ),
                    );
                  },
                  child: const Text('Add Expense'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
