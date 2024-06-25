import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ting_maker/widget/common_style.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class ImagePickerProvider {
  static final picker = ImagePicker();

  static Future<void> showImageOptions(
    BuildContext context,
    RxList<Uint8List> list, {
    int? maxLength,
  }) async {
    if (maxLength != null) {
      if (list.toList().length >= maxLength) {
        noTitleSnackbar('최대 업로드 갯수는 5개 입니다.', time: 2);
        return;
      }
    } else {
      if (list.toList().isNotEmpty) {
        noTitleSnackbar('최대 업로드 갯수는 1개 입니다.', time: 2);
        return;
      }
    }
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              '앨범에서 가져오기',
              style: TextStyle(color: pointColor),
            ),
            onPressed: () {
              Get.back();
              getImageFromGallery(list, maxLength: maxLength);
            },
          ),
          CupertinoActionSheetAction(
            child: Text('사진 촬영하기', style: TextStyle(color: pointColor)),
            onPressed: () {
              Get.back();
              getImageFromCamera(list);
            },
          ),
        ],
      ),
    );
  }

  static Future<void> getImageFromGallery(
    RxList<Uint8List> list, {
    int? maxLength,
  }) async {
    if (maxLength != null) {
      final List<XFile> pickedFile =
          await picker.pickMultiImage(limit: maxLength, imageQuality: 30);
      if (pickedFile.length > maxLength) {
        noTitleSnackbar('최대 업로드 갯수는 5개 입니다.', time: 2);
      }
      if (pickedFile.isNotEmpty) {
        final sliceFiles = pickedFile.sublist(
            0, pickedFile.length > 5 ? 5 : pickedFile.length);
        await loadImages(list, sliceFiles);
      }
    } else {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 30);
      if (pickedFile != null) {
        Uint8List data = await pickedFile.readAsBytes();
        list.add(data);
      }
    }
  }

  static Future<void> getImageFromCamera(RxList<Uint8List> list) async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 30);
    if (pickedFile != null) {
      Uint8List data = await pickedFile.readAsBytes();
      list.add(data);
    }
  }

  static Future<void> loadImages(
      RxList<Uint8List> list, List<XFile> files) async {
    for (final item in files) {
      final stream = item.openRead();
      final bytes = await stream.toBytes();
      if (list.length < 5) {
        list.add(bytes);
      }
    }
  }
}
