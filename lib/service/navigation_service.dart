import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ting_maker/widget/common_appbar.dart';

enum Navigation { naverMap, community, place, chatting, info }

class NavigationProvider extends GetxService {
  static NavigationProvider get to => Get.find();

  RxInt currentIndex = 0.obs;

  void changeIndex(int idx) {
    currentIndex(idx);
  }

  PreferredSizeWidget selectAppBar(Navigation currentNavigation) {
    switch (currentNavigation) {
      case Navigation.naverMap:
        return mapAppbar(Navigation.naverMap, 'Naver Map');
      case Navigation.community:
        return mapAppbar(Navigation.community, 'Community');
      case Navigation.place:
        return mapAppbar(Navigation.place, 'Place');
      case Navigation.chatting:
        return mapAppbar(Navigation.chatting, 'Chatting');
      case Navigation.info:
        return mapAppbar(Navigation.chatting, 'Info');
    }
  }
}
