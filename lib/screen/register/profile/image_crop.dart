import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/button_style.dart';
import 'package:ting_maker/widget/common_style.dart';

class ImageCropScreen extends StatefulWidget {
  const ImageCropScreen({super.key});

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final _cropController = CropController();
  final Uint8List _cropImage = Get.arguments['crop'];

  void cancelCrop() {
    Get.back(result: {'crop': false});
  }

  void successCrop() {
    _cropController.cropCircle();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Crop(
          image: _cropImage,
          controller: _cropController,
          onCropped: (image) {
            Get.back(result: {'crop': image});
          },
          withCircleUi: true,
          baseColor: pointColor,
          maskColor: Colors.black45,
          progressIndicator:
              Center(child: CircularProgressIndicator(color: pointColor)),
          cornerDotBuilder: (size, edgeAlignment) => DotControl(
            color: pointColor,
          ),
          clipBehavior: Clip.hardEdge,
        ),
        Positioned(
          bottom: 15,
          left: 15,
          child: cropButton(
            '취소',
            Icon(
              Icons.arrow_back,
              color: errColor,
            ),
            cancelCrop,
          ),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: cropButton(
            '등록',
            Icon(
              Icons.check,
              color: okColor,
            ),
            successCrop,
          ),
        )
      ],
    );
  }
}
