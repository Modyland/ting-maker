import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/widget/sheet/community_sheet.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class CommunityRegiController extends GetxController {
  final picker = ImagePicker();

  static CommunityRegiController get to => Get.find();
  Rx<String> regiSubject = Rx<String>('');
  Rx<String> regiTitle = Rx<String>('');
  Rx<String> regiContent = Rx<String>('');
  RxList<Uint8List> regiImage = RxList<Uint8List>();

  String get getSubject => regiSubject.value;
  String get getTitle => regiTitle.value;
  String get getContent => regiContent.value;

  set setSubject(String v) => regiSubject(v);
  set setTitle(String v) => regiTitle(v);
  set setContent(String v) => regiContent(v);

  @override
  void onReady() async {
    super.onReady();
    await showSubjectSheetList();
  }

  @override
  void onClose() {
    regiSubject.value = '';
    super.onClose();
  }

  Future<void> showSubjectSheetList() async {
    final subjectList = CommunityController.to.getSubjectList;

    await showSubjectSheet(
      subjectList.where((e) => e != '주제').toList(),
      (sub) async {
        Get.back();
        setSubject = sub;
      },
    );
  }

  Future showImageOptions() async {
    if (regiImage.toList().length >= 5) {
      noTitleSnackbar('최대 업로드 갯수는 5개 입니다.', time: 2);
      return;
    }
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('앨범에서 가져오기'),
            onPressed: () {
              Get.back();
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('사진 촬영하기'),
            onPressed: () {
              Get.back();
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickMultiImage(limit: 5);
    if (pickedFile.length > 5) {
      noTitleSnackbar('최대 업로드 갯수는 5개 입니다.', time: 2);
    }
    if (pickedFile.isNotEmpty) {
      final sliceFiles =
          pickedFile.sublist(0, pickedFile.length > 5 ? 5 : pickedFile.length);
      await loadImages(sliceFiles);
    }
  }

  Future<void> getImageFromCamera() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      regiImage.add(await pickedFile.readAsBytes());
    }
  }

  Future<void> loadImages(List<XFile> files) async {
    for (final item in files) {
      final bytes = await item.readAsBytes();
      if (regiImage.length < 5) {
        regiImage.add(bytes);
      }
    }
  }

  Future<void> registerSubmit() async {}
}
