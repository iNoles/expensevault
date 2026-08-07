import 'dart:io';
import 'package:expensevault/expressive_topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'receipts_providers.dart';

class AddReceiptScreen extends HookConsumerWidget {
  const AddReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageFile = useState<File?>(null);
    final isScanning = useState(false);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) imageFile.value = File(picked.path);
    }

    Future<void> scanAndSave() async {
      if (imageFile.value == null) return;
      isScanning.value = true;

      final controller = ref.read(receiptControllerProvider);
      await controller.createReceipt(imageFile.value!.path);

      isScanning.value = false;
      if (context.mounted) Navigator.pop(context);
    }

    return Scaffold(
      appBar: const ExpressiveTopBar(title: 'Add Receipt'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: imageFile.value == null
                      ? const Text(
                          'No image selected',
                          style: TextStyle(fontSize: 18),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(imageFile.value!),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            if (isScanning.value)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  FilledButton(
                    onPressed: pickImage,
                    child: const Text('Pick Image'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: scanAndSave,
                    child: const Text('Scan and Save'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
