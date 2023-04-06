import 'package:flutter/material.dart';

class InlinePainter extends CustomPainter {
  const InlinePainter({
    required this.brush,
    required this.builder,
  });
  final Paint brush;
  final void Function(Paint paint, Canvas canvas, Rect rect) builder;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.save();
    builder(brush, canvas, rect);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
