import 'package:expensevault/expressive_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'expenses_providers.dart';

class AddExpenseScreen extends HookConsumerWidget {
  final String receiptId;

  const AddExpenseScreen({super.key, required this.receiptId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryController = useTextEditingController();
    final amountController = useTextEditingController();
    final date = useState<DateTime>(DateTime.now());
    final isSaving = useState(false);

    Future<void> pickDate() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: date.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) date.value = picked;
    }

    Future<void> saveExpense() async {
      final category = categoryController.text.trim();
      final amount = double.tryParse(amountController.text.trim());

      if (category.isEmpty || amount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter valid category and amount')),
        );
        return;
      }

      isSaving.value = true;

      final dao = ref.read(expensesDaoProvider);
      await dao.insertExpense(
        id: const Uuid().v4(),
        receiptId: receiptId,
        categoryId: category,
        amount: amount,
        date: date.value,
      );

      isSaving.value = false;
      if (context.mounted) Navigator.pop(context);
    }

    return Scaffold(
      appBar: const ExpressiveTopBar(title: 'Add Expense'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${date.value.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 18),
                ),
                TextButton(onPressed: pickDate, child: const Text('Pick Date')),
              ],
            ),

            const Spacer(),

            isSaving.value
                ? const CircularProgressIndicator()
                : FilledButton(
                    onPressed: saveExpense,
                    child: const Text('Save Expense'),
                  ),
          ],
        ),
      ),
    );
  }
}
