import 'dart:io';

import 'package:flutter/material.dart';

import 'receipt_detail_screen.dart';

class ReceiptCard extends StatelessWidget {
  final String id;
  final String imagePath;
  final String title;
  final DateTime date;

  const ReceiptCard({
    super.key,
    required this.id,
    required this.imagePath,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReceiptDetailScreen(receiptId: id)),
        );
      },
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              // Image preview
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(imagePath),
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 20),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date.toLocal().toString().split(' ')[0],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Color accent bar
              Container(
                width: 6,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
