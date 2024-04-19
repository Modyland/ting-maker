import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xffD9D9D9)
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const double angle = pi / 2.9;

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Path path = Path()
      ..moveTo(center.dx + radius * cos(angle), center.dy + radius * sin(angle))
      ..addArc(rect, angle, 2 * pi - 0.55 * angle);

    // 완성된 경로를 사용하여 그립니다.
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}

class ImageProfile extends StatefulWidget {
  const ImageProfile({super.key});

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future getImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          getImage();
        },
        child: Stack(
          children: [
            CustomPaint(
              painter: BorderPainter(),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.transparent,
                backgroundImage: _image == null
                    ? const AssetImage('assets/image/profile.png')
                    : FileImage(File(_image!.path)) as ImageProvider<Object>,
              ),
            ),
            const Positioned(
              bottom: 10,
              right: 10,
              child: ClipRect(
                  child: Icon(
                Icons.camera_alt_outlined,
                size: 30,
              )),
            )
          ],
        ),
      ),
    );
  }
}
