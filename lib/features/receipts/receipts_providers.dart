// Database
import 'package:riverpod/riverpod.dart';

import '../../data/database/database.dart';
import '../../data/database/receipts_dao.dart';
import '../../data/ocr/ocr_service.dart';
import 'receipt_controller.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// DAO
final receiptsDaoProvider = Provider<ReceiptsDao>((ref) {
  return ReceiptsDao(ref.watch(appDatabaseProvider));
});

// OCR
final ocrServiceProvider = Provider<OcrService>((ref) {
  return OcrService();
});

final receiptByIdProvider = FutureProvider.family((ref, String id) {
  final dao = ref.watch(receiptsDaoProvider);
  return dao.getReceiptById(id);
});

final allReceiptsProvider = FutureProvider((ref) {
  final dao = ref.watch(receiptsDaoProvider);
  return dao.getAllReceipts();
});

// Controller
final receiptControllerProvider = Provider<ReceiptController>((ref) {
  return ReceiptController(
    ref.watch(receiptsDaoProvider),
    ref.watch(ocrServiceProvider),
  );
});
