import 'package:drift/drift.dart';

import 'database.dart';
import 'tables.dart';

part 'receipts_dao.g.dart';

@DriftAccessor(tables: [Receipts])
class ReceiptsDao extends DatabaseAccessor<AppDatabase>
    with _$ReceiptsDaoMixin {
  ReceiptsDao(super.db);

  Future<void> insertReceipt(Receipt receipt) {
    return into(receipts).insert(receipt);
  }

  Future<List<Receipt>> getAllReceipts() {
    return (select(
      receipts,
    )..orderBy([(r) => OrderingTerm.desc(r.date)])).get();
  }

  Future<Receipt?> getReceiptById(String id) {
    return (select(receipts)..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  Future<void> deleteReceipt(String id) {
    return (delete(receipts)..where((r) => r.id.equals(id))).go();
  }
}
