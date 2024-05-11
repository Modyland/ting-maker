import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/common_style.dart';

class CommunityController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxString nowTab = 'id'.obs;

  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: nowTab.value == 'id' ? 0 : 1,
    animationDuration: const Duration(milliseconds: 300),
  );

  String get getTab => nowTab.value;

  TabBar tabBar() {
    return TabBar(
      controller: tabController,
      overlayColor: const MaterialStatePropertyAll(
        Colors.transparent,
      ),
      indicatorColor: pointColor,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 2,
      labelColor: Colors.black,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelColor: grey300,
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
      ),
      tabs: const [
        Tab(text: "아이디 찾기"),
        Tab(text: "비밀번호 재설정"),
      ],
    );
  }

  @override
  void onInit() {
    super.onInit();
    tabController.addListener(handleTabChange);
  }

  @override
  void onClose() {
    //
    super.onClose();
  }

  void handleTabChange() {
    if (tabController.index == 0) {
      nowTab('id');
    } else if (tabController.index == 1) {
      nowTab('pwd');
    }
  }
}
