import 'package:uuid/uuid.dart';

import '../../data/database/database.dart';
import '../../data/database/receipts_dao.dart';
import '../../data/ocr/ocr_service.dart';

class ReceiptController {
  final ReceiptsDao receiptsDao;
  final OcrService ocr;

  ReceiptController(this.receiptsDao, this.ocr);

  Future<void> createReceipt(String imagePath) async {
    final text = await ocr.extractText(imagePath);

    await receiptsDao.insertReceipt(
      Receipt(
        id: const Uuid().v4(),
        imagePath: imagePath,
        ocrText: text,
        date: DateTime.now(),
      ),
    );
  }
}
