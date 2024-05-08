import 'package:flutter/material.dart';

class BubblePointerPainter extends CustomPainter {
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;

  BubblePointerPainter({
    required this.borderColor,
    required this.backgroundColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final circleRadius = size.width / 2;
    canvas.drawCircle(
        Offset(circleRadius, circleRadius), circleRadius - borderWidth, paint);

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(circleRadius, circleRadius),
        circleRadius - borderWidth, borderPaint);

    final triPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;
    final path = Path();
    const triangleHeight = 3;
    final triangleBaseCenter = size.width / 2;
    path.moveTo(triangleBaseCenter, size.height + triangleHeight - borderWidth);
    path.lineTo(
        triangleBaseCenter - 4, size.height - triangleHeight - borderWidth);
    path.lineTo(
        triangleBaseCenter + 4, size.height - triangleHeight - borderWidth);
    path.close();

    canvas.drawPath(path, triPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
