import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({
    super.key,
    required this.values,
    required this.goal,
    this.compact = false,
  });
  final List<double> values;
  final double goal;
  final bool compact;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: compact ? 80 : 185,
    child: CustomPaint(
      painter: _ChartPainter(values, goal, compact),
      child: const SizedBox.expand(),
    ),
  );
}

class _ChartPainter extends CustomPainter {
  _ChartPainter(this.values, this.goal, this.compact);
  final List<double> values;
  final double goal;
  final bool compact;
  @override
  void paint(Canvas canvas, Size size) {
    final bottom = size.height - (compact ? 14 : 28);
    final top = compact ? 8.0 : 20.0;
    final maxValue = math.max(
      1.0,
      math.max(goal * 1.2, values.reduce(math.max) * 1.15),
    );
    final minValue = compact
        ? math.min(goal, values.reduce(math.min)) * .9
        : 0.0;
    double y(double n) =>
        bottom - (n - minValue) / (maxValue - minValue) * (bottom - top);
    final paint = Paint()
      ..color = const Color(0xFFE6E6E6)
      ..strokeWidth = 1;
    for (var i = 0; i < values.length; i++) {
      final x = 12 + (size.width - 24) * i / (values.length - 1);
      canvas.drawLine(Offset(x, top), Offset(x, bottom), paint);
      if (!compact) {
        final text = TextPainter(
          text: TextSpan(
            text: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'][i],
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              fontFamily: 'SourceSans',
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        text.paint(canvas, Offset(x - text.width / 2, bottom + 12));
      }
    }
    paint
      ..color = compact ? const Color(0xFFFFB800) : AppColors.red
      ..strokeWidth = compact ? 2 : 4;
    canvas.drawLine(
      Offset(12, y(goal)),
      Offset(size.width - 12, y(goal)),
      paint,
    );
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = 12 + (size.width - 24) * i / (values.length - 1);
      if (i == 0) {
        path.moveTo(x, y(values[i]));
      } else {
        path.lineTo(x, y(values[i]));
      }
    }
    paint
      ..color = compact ? const Color(0xFFFFB800) : AppColors.blue
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paint);
    paint.style = PaintingStyle.fill;
    for (var i = 0; i < values.length; i++) {
      canvas.drawCircle(
        Offset(12 + (size.width - 24) * i / (values.length - 1), y(values[i])),
        compact ? 2 : 4,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => true;
}
