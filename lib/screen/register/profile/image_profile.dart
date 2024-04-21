import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ting_maker/screen/register/register3.dart';
import 'package:ting_maker/widget/common_style.dart';

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = grey400
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const double angle = pi / 2.9;

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Path path = Path()
      ..moveTo(center.dx + radius * cos(angle), center.dy + radius * sin(angle))
      ..addArc(rect, angle, 2 * pi - 0.55 * angle);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ImageProfile extends StatefulWidget {
  const ImageProfile({super.key});

  @override
  State<ImageProfile> createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  late Uint8List _cropImage;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage = await XFile(pickedFile.path).readAsBytes();
      final finishCrop =
          await Get.toNamed('/image_crop', arguments: {'crop': _cropImage});
      if (finishCrop != null && finishCrop['crop'] is Uint8List) {
        setState(() {
          imageProfileController.setFinishCropImage = finishCrop['crop'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              getImage();
            },
            child: CustomPaint(
              painter: BorderPainter(),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.transparent,
                backgroundImage: imageProfileController.getFinishCropImage ==
                        null
                    ? const AssetImage('assets/image/profile.png')
                    : MemoryImage(imageProfileController.getFinishCropImage!)
                        as ImageProvider<Object>,
              ),
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
    );
  }
}
