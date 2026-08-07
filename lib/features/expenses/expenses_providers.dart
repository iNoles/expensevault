import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/database/database.dart';
import '../../data/database/expenses_dao.dart';

// ------------------------------------------------------------
// DATABASE + DAO
// ------------------------------------------------------------

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase(); // Must initialize synchronously
});

final expensesDaoProvider = Provider<ExpensesDao>((ref) {
  return ExpensesDao(ref.watch(appDatabaseProvider));
});

// ------------------------------------------------------------
// ALL EXPENSES (STREAM — INSTANT EMISSION)
// ------------------------------------------------------------

final allExpensesProvider = StreamProvider<List<Expense>>((ref) {
  final dao = ref.watch(expensesDaoProvider);
  return dao.watchAllExpenses(); // emits [] immediately
});

// ------------------------------------------------------------
// MONTHLY TOTAL (DERIVED — NO LOADING STATE)
// ------------------------------------------------------------

final monthlyTotalProvider = Provider.family<double, DateTime>((ref, month) {
  final expenses = ref.watch(allExpensesProvider).value ?? [];
  return calculateMonthlyTotal(expenses, month);
});

// ------------------------------------------------------------
// CATEGORY BREAKDOWN (DERIVED — NO LOADING STATE)
// ------------------------------------------------------------

final categoryBreakdownProvider =
    Provider.family<Map<String, double>, DateTime>((ref, month) {
      final expenses = ref.watch(allExpensesProvider).value ?? [];
      return calculateCategoryBreakdown(expenses, month);
    });

// ------------------------------------------------------------
// EXPENSES FOR A SPECIFIC RECEIPT (STREAM — INSTANT EMISSION)
// ------------------------------------------------------------

final expensesForReceiptProvider = StreamProvider.family<List<Expense>, String>(
  (ref, receiptId) {
    final dao = ref.watch(expensesDaoProvider);
    return dao.watchExpensesForReceipt(receiptId); // emits [] immediately
  },
);

// ------------------------------------------------------------
// DAILY TOTALS (DERIVED — NO LOADING STATE)
// ------------------------------------------------------------

final dailyTotalsProvider = Provider.family<Map<DateTime, double>, DateTime>((
  ref,
  month,
) {
  final expenses = ref.watch(allExpensesProvider).value ?? [];
  return calculateDailyTotals(expenses, month);
});

// ------------------------------------------------------------
// PURE FUNCTIONS (YOUR CALCULATIONS)
// ------------------------------------------------------------

double calculateMonthlyTotal(List<Expense> expenses, DateTime month) {
  return expenses
      .where((e) => e.date.year == month.year && e.date.month == month.month)
      .fold(0.0, (sum, e) => sum + e.amount);
}

Map<String, double> calculateCategoryBreakdown(
  List<Expense> expenses,
  DateTime month,
) {
  final map = <String, double>{};

  for (final e in expenses) {
    if (e.date.year == month.year && e.date.month == month.month) {
      map[e.categoryId] = (map[e.categoryId] ?? 0) + e.amount;
    }
  }

  return map;
}

Map<DateTime, double> calculateDailyTotals(
  List<Expense> expenses,
  DateTime month,
) {
  final map = <DateTime, double>{};

  for (final e in expenses) {
    if (e.date.year == month.year && e.date.month == month.month) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      map[day] = (map[day] ?? 0) + e.amount;
    }
  }

  return map;
}
