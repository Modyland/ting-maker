import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/controller/map_controller.dart';
import 'package:ting_maker/widget/common_appbar.dart';

enum Navigation { naverMap, community, place, chatting, info }

class NavigationProvider extends GetxService {
  static NavigationProvider get to => Get.find();
  final CustomNaverMapController _naverMapController =
      Get.find<CustomNaverMapController>();

  RxInt currentIndex = 0.obs;

  void changeIndex(int idx) {
    currentIndex(idx);
    if (currentIndex.value != Navigation.naverMap.index) {
      _naverMapController.stopCameraTimer();
      _naverMapController.stopPositionStream();
    }
  }

  PreferredSizeWidget selectAppBar(Navigation currentNavigation) {
    switch (currentNavigation) {
      case Navigation.naverMap:
        return mapAppbar('Naver Map');
      case Navigation.community:
        return mapAppbar('Community');
      case Navigation.place:
        return mapAppbar('Place');
      case Navigation.chatting:
        return mapAppbar('Chatting');
      case Navigation.info:
        return mapAppbar('Info');
    }
  }
}
