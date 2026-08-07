import 'dart:math';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final ColorScheme colorScheme;

  const PieChartWidget({
    super.key,
    required this.data,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No category data yet',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: CustomPaint(
        painter: _PieChartPainter(
          data: data,
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
            colorScheme.tertiary,
            colorScheme.error,
            colorScheme.surfaceTint,
          ],
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final List<Color> colors;

  _PieChartPainter({required this.data, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    double startAngle = -pi / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    int colorIndex = 0;

    data.forEach((_, value) {
      final sweepAngle = (value / total) * 2 * pi;
      paint.color = colors[colorIndex % colors.length].withValues(alpha: 0.85);

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      startAngle += sweepAngle;
      colorIndex++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
