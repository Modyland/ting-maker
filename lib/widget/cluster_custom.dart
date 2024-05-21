import 'package:flutter/material.dart';

class ClusterPainter extends CustomPainter {
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final ImageProvider<Object>? image;

  ClusterPainter({
    required this.borderColor,
    required this.backgroundColor,
    required this.borderWidth,
    this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final circleRadius = size.width / 2;

    if (image != null) {
      final ImageStream stream = image!.resolve(ImageConfiguration.empty);
      final listener = ImageStreamListener((ImageInfo info, bool _) {
        canvas.save();
        canvas.clipPath(Path()
          ..addOval(Rect.fromCircle(
            center: Offset(circleRadius, circleRadius),
            radius: circleRadius - borderWidth,
          )));

        // 이미지 그리기
        paintImage(
          canvas: canvas,
          image: info.image,
          rect: Rect.fromCircle(
            center: Offset(circleRadius, circleRadius),
            radius: circleRadius - borderWidth,
          ),
          fit: BoxFit.cover,
        );

        // 클리핑 해제
        canvas.restore();
      });
      stream.addListener(listener);
      stream.removeListener(listener);
    } else {
      // 이미지가 없을 경우 기존 배경색으로 채우기
      final paint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(circleRadius, circleRadius),
          circleRadius - borderWidth, paint);
    }

    // 테두리 그리기
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(circleRadius, circleRadius),
        circleRadius - borderWidth, borderPaint);

    // 삼각형 그리기
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
    return oldDelegate != this;
  }
}
