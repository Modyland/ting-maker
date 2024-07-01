import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/util/logger.dart';
import 'package:ting_maker/util/overlay.dart';
import 'package:ting_maker/widget/sheet/community_sheet.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class CommunityRegiController extends GetxController {
  final TextEditingController contentController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  static CommunityRegiController get to => Get.find();
  final Rx<Map<String, dynamic>?> args = Rx(Get.arguments);

  Rx<String> regiSubject = Rx<String>('');
  Rx<String> regiTitle = Rx<String>('');
  Rx<String> regiContent = Rx<String>('');
  RxList<Uint8List> regiImage = RxList<Uint8List>([]);
  Rx<bool> isReady = Rx(false);

  Map<String, dynamic>? get getArgs => args.value;
  String get getSubject => regiSubject.value;
  bool get getReady => isReady.value;

  set setSubject(String v) => regiSubject(v);
  set setReady(bool b) => isReady(b);

  @override
  void onReady() async {
    super.onReady();
    if (getArgs == null) {
      await showSubjectSheetList();
    } else {
      setReady = true;
      contentController.text = getArgs?['content'];
      titleController.text = getArgs?['title'];
      setSubject = getArgs?['subject'];
      regiImage(getArgs?['img']);
    }
  }

  void readyCheck() {
    setReady =
        titleController.text.isNotEmpty && contentController.text.isNotEmpty;
  }

  Future<void> showSubjectSheetList() async {
    final subjectList = CommunityController.to.getSubjectList;

    await showSubjectSheet(
      subjectList.where((e) => e != '주제' && e != '인기글').toList(),
      (sub) {
        setSubject = sub;
        Get.back();
      },
    );
  }

  Future<void> registerSubmit() async {
    try {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
      final req = {
        "kind": "nboInsert",
        "id": NavigationProvider.to.getPerson.id,
        'useridx': NavigationProvider.to.getPerson.idx,
        "aka": NavigationProvider.to.getPerson.aka,
        'imgupDate': NavigationProvider.to.getPerson.imgupDate,
        "vilege": CustomNaverMapController.to.getReverseGeocoding,
        "subject": getSubject,
        "title": titleController.text,
        "content": contentController.text,
        "nboImg": regiImage.toList().isNotEmpty ? regiImage.toList() : null
      };

      final res = await service.nboInsert(req);
      final data = json.decode(res.bodyString!);

      if (data) {
        registerSuccess();
      }
    } catch (err) {
      Log.e(err);
      noTitleSnackbar(MyApp.normalErrorMsg);
    } finally {
      OverlayManager.hideOverlay();
    }
  }

  void registerSuccess() {
    CommunityController.to.nboList.clear();
    CommunityController.to.getPagingController.refresh();
    Get.back();
    if (getArgs == null) {
      noTitleSnackbar('게시글이 등록되었습니다.', time: 2);
    } else {
      noTitleSnackbar('게시글이 수정되었습니다.', time: 2);
    }
  }
}
