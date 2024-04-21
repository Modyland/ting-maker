import 'dart:typed_data';

import 'package:get/get.dart';

class ImageProfileController extends GetxController with StateMixin {
  final Rx<Uint8List?> _finishCropImage = Rx<Uint8List?>(null);

  Uint8List? get getFinishCropImage => _finishCropImage.value;

  set setFinishCropImage(Uint8List? image) => _finishCropImage.value = image;
}
