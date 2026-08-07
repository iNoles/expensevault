import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'expenses_dao.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpensesDao extends DatabaseAccessor<AppDatabase>
    with _$ExpensesDaoMixin {
  ExpensesDao(super.db);

  // ------------------------------------------------------------
  // STREAM: ALL EXPENSES (offline-first)
  // ------------------------------------------------------------
  Stream<List<Expense>> watchAllExpenses() {
    return (select(
      expenses,
    )..orderBy([(e) => OrderingTerm.desc(e.date)])).watch();
  }

  // ------------------------------------------------------------
  // STREAM: EXPENSES FOR RECEIPT (offline-first)
  // ------------------------------------------------------------
  Stream<List<Expense>> watchExpensesForReceipt(String receiptId) {
    return (select(expenses)
          ..where((e) => e.receiptId.equals(receiptId))
          ..orderBy([(e) => OrderingTerm.desc(e.date)]))
        .watch();
  }

  // ------------------------------------------------------------
  // MONTHLY TOTAL (future — derived later)
  // ------------------------------------------------------------
  Future<double> monthlyTotal(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final rows = await (select(
      expenses,
    )..where((e) => e.date.isBetweenValues(start, end))).get();

    return rows.fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  // ------------------------------------------------------------
  // CATEGORY TOTAL FOR A MONTH
  // ------------------------------------------------------------
  Future<double> categoryTotal(String categoryId, DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final rows =
        await (select(expenses)
              ..where((e) => e.categoryId.equals(categoryId))
              ..where((e) => e.date.isBetweenValues(start, end)))
            .get();

    return rows.fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  // ------------------------------------------------------------
  // DAILY TOTALS FOR CHARTING
  // ------------------------------------------------------------
  Future<Map<DateTime, double>> dailyTotals(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final rows = await (select(
      expenses,
    )..where((e) => e.date.isBetweenValues(start, end))).get();

    final map = <DateTime, double>{};

    for (final e in rows) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      map[day] = (map[day] ?? 0.0) + e.amount;
    }

    return map;
  }

  // ------------------------------------------------------------
  // CATEGORY BREAKDOWN FOR PIE CHARTS
  // ------------------------------------------------------------
  Future<Map<String, double>> categoryBreakdown(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final rows = await (select(
      expenses,
    )..where((e) => e.date.isBetweenValues(start, end))).get();

    final map = <String, double>{};

    for (final e in rows) {
      map[e.categoryId] = (map[e.categoryId] ?? 0.0) + e.amount;
    }

    return map;
  }

  // ------------------------------------------------------------
  // FUTURE: EXPENSES FOR RECEIPT (still available)
  // ------------------------------------------------------------
  Future<List<Expense>> getExpensesForReceipt(String receiptId) {
    return (select(
      expenses,
    )..where((e) => e.receiptId.equals(receiptId))).get();
  }

  // ------------------------------------------------------------
  // FUTURE: ALL EXPENSES (still available)
  // ------------------------------------------------------------
  Future<List<Expense>> getAllExpenses() {
    return select(expenses).get();
  }

  // ------------------------------------------------------------
  // INSERT
  // ------------------------------------------------------------
  Future<void> insertExpense({
    required String id,
    required String receiptId,
    required String categoryId,
    required double amount,
    required DateTime date,
  }) async {
    await into(expenses).insert(
      ExpensesCompanion.insert(
        id: id,
        receiptId: Value(receiptId),
        categoryId: categoryId,
        amount: amount,
        date: date,
      ),
    );
  }
}
