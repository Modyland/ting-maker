import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/main.dart';
import 'package:ting_maker/service/navigation_service.dart';
import 'package:ting_maker/util/overlay.dart';
import 'package:ting_maker/widget/sheet/community_sheet.dart';
import 'package:ting_maker/widget/snackbar/snackbar.dart';

class CommunityRegiController extends GetxController {
  static CommunityRegiController get to => Get.find();
  Rx<String> regiSubject = Rx<String>('');
  Rx<String> regiTitle = Rx<String>('');
  Rx<String> regiContent = Rx<String>('');
  RxList<Uint8List> regiImage = RxList<Uint8List>([]);

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
        "vilege": CustomNaverMapController.to.getReverseGeocoding,
        "subject": getSubject,
        "title": getTitle,
        "content": getContent,
        "nboImg": regiImage.toList().isNotEmpty ? regiImage.toList() : null
      };

      final res = await service.nboInsert(req);
      final data = json.decode(res.bodyString!);

      if (data) {
        registerSuccess();
      }
    } catch (err) {
      noTitleSnackbar(MyApp.normalErrorMsg);
    } finally {
      OverlayManager.hideOverlay();
    }
  }

  void registerSuccess() {
    CommunityController.to.nboList.clear();
    CommunityController.to.getPagingController.refresh();
    Get.back();
    noTitleSnackbar('게시글이 등록되었습니다.', time: 2);
  }
}
