import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageCropScreen extends StatefulWidget {
  const ImageCropScreen({super.key});

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final _controller = CropController();
  final Uint8List _cropImage = Get.arguments['crop'];

  void cancelCrop() {
    Get.back(result: {'crop': false});
  }

  void successCrop() {
    _controller.crop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Crop(
        image: _cropImage,
        controller: _controller,
        onCropped: (image) {
          Get.back(result: {'crop': image});
        },
        withCircleUi: true,
        baseColor: const Color(0XFF00BFFE),
        maskColor: Colors.black45,
        progressIndicator: const CircularProgressIndicator(),
        cornerDotBuilder: (size, edgeAlignment) => const DotControl(
          color: Color(0XFF00BFFE),
        ),
        clipBehavior: Clip.hardEdge,
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () => cancelCrop(),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: ElevatedButton(
          child: const Text('Crop'),
          onPressed: () => successCrop(),
        ),
      )
    ]);
  }
}
