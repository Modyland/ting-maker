import 'dart:typed_data';

import 'package:get/get.dart';

class ImageProfileController extends GetxController {
  final Rx<Uint8List?> _finishCropImage = Rx<Uint8List?>(null);

  Uint8List? get finishCropImage => _finishCropImage.value;

  void setFinishCropImage(Uint8List? image) {
    _finishCropImage.value = image;
  }
}
