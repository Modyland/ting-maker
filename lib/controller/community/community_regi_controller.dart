import 'package:get/get.dart';
import 'package:ting_maker/controller/community_controller.dart';
import 'package:ting_maker/widget/sheet/community_sheet.dart';

class CommunityRegiController extends GetxController {
  static CommunityRegiController get to => Get.find();
  Rx<String> regiSubject = Rx<String>('');

  String get getRegiSubject => regiSubject.value;

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
        regiSubject.value = sub;
      },
    );
  }
}
