import 'package:expensevault/expressive_topbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'receipt_card.dart';
import 'receipts_providers.dart';

class ReceiptListScreen extends HookConsumerWidget {
  const ReceiptListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptsAsync = ref.watch(allReceiptsProvider);

    return Scaffold(
      appBar: const ExpressiveTopBar(title: 'Receipts'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: receiptsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (receipts) {
            if (receipts.isEmpty) {
              return const Center(
                child: Text('No receipts yet', style: TextStyle(fontSize: 18)),
              );
            }

            return ListView.builder(
              itemCount: receipts.length,
              itemBuilder: (_, i) {
                final r = receipts[i];

                return ReceiptCard(
                  id: r.id,
                  imagePath: r.imagePath,
                  title: r.ocrText?.split('\n').first ?? 'Receipt',
                  date: r.date,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
