import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final Map<DateTime, double> data;
  final ColorScheme colorScheme;

  const LineChartWidget({
    super.key,
    required this.data,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No daily totals yet',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: CustomPaint(
        painter: _LineChartPainter(
          points: data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
          color: colorScheme.primary,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<MapEntry<DateTime, double>> points;
  final Color color;

  _LineChartPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final maxY = points.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minY = 0.0;

    final dx = size.width / (points.length - 1);

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < points.length; i++) {
      final x = dx * i;
      final y =
          size.height -
          ((points[i].value - minY) / (maxY - minY)) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prevX = dx * (i - 1);
        final prevY =
            size.height -
            ((points[i - 1].value - minY) / (maxY - minY)) * size.height;

        final controlX = (prevX + x) / 2;

        path.cubicTo(controlX, prevY, controlX, y, x, y);
        fillPath.cubicTo(controlX, prevY, controlX, y, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0.05)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
